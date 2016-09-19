//
//  UIView+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Expand)

//当前视图的下一个视图控制器
- (UIViewController *)viewController;

//根据tag找到当前视图中对应的子视图
- (UIView *)subViewWithTag:(int)tag;

//复制当前View
- (UIView *)duplicate;

//移除所有子视图
- (void)removeAllSubviews;

// 是否隐藏显示所有子视图
- (void)hideAllSubviews:(BOOL)hide;

//延迟消失
- (void)removeAfterDelay:(NSTimeInterval)time;

- (void)setAllSubviewsAlpha:(CGFloat)alpha;

//当前视图变为图片
- (UIImage *)imageRepresentation;

//当前视图所有的superview
- (NSArray *)superviews;

//贱贱的消失，不移除   时间均为0.35s
- (void)fadeOut;
//渐渐的消失，并移除
- (void)fadeOutAndRemoveFromSuperview;
//渐渐的出现
- (void)fadeIn;

@end
