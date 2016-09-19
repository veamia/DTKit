//
//  NSDate+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

#pragma mark -

@interface NSDate (Expand)

@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;

// date 格式化为 string
- (NSString *)stringWithDateFormat:(NSString *)format;
// string 格式化为 date
+ (NSDate *)dateFromFormat:(NSString *)datestring formate:(NSString*)formate;
// 比较日期的大小 //date02比date01大 return 1  小 return -1 等 return 0
+ (int)compareDate:(NSDate *)dt1 withDate:(NSDate *)dt2;
+ (int)compareDateStr:(NSString*)date01 withDateStr:(NSString*)date02;
- (int)compareWithDate:(NSDate *)date;

- (NSString *)timeAgo;
- (NSString *)timeLeft;

// 时间间隔
- (NSString *)timeToDate:(NSDate *)date;
- (NSString *)shortTimeToDate:(NSDate *)date; //简写

+ (long long)timeStamp;
+ (NSDate *)now;

+ (NSString *)dateStringWithSecond:(u_int32_t)sec;
+ (NSDate *)dateWithSecond:(u_int32_t)sec;

- (BOOL)isSameDay:(NSDate*)anotherDate;
- (BOOL)isToday;
- (NSString *)getXingzuo;
- (NSInteger)getAge;

@end
