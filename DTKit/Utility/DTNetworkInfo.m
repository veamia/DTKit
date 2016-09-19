//
//  DTNetworkInfo.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTNetworkInfo.h"
#import "DTSingleton.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString *const DTNoNetworkNotification = @"NoNetworkNotification";
NSString *const DTHasNetworkNotification = @"HasNetworkNotification";
NSString *const DTWiFiNetworkNotification = @"WiFiNetworkNotification";
NSString *const DTWWANNetworkNotification = @"WWANNetworkNotification";
NSString *const DTNetworkChangeNotification = @"NetworkChangeNotification";

typedef NS_ENUM(NSUInteger, DTReachabilityStatus) {
    DTReachabilityStatusNone = 0,
    DTReachabilityStatusWWAN = 1,
    DTReachabilityStatusWiFi = 2,
};

typedef NS_ENUM(NSUInteger, DTReachabilityWWANStatus) {
    DTReachabilityWWANStatusNone = 0,
    DTReachabilityWWANStatus2G   = 2,
    DTReachabilityWWANStatus3G   = 3,
    DTReachabilityWWANStatus4G   = 4,
};

@interface DTReachability : NSObject

@property (nonatomic, readonly) SCNetworkReachabilityFlags flags;
@property (nonatomic, readonly) DTReachabilityStatus status;
@property (nonatomic, readonly) DTReachabilityWWANStatus wwanStatus
NS_AVAILABLE_IOS(7_0);

@property (nonatomic, readonly, getter=isReachable) BOOL reachable;
@property (nonatomic, copy) void (^notifyBlock)(DTReachability *reachability);

@property (nonatomic, assign) SCNetworkReachabilityRef ref;
@property (nonatomic, assign) BOOL scheduled;
@property (nonatomic, assign) BOOL allowWWAN;
@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;

+ (instancetype)reachability;
+ (instancetype)reachabilityForLocalWiFi;
+ (instancetype)reachabilityWithHostname:(NSString *)hostname;
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

@end

static DTReachabilityStatus DTReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN) {
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
        return DTReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
        (flags & kSCNetworkReachabilityFlagsTransientConnection)) {
        return DTReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN) {
        return DTReachabilityStatusWWAN;
    }
    
    return DTReachabilityStatusWiFi;
}

static void DTReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    DTReachability *self = ((__bridge DTReachability *)info);
    if (self.notifyBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifyBlock(self);
        });
    }
}

@implementation DTReachability

+ (dispatch_queue_t)sharedQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.2026.device.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (instancetype)init {
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    return [self initWithRef:ref];
}

- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref {
    if (!ref) return nil;
    self = super.init;
    if (!self) return nil;
    _ref = ref;
    _allowWWAN = YES;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        _networkInfo = [CTTelephonyNetworkInfo new];
    }
    return self;
}

- (void)dealloc {
    self.notifyBlock = nil;
    self.scheduled = NO;
    CFRelease(self.ref);
}

- (void)setScheduled:(BOOL)scheduled {
    if (_scheduled == scheduled) return;
    _scheduled = scheduled;
    if (scheduled) {
        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
        SCNetworkReachabilitySetCallback(self.ref, DTReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(self.ref, [self.class sharedQueue]);
    } else {
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}

- (SCNetworkReachabilityFlags)flags {
    SCNetworkReachabilityFlags flags = 0;
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}

- (DTReachabilityStatus)status {
    return DTReachabilityStatusFromFlags(self.flags, self.allowWWAN);
}

- (DTReachabilityWWANStatus)wwanStatus {
    if (!self.networkInfo) return DTReachabilityWWANStatusNone;
    NSString *status = self.networkInfo.currentRadioAccessTechnology;
    if (!status) return DTReachabilityWWANStatusNone;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS : @(DTReachabilityWWANStatus2G),  // 2.5G   171Kbps
                CTRadioAccessTechnologyEdge : @(DTReachabilityWWANStatus2G),  // 2.75G  384Kbps
                CTRadioAccessTechnologyWCDMA : @(DTReachabilityWWANStatus3G), // 3G     3.6Mbps/384Kbps
                CTRadioAccessTechnologyHSDPA : @(DTReachabilityWWANStatus3G), // 3.5G   14.4Mbps/384Kbps
                CTRadioAccessTechnologyHSUPA : @(DTReachabilityWWANStatus3G), // 3.75G  14.4Mbps/5.76Mbps
                CTRadioAccessTechnologyCDMA1x : @(DTReachabilityWWANStatus3G), // 2.5G
                CTRadioAccessTechnologyCDMAEVDORev0 : @(DTReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA : @(DTReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB : @(DTReachabilityWWANStatus3G),
                CTRadioAccessTechnologyeHRPD : @(DTReachabilityWWANStatus3G),
                CTRadioAccessTechnologyLTE : @(DTReachabilityWWANStatus4G)}; // LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
    });
    NSNumber *num = dic[status];
    if (num) return num.unsignedIntegerValue;
    else return DTReachabilityWWANStatusNone;
}

- (BOOL)isReachable {
    return self.status != DTReachabilityStatusNone;
}

+ (instancetype)reachability {
    return self.new;
}

+ (instancetype)reachabilityForLocalWiFi {
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    DTReachability *one = [self reachabilityWithAddress:&localWifiAddress];
    one.allowWWAN = NO;
    return one;
}

+ (instancetype)reachabilityWithHostname:(NSString *)hostname {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return [[self alloc] initWithRef:ref];
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self alloc] initWithRef:ref];
}

- (void)setNotifyBlock:(void (^)(DTReachability *reachability))notifyBlock {
    _notifyBlock = [notifyBlock copy];
    self.scheduled = (self.notifyBlock != nil);
}

@end

@interface DTNetworkInfo ()
dt_Singleton_ITF( TCNetworkInfo )

@property (nonatomic, strong) DTReachability *reach;
@property (nonatomic) NSInteger reachCount;

@end

@implementation DTNetworkInfo

+ (void)load {
    [DTNetworkInfo sharedInstance];
}

dt_Singleton_IMP( TCNetworkInfo )

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.reachCount = 0;
        self.reach = [DTReachability reachabilityWithHostname:@"www.baidu.com"];
        typeof(self) __weak weakSelf = self;
        self.reach.notifyBlock = ^(DTReachability *reach) {
            [weakSelf networkChanged];
        };
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.reach = nil;
}

- (BOOL)isReachable
{
    return self.reach.isReachable;
}

+ (DTNetworkType)networkType
{
    return (DTNetworkType)[DTNetworkInfo sharedInstance].reach.status;
}

+ (DTNetworkWWANType)networkWWANType
{
    return (DTNetworkWWANType)[DTNetworkInfo sharedInstance].reach.wwanStatus;
}

+ (BOOL)isReachable
{
    return [[DTNetworkInfo sharedInstance] isReachable];
}

- (BOOL)isReachableViaWIFI
{
    if ( NO == [self.reach isReachable] )
    {
        return NO;
    }
    
    return self.reach.status == DTReachabilityStatusWiFi;
}

+ (BOOL)isReachableViaWIFI
{
    return [[DTNetworkInfo sharedInstance] isReachableViaWIFI];
}

- (BOOL)isReachableViaWLAN
{
    if ( NO == [self.reach isReachable] )
    {
        return NO;
    }
    
    return self.reach.status == DTReachabilityStatusWWAN;
}

+ (BOOL)isReachableViaWLAN
{
    return [[DTNetworkInfo sharedInstance] isReachableViaWLAN];
}

- (void)networkChanged
{
    _reachCount ++;
    if (_reachCount == 1) return;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if ( NO == [self isReachable] ) {
        [center postNotificationName:DTNoNetworkNotification object:nil];
    } else {
        if ( [self isReachableViaWIFI] ) {
            [center postNotificationName:DTWiFiNetworkNotification object:nil];
        }
        else if ( [self isReachableViaWLAN] ) {
            [center postNotificationName:DTWWANNetworkNotification object:nil];
        }
        [center postNotificationName:DTHasNetworkNotification object:nil];
    }
    
    [center postNotificationName:DTNetworkChangeNotification object:nil];
}

@end
