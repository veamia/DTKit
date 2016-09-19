//
//  UIImage+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIImage+Expand.h"
#import "DTKitMacro.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Expand)

- (UIImage *)stretched
{
    CGFloat leftCap = floorf(self.size.width / 2.0f);
    CGFloat topCap = floorf(self.size.height / 2.0f);
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)stretched5
{
    return [self stretched:UIEdgeInsetsMake(self.size.height/2-5, self.size.width/2-5, self.size.height/2+5, self.size.width/2+5)];
}

- (UIImage *)stretched:(UIEdgeInsets)capInsets
{
    return [self resizableImageWithCapInsets:capInsets
                                resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)rotate:(CGFloat)angle
{
    UIImage *	result = nil;
    CGSize		imageSize = self.size;
    CGSize		canvasSize = CGSizeZero;
    
    angle = fmodf( angle, 360 );
    
    if ( 90 == angle || 270 == angle )
    {
        canvasSize.width = self.size.height;
        canvasSize.height = self.size.width;
    }
    else if ( 0 == angle || 180 == angle )
    {
        canvasSize.width = self.size.width;
        canvasSize.height = self.size.height;
    }
    
    UIGraphicsBeginImageContext( canvasSize );
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );
    
    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage( bitmap, CGRectMake( -(imageSize.width / 2), -(imageSize.height / 2), imageSize.width, imageSize.height), self.CGImage );
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)rotateCW90
{
    return [self rotate:270];
}

- (UIImage *)rotateCW180
{
    return [self rotate:180];
}

- (UIImage *)rotateCW270
{
    return [self rotate:90];
}

- (UIImage *)grayscale
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    return grayImage;
}

+ (UIImage *)grabScreenWithScale:(CGFloat)scale
{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    //    UIGraphicsBeginImageContext(screenWindow.frame.size);
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, YES, scale);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)grabImageWithView:(UIView *)view scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    return image;
}

+ (UIImage *)captureView:(UIView *)view frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, frame);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}

- (UIImage *)crop:(CGRect)rect
{
    CGImageRef imageRef = self.CGImage;
    CGImageRef newImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, rect, newImageRef);
    
    UIImage * image = [UIImage imageWithCGImage:newImageRef];
    
    UIGraphicsEndImageContext();
    
    CGImageRelease(newImageRef);
    
    return image;
}

- (UIImage *)imageInRect:(CGRect)rect
{
    return [self crop:rect];
}

- (UIColor *)patternColor
{
    return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)mask{
    CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [mask CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, true);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    UIImage *resultImg = [UIImage imageWithCGImage:masked];
    CGImageRelease(actualMask);
    CGImageRelease(masked);
    
    return resultImg;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    CGFloat width = image.size.width*scaleSize;
    CGFloat height = image.size.height*scaleSize;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)imageFromVideo:(NSURL *)videoURL atTime:(CMTime)time scale:(CGFloat)scale
{
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator * generater = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generater.appliesPreferredTrackTransform = YES;
    generater.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    generater.maximumSize = [UIScreen mainScreen].bounds.size;
    NSError * error = nil;
    CGImageRef image = [generater copyCGImageAtTime:time actualTime:NULL error:&error];
    UIImage * thumb = [[UIImage alloc] initWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(image);
    return thumb;
}

+ (UIImage *)imageFromVideo:(NSString *)videoPath
{
    if (!videoPath)
        return nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    return thumbnailImage;
}

+ (UIImage *)merge:(NSArray *)images
{
    UIImage * image = nil;
    for ( UIImage * otherImage in images ) {
        if ( nil == image ) {
            image = otherImage;
        } else {
            image = [image merge:otherImage];
        }
    }
    return image;
}

- (UIImage *)merge:(UIImage *)image
{
    CGSize canvasSize;
    canvasSize.width = fmaxf( self.size.width, image.size.width );
    canvasSize.height = fmaxf( self.size.height, image.size.height );
    
    UIGraphicsBeginImageContextWithOptions( canvasSize, NO, self.scale );
    
    CGPoint offset1;
    offset1.x = (canvasSize.width - self.size.width) / 2.0f;
    offset1.y = (canvasSize.height - self.size.height) / 2.0f;
    
    CGPoint offset2;
    offset2.x = (canvasSize.width - image.size.width) / 2.0f;
    offset2.y = (canvasSize.height - image.size.height) / 2.0f;
    
    [self drawAtPoint:offset1 blendMode:kCGBlendModeNormal alpha:1.0f];
    [image drawAtPoint:offset2 blendMode:kCGBlendModeNormal alpha:1.0f];
    
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)lanchImage
{
    UIImage *lanchImage;
    if (dtIsPhone4) {
        lanchImage = [UIImage imageNamed:@"LaunchImage-700-568h"];
    } else if (dtIsPhone47) {
        lanchImage = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (dtIsPhone55) {
        lanchImage = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
    } else {
        lanchImage = [UIImage imageNamed:@"LaunchImage-700"];
    }
    return lanchImage;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:dtRadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(dtDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, dtDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)squareImage {
    CGSize imageSize = self.size;
    CGFloat shortestSide = fminf(imageSize.width, imageSize.height);
    return [self imageAtRect:CGRectMake(0.0f, 0.0f, shortestSide, shortestSide)];
}

- (UIImage*)circleImageWithParam:(CGFloat)inset {
    
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, self.size.width - inset * 2.0f, self.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextSetAllowsAntialiasing(context, YES);//去锯齿
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

- (UIImage *)addText:(NSString *)text
              atRect:(CGRect)rect
            fontAttr:(NSDictionary *)attributes
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [text drawInRect:rect withAttributes:attributes];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

- (UIImage *)imageRotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius
                             sizeToFit:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, dtScreenScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


@end
