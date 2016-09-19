//
//  NSDate+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSDate+Expand.h"

@implementation NSDate (Expand)

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                           fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                           fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                           fromDate:self].day;
}

- (NSInteger)hour
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour
                                           fromDate:self].hour;
}

- (NSInteger)minute
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute
                                           fromDate:self].minute;
}

- (NSInteger)second
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond
                                           fromDate:self].second;
}

- (NSInteger)weekday
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                           fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

+ (NSDate *)dateFromFormat:(NSString *)datestring formate:(NSString*)formate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

+ (int)compareDateStr:(NSString*)date01 withDateStr:(NSString*)date02
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [df dateFromString:date01];
    NSDate *dt2 = [df dateFromString:date02];
    return [self compareDate:dt1 withDate:dt2];
}

+ (int)compareDate:(NSDate *)dt1 withDate:(NSDate *)dt2
{
    int ci;
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

- (int)compareWithDate:(NSDate *)date
{
    return [NSDate compareDate:self withDate:date];
}

- (NSString *)timeToDate:(NSDate *)date
{
    NSTimeInterval delta = [date timeIntervalSinceDate:self];
    int days = (int)delta/DAY;
    int hours = (int)delta%DAY/HOUR;
    int minutes = (int)delta/MINUTE-24*MINUTE*days-MINUTE*hours;
    
    NSString *str = nil;
    if (days == 0) {
        str = [NSString stringWithFormat:@"%.2d时%.2d分", hours, minutes];
    } else {
        str = [NSString stringWithFormat:@"%d天%.2d时%.2d分", days, hours, minutes];
    }
    return str;
}

- (NSString *)shortTimeToDate:(NSDate *)date
{
    NSTimeInterval delta = [date timeIntervalSinceDate:self];
    int days = (int)delta/DAY;
    int hours = (int)delta%DAY/HOUR;
    int minutes = (int)delta/MINUTE-24*MINUTE*days-MINUTE*hours;
    
    NSString *str = [NSString stringWithFormat:@"%.2d:%.2d", hours+days*24, minutes];
    return str;
}

- (NSString *)timeAgo
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta < 1 * MINUTE)
    {
        return @"刚刚";
    }
    else if (delta < 2 * MINUTE)
    {
        return @"1分钟前";
    }
    else if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }
    else if (delta < 90 * MINUTE)
    {
        return @"1小时前";
    }
    else if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }
    else if (delta < 48 * HOUR)
    {
        return @"昨天";
    }
    else if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    }
    else if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
    }
    
    int years = floor((double)delta/MONTH/12.0);
    return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

- (NSString *)timeLeft
{
    long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    int flag = 0;
    
    if ( delta >= YEAR )
    {
        int years = (int)( delta / YEAR );
        [result appendFormat:@"%d年", years];
        delta -= years * YEAR ;
        flag++;
    }
    
    if ( delta >= MONTH )
    {
        int months = (int)( delta / MONTH );
        [result appendFormat:@"%d月", months];
        delta -= months * MONTH ;
        flag++;
    }
    
    if (flag == 2) {
        return result;
    }
    
    if ( delta >= DAY)
    {
        int days = (int)( delta / DAY );
        [result appendFormat:@"%d天", days];
        delta -= days * DAY ;
        flag++;
    }
    
    if (flag == 2) {
        return result;
    }
    
    if ( delta >= HOUR )
    {
        int hours = (int)( delta / HOUR );
        [result appendFormat:@"%d小时", hours];
        delta -= hours * HOUR ;
        flag++;
    }
    
    if (flag == 2) {
        return result;
    }
    
    if ( delta >= MINUTE)
    {
        int minutes = (int)( delta / MINUTE );
        [result appendFormat:@"%d分钟", minutes];
        delta -= minutes * MINUTE ;
        flag++;
    }
    
    if (flag == 2) {
        return result;
    }
    
    int seconds = (int)( delta / SECOND );
    [result appendFormat:@"%d秒", seconds];
    
    return result;
}

+ (long long)timeStamp
{
    //	return (long long)[[NSDate date] timeIntervalSince1970];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    long long stamp = (long long)([date timeIntervalSince1970]*1000);
    return stamp;
}

+ (NSDate *)now
{
    return [NSDate date];
}

+ (NSString *)dateStringWithSecond:(u_int32_t)sec
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateWithSecond:(u_int32_t)sec
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sec];
    return date;
}

- (BOOL)isSameDay:(NSDate*)anotherDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents* components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:anotherDate];
    return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

- (NSString *)getXingzuo
{
    if (!self) {
        return @"";
    }
    //计算星座
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int monthInt=0;
    NSString *theMonth = [dateFormat stringFromDate:self];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        monthInt = [[theMonth substringFromIndex:1] intValue];
    }else{
        monthInt = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int dayInt=0;
    NSString *theDay = [dateFormat stringFromDate:self];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        dayInt = [[theDay substringFromIndex:1] intValue];
    }else{
        dayInt = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    if (monthInt == 1) {
        if (dayInt > 0 && dayInt < 20) {
            retStr=@"摩羯座";
        }
        if (dayInt > 21 &&dayInt < 31) {
            retStr=@"水瓶座";
        }
        return retStr;
    }
    if (monthInt == 2) {
        if (dayInt > 0 && dayInt < 19) {
            retStr=@"水瓶座";
        }
        if (dayInt > 20 && dayInt < 30) {
            retStr=@"双鱼座";
        }
        return retStr;
    }
    if (monthInt == 3) {
        if (dayInt > 0 && dayInt < 21) {
            retStr=@"双鱼座";
        }
        if (dayInt > 20 && dayInt < 32) {
            retStr=@"白羊座";
        }
        return retStr;
    }
    if (monthInt == 4) {
        if (dayInt > 0 && dayInt < 20) {
            retStr=@"白羊座";
        }
        if (dayInt > 19 && dayInt < 31) {
            retStr=@"金牛座";
        }
        return retStr;
    }
    if (monthInt == 5) {
        if (dayInt > 0 && dayInt < 21) {
            retStr=@"金牛座";
        }
        if (dayInt > 22 && dayInt < 32) {
            retStr=@"双子座";
        }
        return retStr;
    }
    if (monthInt == 6) {
        if (dayInt > 0 && dayInt < 22) {
            retStr=@"双子座";
        }
        if (dayInt > 21 && dayInt < 31) {
            retStr=@"巨蟹座";
        }
        return retStr;
    }
    if (monthInt == 7) {
        if (dayInt > 0 && dayInt < 23) {
            retStr=@"巨蟹座";
        }
        if (dayInt > 22 && dayInt < 32) {
            retStr=@"狮子座";
        }
        return retStr;
    }
    if (monthInt == 8) {
        if (dayInt > 0 && dayInt < 23) {
            retStr=@"狮子座";
        }
        if (dayInt > 22 && dayInt < 32) {
            retStr=@"处女座";
        }
        return retStr;
    }
    if (monthInt == 9) {
        if (dayInt > 0 && dayInt < 23) {
            retStr=@"处女座";
        }
        if (dayInt > 22 && dayInt < 31) {
            retStr=@"天秤座";
        }
        return retStr;
    }
    if (monthInt == 10) {
        if (dayInt > 0 && dayInt < 24) {
            retStr=@"天秤座";
        }
        if (dayInt > 23 && dayInt < 32) {
            retStr=@"天蝎座";
        }
        return retStr;
    }
    if (monthInt == 11) {
        if (dayInt > 0 && dayInt < 22) {
            retStr=@"天蝎座";
        }
        if (dayInt > 21 && dayInt < 31) {
            retStr=@"摩羯座";
        }
        return retStr;
    }
    if (monthInt == 12) {
        if (dayInt > 0 && dayInt < 22) {
            retStr=@"水瓶座";
        }
        if (dayInt > 21 && dayInt < 32) {
            retStr=@"摩羯座";
        }
        return retStr;
    }
    return  retStr;
}

- (NSInteger)getAge
{
    if (self) {
        NSTimeInterval dateDiff = [self timeIntervalSinceNow];
        return (-1 * trunc(dateDiff/(60*60*24))/365);
    }
    return 0;
}

@end
