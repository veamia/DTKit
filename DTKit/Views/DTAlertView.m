//
//  DTAlertView.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTAlertView.h"
#import "DTSingleton.h"
#import "DTKitMacro.h"
#import "DTShadowView.h"
#import "UIViewController+Expand.h"

@interface DTAlertView ()
- (void)show;
@end

@interface DTAlertViewManager : NSObject
dt_Singleton_ITF( DTAlertViewManager )
@property (nonatomic, strong) NSMutableArray *alerts;
- (void)showAlert;
@end

@implementation DTAlertViewManager

dt_Singleton_IMP( DTAlertViewManager )

- (instancetype)init
{
    self = [super init];
    if (self) {
        _alerts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addAlertController:(DTAlertView *)alert
{
    if (self.alerts.count == 0) {
        [self.alerts addObject:alert];
        [self showAlert];
    } else {
        [self.alerts addObject:alert];
    }
}

- (void)showAlert
{
    DTAlertView *alert = self.alerts.firstObject;
    if (!alert) return;
    [alert show];
}

@end

@implementation DTAlertView

- (void)dismissViewControllerAnimated:(BOOL)flag
                           completion:(void (^)(void))completion
{}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DTAlertViewManager sharedInstance].alerts removeObject:self];
    [[DTAlertViewManager sharedInstance] showAlert];
}

- (void)show
{
    [DTShadowView hide];
    UIViewController *controller = [UIViewController firstViewController];
    if (!controller) {
        controller = dtKeyWindow.rootViewController;
    }
    [controller presentViewController:self animated:YES completion:NULL];
}

+ (DTAlertView *)alert:(NSString *)title
               message:(NSString *)message
               isAlert:(BOOL)isAlert
{
    DTAlertView *alert = [DTAlertView alertControllerWithTitle:title
                                                       message:message
                                                preferredStyle:isAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    [alert addAction:cancelAction];
    return alert;
}

+ (void)simpleAlert:(NSString *)title message:(NSString *)message
{
    DTAlertView *alert = [DTAlertView alertControllerWithTitle:title
                                                       message:message
                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    [alert addAction:cancelAction];
    [self presentAlert:alert];
}

+ (void)presentAlert:(DTAlertView *)alert
{
    [[DTAlertViewManager sharedInstance] addAlertController:alert];
}

@end
