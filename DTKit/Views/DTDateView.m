//
//  DTDateView.m
//  LEboCarOwner
//
//  Created by zhaojh on 16/8/30.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTDateView.h"
#import "DTButton.h"
#import "DTKitMacro.h"
#import "UIView+Gesture.h"
#import "UIView+Frame.h"

@interface DTDateView ()

@property (nonatomic, strong) DTButton *cancelButton;
@property (nonatomic, strong) DTButton *sureButton;

@end

@implementation DTDateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(dtScreenWidth, self.datePicker.height+44);
        self.backgroundColor = [UIColor whiteColor];
        
        self.defaultDate = [NSDate date];
        
        UIView *toolBar = [[UIView alloc] initWithFrame:
                           CGRectMake(0, 0, self.width, 44)];
        toolBar.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [toolBar addTapGestureWithTarget:self fingerCount:1];
        [self addSubview:toolBar];
        
        DTButton *cancelBtn = [DTButton new];
        cancelBtn.frame = CGRectMake(0, 6, 60, 32);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelBtn.stateNormal.title = @"取消";
        cancelBtn.stateNormal.titleColor = [UIColor blueColor];
        [cancelBtn setTarget:self action:@selector(cancelAction)];
        [toolBar addSubview:cancelBtn];
        self.cancelButton = cancelBtn;
        
        DTButton *sureBtn = [DTButton new];
        sureBtn.frame = CGRectMake(0, 6, 60, 32);
        sureBtn.right = toolBar.width;
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        sureBtn.stateNormal.title = @"确定";
        sureBtn.stateNormal.titleColor = [UIColor blueColor];
        [sureBtn setTarget:self action:@selector(sureAction)];
        [toolBar addSubview:sureBtn];
        self.sureButton = sureBtn;
        
        self.datePicker.y = toolBar.bottom;
        [self addSubview:self.datePicker];
    }
    return self;
}

ON_TapGesture(gesture) {}

#pragma mark -
#pragma mark - action

- (void)cancelAction
{
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (void)sureAction
{
    if (self.sureHandler) {
        self.sureHandler(self.datePicker.date);
    }
}

#pragma mark -
#pragma mark - setter

- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    self.cancelButton.stateNormal.titleColor = mainColor;
    self.sureButton.stateNormal.titleColor = mainColor;
}

- (void)setDefaultDate:(NSDate *)defaultDate
{
    _defaultDate = defaultDate;
    self.datePicker.date = defaultDate;
}

#pragma mark -
#pragma mark - getter

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:
                       CGRectMake(0, 0, dtScreenWidth, dtKeyboardHeight)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
    }
    return _datePicker;
}

@end
