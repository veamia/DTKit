//
//  NSObject+SEL.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

// 去掉使用performSelector: withObject:出现的警告
#undef  SuppressPerformSelectorLeakWarning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

// 默认发送SEL
#undef  SendSignalWithName
#define SendSignalWithName(__name, __object) \
SEL selector = [self selWithName:__name]; \
if (self.target && [self.target respondsToSelector:selector]) { \
SuppressPerformSelectorLeakWarning([self.target performSelector:selector withObject:__object]); \
} \

@interface NSObject (SEL)

- (SEL)selWithName:(NSString *)__name; // 根据name自动生成发送信号的方法

@end
