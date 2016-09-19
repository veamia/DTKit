//
//  UIImage+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>

@interface UIImage (Expand)

// 拉伸
- (UIImage *)stretched;
- (UIImage *)stretched5;
- (UIImage *)stretched:(UIEdgeInsets)capInsets;

// 旋转
- (UIImage *)rotate:(CGFloat)angle;
- (UIImage *)rotateCW90;
- (UIImage *)rotateCW180;
- (UIImage *)rotateCW270;

- (UIImage *)grayscale; // 变灰

// 抓取屏幕 scale:屏幕放大倍数，1为原尺寸。
+ (UIImage *)grabScreenWithScale:(CGFloat)scale;

// 抓取UIView及其子类
+ (UIImage *)grabImageWithView:(UIView *)view scale:(CGFloat)scale;

// 把一个Image盖在另一个Image上面
+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)mask;

// 把一个Image尺寸缩放到另一个尺寸
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

// 叠加合并
+ (UIImage *)merge:(NSArray *)images;
- (UIImage *)merge:(UIImage *)image;

// 改变图片颜色, Gradient带灰度
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

//按frame裁减图片
+ (UIImage *)captureView:(UIView *)view frame:(CGRect)frame;

// 截取部分图像
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)imageInRect:(CGRect)rect;

// 创建并返回使用指定的图像中的颜色对象
- (UIColor *)patternColor;

// 从视频截取图片
+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale;
+ (UIImage *)imageFromVideo:(NSString *)videoPath;

//UIColor转UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)lanchImage;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)squareImage;
- (UIImage *)circleImageWithParam:(CGFloat)inset;

- (UIImage *)addText:(NSString *)text
              atRect:(CGRect)rect
            fontAttr:(NSDictionary *)attributes;

// 旋转
- (UIImage *)imageRotation:(UIImageOrientation)orientation;

// 圆角
- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius
                             sizeToFit:(CGSize)size;



@end
