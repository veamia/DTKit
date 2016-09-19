//
//  UIViewController+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Expand)

- (UIViewController *)topestViewController;
//获取当前屏幕中present出来的viewcontroller。
+ (UIViewController *)getPresentedViewController;
- (UIViewController *)topPresentedViewController;

// 第一个UIViewController
+ (UIViewController *)firstViewController;
// 当前的UIViewController
+ (UIViewController *)currentViewController;

+ (void)backToRootViewController;

// 是否支持3DTouch
- (BOOL)support3DTouch;

@end
