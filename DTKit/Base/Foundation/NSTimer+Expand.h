//
//  NSTimer+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Expand)

// 将当前计时器添加到runloop
- (void)addToRunloop;
+ (NSTimer *)scheduled:(NSTimeInterval)interval
                 block:(void (^)(NSTimer *timer))block
               repeats:(BOOL)repeats;
+ (void)cancelTimer:(NSTimer *)timer;


+ (dispatch_source_t)gcdScheduled:(NSTimeInterval)interval
                            block:(void (^)())block;
+ (void)cancelGCDTimer:(dispatch_source_t)timer;


@end
