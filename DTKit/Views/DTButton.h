//
//  DTButton.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTButton;
@interface DTButtonState : NSObject

@property (nonatomic, assign) DTButton       * button;
@property (nonatomic, assign) UIControlState   state;
@property (nonatomic, assign) NSString       * title;
@property (nonatomic, assign) UIColor        * titleColor;
@property (nonatomic, assign) UIColor        * titleShadowColor;
@property (nonatomic, assign) UIImage        * image;
@property (nonatomic, assign) UIImage        * backgroundImage;
@property (nonatomic, assign) UIColor        * backgroundColor;

@end

typedef NS_ENUM(NSInteger, DTButtonImagePositon) {
    DTButtonImagePositionLeft,
    DTButtonImagePositionRight,
    DTButtonImagePositionTop,
};

@interface DTButton : UIButton

// 可以给按钮取个名字，不是标题
@property (nonatomic, copy) NSString *buttonName;
// 预留信息
@property (nonatomic, copy) NSString *buttonInfo;
//按钮和图片的位置选择
@property (nonatomic, assign) DTButtonImagePositon imagePosition;

// 为按钮设置一个model，默认nil
@property (nonatomic, strong) id model;

@property (nonatomic, readonly) DTButtonState *stateNormal;
@property (nonatomic, readonly) DTButtonState *stateHighlighted;
@property (nonatomic, readonly) DTButtonState *stateDisabled;
@property (nonatomic, readonly) DTButtonState *stateSelected;

- (void)setTarget:(id)target action:(SEL)action;
- (void)setTarget:(id)target action:(SEL)action forEvents:(UIControlEvents)events;

//倒计时
- (void)startWithTime:(NSInteger)timeLine
             showTime:(void (^)(NSString *strTime))showTime
              showEnd:(void (^)())showEnd;

- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)countDownTitle;

- (void)cancelCountdownTimer;

@end
