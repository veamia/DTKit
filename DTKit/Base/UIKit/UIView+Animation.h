//
//  UIView+Animation.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DTDirection) {
    DTDirectionTop,
    DTDirectionBottom,
    DTDirectionLeft,
    DTDirectionRight,
};

@interface UIView (Animation)

//揭开
- (void)animationReveal:(DTDirection)direction;

//渐隐渐消
- (void)animationFade;

//翻转
- (void)animationFlip:(DTDirection)direction;

//旋转缩放
- (void)animationRotateAndScaleEffects;//各种旋转缩放效果。
- (void)animationRotateAndScaleDownUp;//旋转同时缩小放大效果

//push
- (void)animationPush:(DTDirection)direction;

//Curl UnCurl
- (void)animationCurl:(DTDirection)direction;
- (void)animationUnCurl:(DTDirection)direction;

//Move
- (void)animationMove:(DTDirection)direction;
- (void)animationMoveFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

//立方体
- (void)animationCube:(DTDirection)direction;

//水波纹
- (void)animationRippleEffect;

//相机开合
- (void)animationCameraEffect:(NSString *)type;

//吸收
- (void)animationSuckEffect;

- (void)animationBounceOut;
- (void)animationBounceIn;
- (void)animationBounce;

// 抖动
- (void)startAnimationShake;
- (void)stopAnimationShake;

@end
