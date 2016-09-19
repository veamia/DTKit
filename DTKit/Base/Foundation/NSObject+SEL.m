//
//  NSObject+SEL.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSObject+SEL.h"

@implementation NSObject (SEL)

- (SEL)selWithName:(NSString *)__name
{
    SEL selector;
    NSArray * array = [__name componentsSeparatedByString:@"."];
    if ( array && array.count == 3 )
    {
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *name = (NSString *)[array objectAtIndex:2];
        NSString *selectorName;
        selectorName = [NSString stringWithFormat:@"handleSignal_%@_%@:", clazz, name];
        selector = NSSelectorFromString(selectorName);
    } else if ( array && array.count == 2 ){
        NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *name = (NSString *)[array objectAtIndex:1];
        NSString *selectorName;
        selectorName = [NSString stringWithFormat:@"handleSignal_%@_%@:", prefix, name];
        selector = NSSelectorFromString(selectorName);
    } else {
        NSString *selectorName = @"handleSignal:";
        selector = NSSelectorFromString(selectorName);
    }
    return selector;
}

@end
