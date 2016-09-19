//
//  DTNetworkInfo.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DTNoNetworkNotification;
extern NSString *const DTHasNetworkNotification;
extern NSString *const DTWiFiNetworkNotification;
extern NSString *const DTWWANNetworkNotification;
extern NSString *const DTNetworkChangeNotification;

typedef NS_ENUM(NSUInteger, DTNetworkType) {
    DTNetworkTypeNone = 0,
    DTNetworkTypeWWAN = 1,
    DTNetworkTypeWiFi = 2,
};

typedef NS_ENUM(NSUInteger, DTNetworkWWANType) {
    DTNetworkWWANTypeNone = 0,
    DTNetworkWWANType2G   = 2,
    DTNetworkWWANType3G   = 3,
    DTNetworkWWANType4G   = 4,
};

@interface DTNetworkInfo : NSObject

+ (DTNetworkType)networkType;
+ (DTNetworkWWANType)networkWWANType;

+ (BOOL)isReachable;
+ (BOOL)isReachableViaWIFI;
+ (BOOL)isReachableViaWLAN;

@end
