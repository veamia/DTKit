//
//  NSObject+GCD.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSObject+GCD.h"

static dispatch_queue_t _foreQueue = nil;
static dispatch_queue_t _backQueue = nil;

@implementation NSObject (GCD)

- (dispatch_queue_t)foreQueue
{
    if (!_foreQueue) {
        _foreQueue = dispatch_get_main_queue();
    }
    return _foreQueue;
}

- (dispatch_queue_t)backQueue
{
    if (!_backQueue) {
        _backQueue = dispatch_queue_create( "com.dt.taskQueue", nil );
    }
    return _backQueue;
}

- (void)enterForeground:(dispatch_block_t)block
{
    return dispatch_async( self.foreQueue, block );
}

- (void)enterBackground:(dispatch_block_t)block
{
    return dispatch_async( self.backQueue, block );
}

- (void)enterForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * NSEC_PER_SEC);
    dispatch_after( time, self.foreQueue, block );
}

- (void)enterBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * NSEC_PER_SEC);
    dispatch_after( time, self.backQueue, block );
}

@end