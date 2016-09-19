//
//  DTTakePhoto.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTTakePhotoType)
{
    DTTakePhotoFromCamera,        //调用摄像头
    DTTakePhotoFromPhotoLibrary,  //调用图片库
    DTTakePhotoSavedPhotosAlbum   //调用iOS设备中的胶卷相机的图片.
};

//完成照相后获取到图片回调
typedef void (^CompleteTakePhotoBlock) (UIImage *image, NSString *videoPath);

@interface DTTakePhoto : NSObject

// 选择获取照片的方式，默认为DTTakePhotoFromCamera
@property (nonatomic) DTTakePhotoType type;

//是否可以编辑， 默认为NO
@property (nonatomic) BOOL isEdit;

//是否保存到相册，默认为NO
@property (nonatomic) BOOL isSaveToAlbum;

@property (nonatomic, copy) CompleteTakePhotoBlock blockComplete;

// 初始化
- (instancetype)initWithTakePhotoType:(DTTakePhotoType)type;

// start
- (void)startTakePhotoFromViewControl:(UIViewController *)viewControl
                             complete:(CompleteTakePhotoBlock)complete;

@end
