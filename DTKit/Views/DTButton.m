//
//  DTButton.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTButton.h"
#import "DTKitMacro.h"
#import "UIImage+Expand.h"

@implementation DTButtonState

- (NSString *)title
{
    return [_button titleForState:_state];
}

- (void)setTitle:(NSString *)text
{
    [_button setTitle:text forState:_state];
    [_button setNeedsDisplay];
}

- (UIColor *)titleColor
{
    return [_button titleColorForState:_state];
}

- (void)setTitleColor:(UIColor *)color
{
    [_button setTitleColor:color forState:_state];
    [_button setNeedsDisplay];
}

- (UIColor *)titleShadowColor
{
    return [_button titleShadowColorForState:_state];
}

- (void)setTitleShadowColor:(UIColor *)color
{
    [_button setTitleShadowColor:color forState:_state];
    [_button setNeedsDisplay];
}

- (UIImage *)image
{
    return [_button imageForState:_state];
}

- (void)setImage:(UIImage *)img
{
    [_button setImage:img forState:_state];
    [_button setNeedsDisplay];
}

- (UIImage *)backgroundImage
{
    return [_button backgroundImageForState:_state];
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_button setBackgroundImage:img forState:_state];
    [_button setNeedsDisplay];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithPatternImage:self.backgroundImage];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    UIImage *image = [UIImage imageWithColor:backgroundColor];
    self.backgroundImage = image;
}

@end

@interface DTButton () {
    DTButtonState *	_stateNormal;
    DTButtonState *	_stateHighlighted;
    DTButtonState *	_stateDisabled;
    DTButtonState *	_stateSelected;
    dispatch_source_t _timer;
}
@end

@implementation DTButton

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSelf];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    self.exclusiveTouch = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeCenter;
    self.adjustsImageWhenDisabled = YES;
    self.adjustsImageWhenHighlighted = YES;
    self.stateNormal.titleColor = [UIColor blackColor];
//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.showsTouchWhenHighlighted = YES;
    
    _imagePosition = DTButtonImagePositionTop;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_imagePosition == DTButtonImagePositionTop) {
        return;
    }
    
    CGRect imageFrame = self.imageView.frame;
    CGRect labelFrame = self.titleLabel.frame;
    if (_imagePosition == DTButtonImagePositionLeft) {
        if (self.imageView.image) {
            labelFrame.origin.x += 1.5;
            imageFrame.origin.x -= 1.5;
        }
    } else {
        labelFrame.origin.x = imageFrame.origin.x-self.imageEdgeInsets.left+self.imageEdgeInsets.right;
        imageFrame.origin.x += (labelFrame.size.width+3);
    }
    
    self.titleLabel.frame = labelFrame;
    self.imageView.frame = imageFrame;
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    //取消系统高亮效果
//}

- (void)setTarget:(id)target action:(SEL)action
{
    [self setTarget:target action:action forEvents:UIControlEventTouchUpInside];
}

- (void)setTarget:(id)target action:(SEL)action forEvents:(UIControlEvents)events
{
    [self removeTarget:target action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:target action:action forControlEvents:events];
}

- (DTButtonState *)stateNormal
{
    if ( nil == _stateNormal )
    {
        _stateNormal = [[DTButtonState alloc] init];
        _stateNormal.button = self;
        _stateNormal.state = UIControlStateNormal;
    }
    
    return _stateNormal;
}

- (DTButtonState *)stateHighlighted
{
    if ( nil == _stateHighlighted )
    {
        _stateHighlighted = [[DTButtonState alloc] init];
        _stateHighlighted.button = self;
        _stateHighlighted.state = UIControlStateHighlighted;
    }
    
    return _stateHighlighted;
}

- (DTButtonState *)stateDisabled
{
    if ( nil == _stateDisabled )
    {
        _stateDisabled = [[DTButtonState alloc] init];
        _stateDisabled.button = self;
        _stateDisabled.state = UIControlStateDisabled;
    }
    
    return _stateDisabled;
}

- (DTButtonState *)stateSelected
{
    if ( nil == _stateSelected )
    {
        _stateSelected = [[DTButtonState alloc] init];
        _stateSelected.button = self;
        _stateSelected.state = UIControlStateSelected;
    }
    
    return _stateSelected;
}

// 倒计时，传入单位：秒
- (void)startWithTime:(NSInteger)timeLine
             showTime:(void (^)(NSString *strTime))showTime
              showEnd:(void (^)())showEnd;
{
    __block int timeOut = (int)timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut <= 0){ //倒计时结束，关闭
            [self cancelCountdownTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (showEnd) {
                    showEnd();
                }
            });
        } else {
            int seconds = timeOut % (timeLine+1);
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showTime) {
                    showTime(strTime);
                }
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)cancelCountdownTimer {
    dispatch_source_cancel(_timer);
    _timer = nil;
}

- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)countDownTitle
{
    dtWeakSelf
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            [weakSelf cancelCountdownTimer];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.stateNormal.title = title;
                weakSelf.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *title = nil;
                NSArray *sepStrs = [countDownTitle componentsSeparatedByString:@"@"];
                if (sepStrs.count == 2) {
                    title = [NSString stringWithFormat:@"%@%@%@",
                             sepStrs.firstObject, timeStr, sepStrs.lastObject];
                } else {
                    title = [NSString stringWithFormat:@"%@%@", timeStr, countDownTitle];
                }
                
                weakSelf.stateNormal.title = title;
                weakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
