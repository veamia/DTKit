//
//  DTShadowView.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTShadowView.h"
#import "DTSingleton.h"
#import "DTKitMacro.h"
#import "UIView+Frame.h"
#import "UIView+Gesture.h"

@interface DTShadowView () {
    CGFloat _value; //记录动画前的值
}
dt_Singleton_ITF( DTShadowView )

@property (nonatomic, weak) UIView *showView;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) DTShadowFrom from;
@property (nonatomic, assign) BOOL isEqualToShowView;

@end

@implementation DTShadowView

dt_Singleton_IMP( DTShadowView )

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, dtScreenWidth, dtScreenHeight);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self addTapGestureWithTarget:self fingerCount:1];
    }
    return self;
}

#pragma mark -
#pragma mark - tap

ON_TapGesture(gesture)
{
    [self hide:nil];
}

#pragma mark -
#pragma mark - show and hide

- (void)showView:(UIView *)view
          offset:(CGFloat)offset
            from:(DTShadowFrom)from
{
    self.frame = CGRectMake(0, 0, dtScreenWidth, dtScreenHeight);
    self.showView = view;
    self.offset = offset;
    self.from = from;
    
    [dtKeyWindow addSubview:self];
    [self addSubview:view];
    
    switch (from) {
        case DTShadowFromUp: {
            [self fromUp];
            break;
        }
        case DTShadowFromBottom: {
            [self fromDown];
            break;
        }
    }
}

- (void)hide:(void(^)())complete
{
    if (!self.superview) {
        if (complete) {
            complete();
        }
        return;
    }
    
    CGRect resultFrame = CGRectMake(self.showView.x, -self.showView.height, self.showView.width, self.showView.height);
    CGFloat alpha = self.alpha;
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (self.from == DTShadowFromUp) {
                             self.showView.frame = CGRectMake(self.showView.x, self.showView.y, self.showView.width, 0);
                         } else {
                             self.showView.y = dtScreenHeight;
                         }
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.alpha = alpha;
                         self.showView.frame = resultFrame;
                         [self.showView removeFromSuperview];
                         [self removeFromSuperview];
                         if (complete) {
                             complete();
                         }
                     }];
}

#pragma mark -
#pragma mark - from

- (void)fromUp
{
    self.showView.y = dtNavBarHeight + self.offset;
    CGFloat height = self.showView.height;
    self.showView.height = 0;
    CGFloat alpha = self.alpha;
    self.alpha = 0;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.showView.height = height;
                         self.alpha = alpha;
                     }];
}

- (void)fromDown
{
    CGFloat alpha = self.alpha;
    self.alpha = 0;
    self.showView.y = dtScreenHeight;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.showView.bottom = dtScreenHeight;
                         self.alpha = alpha;
                     }];
}

#pragma mark -
#pragma mark - class methods

+ (void)showView:(UIView *)view from:(DTShadowFrom)from
{
    [self showView:view offset:0 from:from];
}

+ (void)showView:(UIView *)view
          offset:(CGFloat)offset
            from:(DTShadowFrom)from
{
    [[DTShadowView sharedInstance] showView:view offset:offset from:from];
}

+ (void)hide
{
    [[DTShadowView sharedInstance] hide:nil];
}

+ (void)hideComplete:(void(^)())complete
{
    [[DTShadowView sharedInstance] hide:complete];
}

+ (void)setBackgroundColor:(UIColor *)color
{
    [DTShadowView sharedInstance].backgroundColor = color;
}

@end
