//
//  DTTakePhoto.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTTakePhoto.h"
#import "NSObject+GCD.h"
#import "UIImage+Expand.h"

@interface DTTakePhoto ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation DTTakePhoto

- (instancetype)init
{
    return [self initWithTakePhotoType:DTTakePhotoFromCamera];
}

- (instancetype)initWithTakePhotoType:(DTTakePhotoType)type
{
    if (self = [super init]) {
        self.type = type;
        self.isEdit = NO;
        self.isSaveToAlbum = NO;
    }
    return self;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (void)addIndicatorViewToPickerView:(UIView *)pickerView
{
    self.indicatorView.center = pickerView.center;
    [pickerView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

- (void)removeIndicatorViewFromPikerView:(UIView *)pickerView
{
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
}

- (void)startTakePhotoFromViewControl:(UIViewController *)viewControl
                             complete:(CompleteTakePhotoBlock)complete
{
    self.blockComplete = complete;
    UIImagePickerControllerSourceType sourceType;
    switch (self.type) {
        case DTTakePhotoFromCamera:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case DTTakePhotoFromPhotoLibrary:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case DTTakePhotoSavedPhotosAlbum:
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        default:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = self.isEdit;
        picker.editing = YES;
        picker.sourceType = sourceType;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        [viewControl presentViewController:picker animated:YES completion:NULL];
    } else {
//        if (complete) {
//            complete(nil, nil);
//        }
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)dismissPickerViewController:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.blockComplete = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self addIndicatorViewToPickerView:picker.view];
    
    GCD_Back_Begin
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image = nil;
    NSString *videoPath = nil;
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *originImage;
        if (self.isEdit) {
            originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (self.isSaveToAlbum) {
            UIImageWriteToSavedPhotosAlbum(originImage, NULL, NULL, NULL);
        }
        
        UIImage *scaleImage = [UIImage scaleImage:originImage toScale:0.3];
        
        NSData  *data;
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            data = UIImageJPEGRepresentation(scaleImage, 0.9);
        } else {
            data = UIImagePNGRepresentation(scaleImage);
        }
        image = [UIImage imageWithData:data];
        
    } else if ([mediaType isEqualToString:@"public.movie"]){
        videoPath = [(NSURL *)[info objectForKey:UIImagePickerControllerMediaURL] path];
        image = [UIImage imageFromVideo:videoPath];
        
        if (self.isSaveToAlbum) {
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath);
        }
    }
    GCD_Fore_Begin
    [self removeIndicatorViewFromPikerView:picker.view];
    if (self.blockComplete) {
        self.blockComplete(image, videoPath);
    }
    [self dismissPickerViewController:picker];
    GCD_Fore_End
    GCD_Back_End
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPickerViewController:picker];
}

@end
