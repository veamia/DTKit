//
//  DTShadowView.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DTShadowFrom) {
    DTShadowFromUp,
    DTShadowFromBottom,
};

@interface DTShadowView : UIView

// 背景色，默认clearColor
+ (void)setBackgroundColor:(UIColor *)color;

+ (void)showView:(UIView *)view
            from:(DTShadowFrom)from;

/**
 *  显示view
 *
 *  @param view   view
 *  @param offset 偏移值，从上出来才有意义
 *  @param from   从哪里出现
 */
+ (void)showView:(UIView *)view
          offset:(CGFloat)offset
            from:(DTShadowFrom)from;

+ (void)hide;
+ (void)hideComplete:(void(^)())complete;

@end
