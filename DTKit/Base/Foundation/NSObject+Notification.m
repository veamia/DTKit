//
//  NSObject+Notification.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSObject+Notification.h"
#import "NSObject+SEL.h"

@implementation NSObject (Notification)

- (void)addNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:[self selWithName:notificationName]
                                                 name:notificationName
                                               object:nil];
}

- (void)removeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)removeAllNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name
              withObject:(NSObject *)object
            withUserInfo:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

- (void)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [self postNotification:name withObject:object withUserInfo:nil];
}

- (void)postNotification:(NSString *)name
{
    [self postNotification:name withObject:nil withUserInfo:nil];
}

@end
