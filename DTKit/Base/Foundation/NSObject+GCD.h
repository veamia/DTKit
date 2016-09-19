//
//  NSObject+GCD.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 简写

#define GCD_Back_Begin		[self enterBackground:^{
#define GCD_Back_Delay(x)	[self enterBackgroundWithDelay:(dispatch_time_t)x block:^{
#define GCD_Back_End        }];

#define GCD_Fore_Begin		[self enterForeground:^{
#define GCD_Fore_Delay(x)	[self enterForegroundWithDelay:(dispatch_time_t)x block:^{
#define GCD_Fore_End        }];

#pragma mark -

@interface NSObject (GCD)

- (dispatch_queue_t)foreQueue;
- (dispatch_queue_t)backQueue;

- (void)enterBackground:(dispatch_block_t)block;
- (void)enterForeground:(dispatch_block_t)block;

- (void)enterForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
- (void)enterBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

@end