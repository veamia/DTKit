//
//  UIViewController+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIViewController+Expand.h"
#import "DTKitMacro.h"

@implementation UIViewController (Expand)

- (UIViewController *)topestViewController
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topestViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController *)self;
        return [[tab selectedViewController] topestViewController];
    }
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav visibleViewController] topestViewController];
    }
    
    return self;
}

+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    
    if (topVC.presentedViewController) {
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
    } else {
        return nil;
    }
    
    return topVC;
}

- (UIViewController *)topPresentedViewController
{
    UIViewController *presentedVC = self;
    if (presentedVC.presentedViewController) {
        while (presentedVC.presentedViewController) {
            presentedVC = presentedVC.presentedViewController;
        }
    } else {
        return nil;
    }
    return presentedVC;
}

+ (UIViewController *)firstViewController
{
    UIViewController *appRootVC = dtKeyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)appRootVC;
        UIViewController *curTapVC = tab.viewControllers.firstObject;
        if ([curTapVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)curTapVC;
            return navi.viewControllers.firstObject;
        }
    } else if ([appRootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)appRootVC;
        return navi.viewControllers.firstObject;
    }
    return appRootVC;
}

- (UIViewController *)currentViewController
{
    UIViewController *vc = self;
    UIViewController *lastVC = vc;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        UIViewController *curTapVC = tab.selectedViewController;
        if ([curTapVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)curTapVC;
            lastVC = navi.viewControllers.lastObject;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navi = (UINavigationController *)vc;
        lastVC = navi.viewControllers.lastObject;
    }
    
    UIViewController *presentVC = [lastVC topPresentedViewController];
    if (presentVC) {
        return [presentVC currentViewController];
    }
    return lastVC;
}

+ (UIViewController *)currentViewController
{
    UIViewController *appRootVC = dtKeyWindow.rootViewController;
    return [appRootVC currentViewController];
}

+ (void)backToRootViewController
{
    UIViewController *vc = [self getPresentedViewController];
    if (vc) {
        [vc dismissViewControllerAnimated:NO completion:^{
            [self backToRootViewController];
        }];
    } else {
        UIViewController *appRootVC = dtKeyWindow.rootViewController;
        if ([appRootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)appRootVC;
            UIViewController *curTapVC = tab.selectedViewController;
            if ([curTapVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navi = (UINavigationController *)curTapVC;
                [navi popToRootViewControllerAnimated:NO];
                tab.selectedIndex = 0;
            }
        } else if ([appRootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)appRootVC;
            [navi popToRootViewControllerAnimated:NO];
        }
    }
}

- (BOOL)support3DTouch
{
    // 如果开启了3D touch
    if (dtIOS9UP) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            return YES;
        }
    }
    return NO;
}

@end
