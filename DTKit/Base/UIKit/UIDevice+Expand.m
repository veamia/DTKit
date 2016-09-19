//
//  UIDevice+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIDevice+Expand.h"

@implementation UIDevice (Expand)

+ (AVCaptureTorchMode)torchOnOrOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (device.torchMode == AVCaptureTorchModeOff) {
        [device setTorchMode:AVCaptureTorchModeOn];
    } else {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
    [device unlockForConfiguration];
    return device.torchMode;
}

@end
