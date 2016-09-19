//
//  NSTimer+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSTimer+Expand.h"

@implementation NSTimer (Expand)

- (void)addToRunloop
{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    // NSDefaultRunLoopMode和UITrackingRunLoopMode的结合
    [runloop addTimer:self forMode:NSRunLoopCommonModes];
}

+ (NSTimer *)scheduled:(NSTimeInterval)interval
                 block:(void (^)(NSTimer *))block
               repeats:(BOOL)repeats
{
    NSParameterAssert(block != nil);
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(executeBlockFromTimer:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
    [timer addToRunloop];
    return timer;
}

+ (void)executeBlockFromTimer:(NSTimer *)timer {
    void (^block)(NSTimer *) = [timer userInfo];
    if (block) block(timer);
}

+ (void)cancelTimer:(NSTimer *)timer
{
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
}

+ (dispatch_source_t)gcdScheduled:(NSTimeInterval)interval
                            block:(void (^)())block
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(gcdTimer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC),
                              interval*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(gcdTimer, block);
    dispatch_resume(gcdTimer);
    
    return gcdTimer;
}

+ (void)cancelGCDTimer:(dispatch_source_t)timer
{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = NULL;
    }
}

@end
