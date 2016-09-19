//
//  DTTools.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// 是否竖屏
static inline BOOL isPortrait() {
    UIInterfaceOrientation orientation =
    [UIApplication sharedApplication].statusBarOrientation;
    return orientation == UIInterfaceOrientationPortrait ||
           orientation == UIInterfaceOrientationPortraitUpsideDown;
}

// 是否横屏
static inline BOOL isLandscape() {
    UIInterfaceOrientation orientation =
    [UIApplication sharedApplication].statusBarOrientation;
    return orientation == UIInterfaceOrientationLandscapeLeft ||
           orientation == UIInterfaceOrientationLandscapeRight;
}

// 角度转幅度
static inline CGFloat degreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

// 幅度装角度
static inline CGFloat radiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

// 屏幕尺寸，分辨率，模式
CGSize  screenSize();
CGFloat screenScale();
UIScreenMode *currentMode();

// 竖屏的宽度
static inline CGFloat screenWidth() {
    return screenSize().width;
}

// 竖屏的高度
static inline CGFloat screenHeight() {
    return screenSize().height;
}

// 是否是这个尺寸
static inline BOOL isScreenSize(CGSize size) {
    if ([UIScreen instanceMethodForSelector:@selector(currentMode)]) {
        return CGSizeEqualToSize(size, currentMode().size);
    }
    return NO;
}

// 获取rect的中心点
static inline CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

// 获取rect的面积
static inline CGFloat CGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

// 计算两点之间的距离
static inline CGFloat CGPointGetDistanceToPoint(CGPoint p1, CGPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}



