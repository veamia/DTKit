//
//  DTAlertView.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTAlertView : UIAlertController

+ (DTAlertView *)alert:(NSString *)title
               message:(NSString *)message
               isAlert:(BOOL)isAlert;

// 简单提示
+ (void)simpleAlert:(NSString *)title message:(NSString *)message;
+ (void)presentAlert:(DTAlertView *)alert;

@end
