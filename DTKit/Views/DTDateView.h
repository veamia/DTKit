//
//  DTDateView.h
//  LEboCarOwner
//
//  Created by zhaojh on 16/8/30.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTDateView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) NSDate *defaultDate;

@property (nonatomic, copy) void (^cancelHandler)();
@property (nonatomic, copy) void (^sureHandler)(NSDate *);

@end
