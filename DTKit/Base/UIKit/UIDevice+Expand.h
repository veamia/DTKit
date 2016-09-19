//
//  UIDevice+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIDevice (Expand)

// 手电筒开关
+ (AVCaptureTorchMode)torchOnOrOff;

@end
