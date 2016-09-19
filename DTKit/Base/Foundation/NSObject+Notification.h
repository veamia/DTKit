//
//  NSObject+Notification.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#undef	AS_Notification
#define AS_Notification( __name )   AS_Static_Property( __name )

// 定义通知名称
#undef	DEF_Notification
#define DEF_Notification( __name )  DEF_Static_Property2( __name, @"notify" )

// 接收通知
#undef	ON_Notification
#define ON_Notification( __notification ) \
- (void)handleSignal:(NSNotification *)__notification

#undef	ON_Notification2
#define ON_Notification2( __filter, __notification ) \
- (void)handleSignal_notify_##__filter:(NSNotification *)__notification

//发送通知 在代码中编写

#pragma mark -

@interface NSObject (Notification)

- (void)addNotification:(NSString *)name;//notify.clazz.name

- (void)removeNotification:(NSString *)name;
- (void)removeAllNotification;

- (void)postNotification:(NSString *)name;
- (void)postNotification:(NSString *)name withObject:(NSObject *)object;
- (void)postNotification:(NSString *)name
              withObject:(NSObject *)object
            withUserInfo:(NSDictionary *)userInfo;

@end
