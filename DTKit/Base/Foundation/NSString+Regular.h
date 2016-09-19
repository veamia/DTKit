//
//  NSString+Regular.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

- (BOOL)isValidateEmail; //邮箱符合性验证。
- (BOOL)isNumber; //全是数字。
- (BOOL)isEnglishWords; //验证英文字母。
- (BOOL)isChineseWords; //验证是否为汉字。
- (BOOL)isValidatePassword; //验证密码：6—16位，只能包含字符、数字和 下划线。
- (BOOL)isInternetUrl; //验证是否为网络链接。

- (BOOL)isElevenDigitNum; //11位电话号码
- (BOOL)isIdentifyCardNumber; //验证15或18位身份证。

- (BOOL)isIPAddress;// 是否为IP地址

@end
