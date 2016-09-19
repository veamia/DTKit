//
//  NSString+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

typedef NSString * (^NSStringAppendBlock)( id format, ... );
typedef NSString * (^NSStringReplaceBlock)( NSString * string, NSString * string2 );

typedef NSMutableString * (^NSMutableStringAppendBlock)( id format, ... );
typedef NSMutableString * (^NSMutableStringReplaceBlock)( NSString * string, NSString * string2 );

#pragma mark -

@interface NSString (Expand)

@property (nonatomic, readonly) NSStringAppendBlock		append;
@property (nonatomic, readonly) NSStringAppendBlock		line;
@property (nonatomic, readonly) NSStringReplaceBlock	replace;

/**
 *  计算字符串的字数。
 *  @param  string:输入字符串。
 *  return  返回输入字符串的字数。
 */
- (int)wordsCount; //中文字符的个数，如果是英文字母，则两个英文占用一个字符
- (NSUInteger)countNumberOfWords; // 有多少个字符串
- (NSUInteger)numberOfLines; // 有多少行

- (BOOL)isBlank;//检查String是否为空, 一般在输入的时候判断文本是否为空使用
- (BOOL)isValid;//检查String是否为空或者nil
- (NSString *)removeWhiteSpacesFromString;//删除空白字符串

- (BOOL)containsString:(NSString *)subString;// 包含某个字符串
- (NSString *)removeSubString:(NSString *)subString;//移除字符串中的某一段字符串

- (BOOL)containsOnlyLetters; // 只包含字母
- (BOOL)containsOnlyNumbers; // 只包含数字
- (BOOL)containsOnlyNumbersAndLetters; // 包含字母和数字
- (NSInteger)findNumber;  //查找数字

- (NSString *)standardTimeStringWithFormat:(NSString *)format;
- (NSString *)standardTimeString; // 将国际时间转换为当前标准时间，默认格式yyyy-MM-dd HH:mm:ss
- (NSData *)convertToData; // 将字符串转换成数据data
- (NSDate *)convertToDate; // 将字符串转换成数据date, 默认格式yyyy-MM-dd HH:mm:ss
- (NSDate *)convertToDateWithFormat:(NSString *)format; // 生日日期
+ (NSString *)getStringFromData:(NSData *)data; // 将data转换成字符串

- (BOOL)takeTelephone; // 打电话
- (BOOL)openURL;       //打开URL
+ (BOOL)enterPrefWiFiSet; //进入系统wifi设置
+ (BOOL)enterLocationServices; //进入定位服务
//格式为itms-apps://ax.itunes.apple.com/...是打开APPStore的页面

- (NSString *)trim;
- (NSString *)unwrap;

- (BOOL)is:(NSString *)string;

//效验码
- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;
- (NSString *)SHA512;

- (NSString *)URLDecodedString;//解码
- (NSString *)URLEncodedString;//编码,译码
- (NSString *)encodeStringWithUTF8;
- (NSUInteger)byteLengthWithEncoding:(NSStringEncoding)encoding;

//    ----
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset;
- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset;

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset;

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;

+ (NSString *)fromResource:(NSString *)resName;
+ (NSString *)fileSizeWithValue:(double)value;

// 通过身份证号获取生日
+ (NSString *)birthdayStrFromIdentityCard:(NSString *)identityCard;
// 通过身份证号获取性别
+ (NSString *)sexStrFromIdentityCard:(NSString *)identityCard;

// 获取UUID
+ (NSString *)uuid;

// 首字母
- (NSString *)pinYin;
- (NSString *)firstCharactor;

@end

#pragma mark -

@interface NSMutableString (Expand)

@property (nonatomic, readonly) NSMutableStringAppendBlock	APPEND;
@property (nonatomic, readonly) NSMutableStringAppendBlock	LINE;
@property (nonatomic, readonly) NSMutableStringReplaceBlock	REPLACE;

@end
