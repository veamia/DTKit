//
//  DTTools.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTTools.h"

CGSize screenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

CGFloat screenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

UIScreenMode *currentMode() {
    static UIScreenMode *mode;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mode = [UIScreen mainScreen].currentMode;
    });
    return mode;
}
