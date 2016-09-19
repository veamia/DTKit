//
//  DTNavigationBar.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTNavigationBar.h"
#import <objc/runtime.h>
#import "DTKitMacro.h"
#import "DTButton.h"
#import "UIView+Frame.h"

#define LEFTWIDTH      80.0
#define TITLEFONTSIZE  18.0
#define BUTTONFONTSIZE 16.0

@implementation UIView (DTNavigationBarTitleView)
@dynamic text;

- (NSString *)text
{
    NSObject * obj = objc_getAssociatedObject( self, "UIView.text" );
    if ( obj && [obj isKindOfClass:[NSString class]] )
        return (NSString *)obj;
    
    return nil;
}

- (void)setText:(NSString *)text
{
    objc_setAssociatedObject( self, "UIView.text", text, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end

@implementation DTNavigationBar
@synthesize titleView = _titleView;
@synthesize leftView  = _leftView;
@synthesize rightView = _rightView;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor blueColor];
}

#pragma mark - titleView
- (UIView *)titleView
{
    if (!_titleView) {
        CGRect titleRect = CGRectMake(LEFTWIDTH, 20, self.width-LEFTWIDTH*2, self.height-20);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        titleLabel.center=CGPointMake(self.width/2.0f, titleLabel.center.y);
        titleLabel.font = [UIFont boldSystemFontOfSize:TITLEFONTSIZE];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:titleLabel];
        _titleView = titleLabel;
    }
    return _titleView;
}

- (void)setTitleView:(UIView *)titleView
{
    if (_titleView) {
        titleView.frame = _titleView.frame;
        [_titleView removeFromSuperview];
        _titleView = nil;
    }
    _titleView = titleView;
    [self addSubview:titleView];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleView.text = title;
}

#pragma mark - leftView
- (UIView *)leftView
{
    if (!_leftView) {
        CGRect leftRect = CGRectMake(0, 20, LEFTWIDTH, self.height-20);
        DTButton *btn = [DTButton new];
        btn.frame = leftRect;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:BUTTONFONTSIZE];
        btn.stateNormal.titleColor = [UIColor whiteColor];
        btn.stateHighlighted.titleColor = [UIColor lightGrayColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(5, 14, 0, 0);
        [self addSubview:btn];
        _leftView = btn;
    }
    return _leftView;
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView) {
        leftView.frame = _leftView.frame;
        [_leftView removeFromSuperview];
        _leftView = nil;
    }
    _leftView = leftView;
    [self addSubview:leftView];
}

#pragma mark - rightView
- (UIView *)rightView
{
    if (!_rightView) {
        CGRect leftRect = CGRectMake(self.width-LEFTWIDTH, 20,
                                     LEFTWIDTH, self.height-20);
        DTButton *btn = [DTButton new];
        btn.frame = leftRect;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:BUTTONFONTSIZE];
        btn.stateNormal.titleColor = [UIColor whiteColor];
        btn.stateHighlighted.titleColor = [UIColor lightGrayColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14);
        btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 14);
        [self addSubview:btn];
        _rightView = btn;
    }
    return _rightView;
}

- (void)setRightView:(UIView *)rightView
{
    if (_rightView) {
        rightView.frame = _rightView.frame;
        [_rightView removeFromSuperview];
        _rightView = nil;
    }
    _rightView = rightView;
    [self addSubview:rightView];
}

#pragma mark - backImage
- (void)setNaviBackImage:(UIImage *)naviBackImage
{
    _naviBackImage = naviBackImage;
    self.backgroundColor = [UIColor colorWithPatternImage:naviBackImage];
    [self setNeedsDisplay];
}

#pragma mark - drawReck

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextMoveToPoint(context, 0, self.height-0.5);
    CGContextAddLineToPoint(context, self.width, self.height-0.5);
    CGContextStrokePath(context);
    [super drawRect:rect];
}

@end
