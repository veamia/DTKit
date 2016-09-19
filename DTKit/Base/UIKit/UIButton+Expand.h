//
//  UIButton+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Expand)

- (void)addAction:(void (^)(UIButton *))block;
- (void)addAction:(void (^)(UIButton *))block
 forControlEvents:(UIControlEvents)controlEvents;

@end
