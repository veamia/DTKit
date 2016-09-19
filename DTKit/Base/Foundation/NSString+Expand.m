//
//  NSString+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSString+Expand.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Expand)

- (NSStringAppendBlock)append
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        
        NSMutableString * copy = [self mutableCopy];
        [copy appendString:append];
        
        va_end( args );
        
        return copy;
    };
    
    return [block copy];
}

- (NSStringAppendBlock)line
{
    NSStringAppendBlock block = ^ NSString * ( id first, ... )
    {
        NSMutableString * copy = [self mutableCopy];
        
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
            [copy appendString:append];
            
            va_end( args );
        }
        
        [copy appendString:@"\n"];
        
        return copy;
    };
    
    return [block copy];
}

- (NSStringReplaceBlock)replace
{
    NSStringReplaceBlock block = ^ NSString * ( NSString * string1, NSString * string2 )
    {
        return [self stringByReplacingOccurrencesOfString:string1 withString:string2];
    };
    
    return [block copy];
}

- (int)wordsCount
{
    NSInteger i,n = [self length], l = 0, a = 0, b = 0;
    unichar c;
    for(i = 0;i < n; i++)
    {
        c = [self characterAtIndex:i];
        if(isblank(c))
        {
            b++;
        }else if(isascii(c))
        {
            a++;
        }else{
            l++;
        }
    }
    if(a == 0 && l == 0) return 0;
    return (int)l + (int)ceilf((float)(a + b) / 2.0);
}

- (BOOL)isBlank {
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}

- (BOOL)isValid {
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

- (NSString *)removeWhiteSpacesFromString
{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (NSUInteger)countNumberOfWords
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet:whiteSpace intoString:nil]) {
        count++;
    }
    
    return count;
}

- (NSUInteger)numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (BOOL)containsString:(NSString *)subString
{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

- (NSString *)removeSubString:(NSString *)subString
{
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

- (BOOL)containsOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)containsOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

- (BOOL)containsOnlyNumbersAndLetters
{
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

- (NSInteger)findNumber
{
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        
        if (tempStr.isValid) {
            [numberString appendString:tempStr];
        }
        
        tempStr = @"";
    }
    // Result.
    NSInteger number = [numberString integerValue];
    
    return number;
}

- (NSString *)standardTimeString
{
    return [self standardTimeStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)standardTimeStringWithFormat:(NSString *)format
{
    if (!self.isValid) return nil;
    if (self.length < 20) return self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *dateFormatted = [dateFormatter dateFromString:self];
    [dateFormatter setDateFormat:format];
    NSString *str = [dateFormatter stringFromDate:dateFormatted];
    return str;
}

- (NSData *)convertToData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDate *)convertToDate
{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    if (self.length >= format.length) {
        return [[self substringToIndex:format.length]
                convertToDateWithFormat:format];
    }
    return nil;
}

- (NSDate *)convertToDateWithFormat:(NSString *)format
{
    if (self.length == 0) {
        return nil;
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

+ (NSString *)getStringFromData:(NSData *)data
{
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
    
}

- (BOOL)takeTelephone
{
    NSString *tel = [NSString stringWithFormat:@"telprompt:%@", self];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

- (BOOL)openURL
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self]];
}

+ (BOOL)enterPrefWiFiSet
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

+ (BOOL)enterLocationServices
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (BOOL)is:(NSString *)string
{
    return [self isEqualToString:string];
}

- (NSString *)MD5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

- (NSString *)SHA1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

- (NSString *)SHA256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

- (NSString *)SHA512
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

#pragma mark - 编码解码

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}

#pragma clang diagnostic pop

- (NSString *)encodeStringWithUTF8
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    const char *c =  [self cStringUsingEncoding:encoding];
    NSString *str = [NSString stringWithCString:c encoding:NSUTF8StringEncoding];
    
    return str;
}

- (NSUInteger)byteLengthWithEncoding:(NSStringEncoding)encoding
{
    if (!self)
    {
        return 0;
    }
    
    const char *byte = [self cStringUsingEncoding:encoding];
    return strlen(byte);
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset
{
    return [self substringFromIndex:from untilCharset:charset endOffset:NULL];
}

- (NSString *)substringFromIndex:(NSUInteger)from untilCharset:(NSCharacterSet *)charset endOffset:(NSUInteger *)endOffset
{
    if ( 0 == self.length || from >= self.length)
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:charset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        if ( endOffset )
        {
            *endOffset = range.location + range.length;
        }
        
        return [self substringWithRange:range];
    }
    else
    {
        if ( endOffset )
        {
            *endOffset = range2.location + range2.length;
        }
        
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

- (NSUInteger)countFromIndex:(NSUInteger)from inCharset:(NSCharacterSet *)charset
{
    if ( 0 == self.length || from >= self.length)
        return 0;
    
    NSCharacterSet * reversedCharset = [charset invertedSet];
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfCharacterFromSet:reversedCharset options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        return self.length - from;
    }
    else
    {
        return range2.location - from;
    }
}

//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//...sizeWithFont... //也可以使用这个来消除警告
//#pragma clang diagnostic pop

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs byWidth:(CGFloat)width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attrs
                              context:NULL].size;
}

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:NULL].size;
#else
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                lineBreakMode:NSLineBreakByWordWrapping];
#endif
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:NULL].size;
#else
    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                lineBreakMode:NSLineBreakByWordWrapping];
#endif
}

+ (NSString *)fromResource:(NSString *)resName
{
    NSString *extension = [resName pathExtension];
    NSString *fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

+ (NSString *)fileSizeWithValue:(double)value
{
    double convertedValue = value;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B", @"KB", @"MB", @"GB", @"TB",nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@", convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString *)birthdayStrFromIdentityCard:(NSString *)identityCard
{
    if(!identityCard || identityCard.length == 0)
        return nil;
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if(identityCard.length < 14)
        return result;
    
    //**截取前14位
    NSString *fontNumer = [identityCard substringWithRange:NSMakeRange(0, 13)];
    
    //**检测前14位否全都是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber)
        return result;
    
    year = [identityCard substringWithRange:NSMakeRange(6, 4)];
    month = [identityCard substringWithRange:NSMakeRange(10, 2)];
    day = [identityCard substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

+ (NSString *)sexStrFromIdentityCard:(NSString *)identityCard
{
    if(!identityCard || identityCard.length == 0)
        return nil;
    NSString *result = nil;
    
    BOOL isAllNumber = YES;
    
    if([identityCard length]<17)
        return result;
    
    //**截取第17为性别识别符
    NSString *fontNumer = [identityCard substringWithRange:NSMakeRange(16, 1)];
    
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0' && *p<='9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber)
        return result;
    
    int sexNumber = [fontNumer intValue];
    if(sexNumber%2 == 1)
        result = @"男";
    else if (sexNumber%2 == 0)
        result = @"女";
    
    return result;
}

+ (NSString *)uuid
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

- (NSString *)pinYin
{
    //先转换为带声调的拼音
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return str;
}

- (NSString *)firstCharactor
{
    //1.先传化为拼音
    NSString *pinYin = [self.pinYin uppercaseString];
    //2.获取首字母
    return pinYin.length>0 ? [pinYin substringToIndex:1] : nil;
}

@end

@implementation NSMutableString (Expand)

- (NSMutableStringAppendBlock)APPEND
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
        [self appendString:append];
        
        va_end( args );
        
        return self;
    };
    
    return [block copy];
}

- (NSMutableStringAppendBlock)LINE
{
    NSMutableStringAppendBlock block = ^ NSMutableString * ( id first, ... )
    {
        if ( first )
        {
            va_list args;
            va_start( args, first );
            
            NSString * append = [[NSString alloc] initWithFormat:first arguments:args];
            [(NSMutableString *)self appendString:append];
            
            va_end( args );
        }
        
        [(NSMutableString *)self appendString:@"\n"];
        
        return self;
    };
    
    return [block copy];
}

- (NSMutableStringReplaceBlock)REPLACE
{
    NSMutableStringReplaceBlock block = ^ NSMutableString * ( NSString * string1, NSString * string2 )
    {
        [self replaceOccurrencesOfString:string1
                              withString:string2
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, self.length)];
        
        return self;
    };
    
    return [block copy];
}

@end

