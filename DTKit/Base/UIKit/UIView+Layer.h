//
//  UIView+Layer.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layer)

/**
 *  产生一个Image的倒影，并把这个倒影图片加在一个View上面。
 *  @param  image:被倒影的原图。
 *  @param  frame:盖在上面的图。
 *  @param  opacity:倒影的透明度，0为完全透明，即倒影不可见。
 *  @param  view:倒影加载在上面。
 *  return  产生倒影后的View。
 */
+ (UIView *)reflectImage:(UIImage *)image withFrame:(CGRect)frame opacity:(CGFloat)opacity atView:(UIView *)view;

//开始和停止旋转动画
- (void)startRotationAnimatingWithDuration:(CGFloat)duration;
- (void)stopRotationAnimating;

//暂停恢复动画
- (void)pauseAnimating;
- (void)resumeAnimating;

// 圆形
- (void)rounded;
- (void)cornerRadius:(float)radius; //设置圆角
// 旋转 1.0:顺时针180度
- (void)rotate:(CGFloat)radians;
// 边框大小,颜色
- (void)borderWidth:(CGFloat)width color:(UIColor *)color;
// shadow
- (void)shadowOffset:(CGSize)offset shadowColor:(UIColor *)color;

@end
