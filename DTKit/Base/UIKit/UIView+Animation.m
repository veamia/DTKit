//
//  UIView+Animation.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Frame.h"

#define kCameraEffectOpen  @"cameraIrisHollowOpen"
#define kCameraEffectClose @"cameraIrisHollowClose"

#define kTransitionTime 0.75
#define kFlipTime       0.75

@implementation UIView (Animation)

- (NSString *)subtypeWithDirection:(DTDirection)direction
{
    NSString *transition = kCATransitionFromTop;
    switch (direction) {
        case DTDirectionBottom:
            transition = kCATransitionFromBottom;
            break;
        case DTDirectionLeft:
            transition = kCATransitionFromLeft;
            break;
        case DTDirectionRight:
            transition = kCATransitionFromRight;
            break;
        default:
            transition = kCATransitionFromTop;
            break;
    }
    return transition;
}

- (void)animationReveal:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setType:kCATransitionReveal];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationFade
{
    if (![self.layer animationForKey:@"FadeAnimation"]) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.35];
        [animation setType:kCATransitionFade];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"FadeAnimation"];
    }
}

- (void)animationRotateAndScaleDownUp
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 2];
    rotationAnimation.duration = 0.750f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.duration = 0.75f;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.75f;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = 1;//HUGE_VALF;
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotationAnimation, scaleAnimation, nil]];
    
    [self.layer addAnimation:animationGroup forKey:@"animationGroup"];
}


- (void)animationFlip:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kFlipTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"oglFlip"];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationPush:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionPush];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCurl:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"pageCurl"];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationUnCurl:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"pageUnCurl"];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationRotateAndScaleEffects
{
    [UIView animateWithDuration:0.75
                     animations:^
     {
         self.transform = CGAffineTransformMakeScale(0.001, 0.001);
         
         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
         animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80) ];//旋转形成一道闪电。
         //animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) ];//y轴居中对折番。
         //animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0) ];//沿X轴对折翻转。
         //animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.50, -0.50, 0.50) ];
         //animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2) ];
         
         animation.duration = 0.45;
         animation.repeatCount = 1;
         [self.layer addAnimation:animation forKey:nil];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.75 animations:^
          {
              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
          }
          ];
         
     }
     ];
}

- (void)animationMove:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationMoveFrom:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.duration = kTransitionTime;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCube:(DTDirection)direction
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"cube"];
    [animation setSubtype:[self subtypeWithDirection:direction]];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationRippleEffect
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"rippleEffect"];
    [animation setSubtype:kCATransitionFromRight];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationCameraEffect:(NSString *)type
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:type];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationSuckEffect
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:@"suckEffect"];
    [animation setSubtype:kCATransitionFromRight];
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)animationBounceIn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.0001];
    [self setAlpha:0.8];
    [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)];
    [UIView commitAnimations];
}

- (void)animationBounceOut
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [self setAlpha:1.0];
    [self setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
    [UIView commitAnimations];
}

- (void)animationBounce
{
    CGPoint center = self.center;
    self.y = self.height;
    self.alpha = 0.1;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self setAlpha:1.0];
    [self setCenter:center];
    [UIView commitAnimations];
}

- (void)startAnimationShake {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.03];
    shake.toValue = [NSNumber numberWithFloat:+0.03];
    shake.duration = 0.06;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount = 1000000;
    [self.layer addAnimation:shake forKey:@"DTShake"];
}

- (void)stopAnimationShake {
    [self.layer removeAnimationForKey:@"DTShake"];
}

@end
