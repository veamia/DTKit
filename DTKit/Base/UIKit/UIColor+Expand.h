//
//  UIColor+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -  简写

#undef	RGBA
#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#undef	RGB
#define RGB(R, G, B)     RGBA(R, G, B, 1.0f)

#undef  RandomColor
#define RandomColor      RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor fromHexValue:V]

#undef	HEX_RGBA
#define HEX_RGBA(V, A)	[UIColor fromHexValue:V alpha:A]

#undef	SHORT_RGB
#define SHORT_RGB(V)	[UIColor fromShortHexValue:V]

#undef	STRING_RGB
#define STRING_RGB(str)	[UIColor colorWithString:str]

#pragma mark -

@interface UIColor (Expand)

/**
 *  根据UIColor返回RGB数组。
 *  @param  color:传递的参数。
 *  return  RGB数组
 */
+ (NSArray *)convertColorToRBG:(UIColor *)color;

+ (UIColor *)fromHexValue:(NSUInteger)hex;
+ (UIColor *)fromHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)fromShortHexValue:(NSUInteger)hex;
+ (UIColor *)fromShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithString:(NSString *)string; // {#FFF|#FFFFFF|#FFFFFFFF}{,0.6}

+ (UIColor *)randomColor;

@end
