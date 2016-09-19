//
//  UIView+Background.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIView+Background.h"
#import "UIView+Frame.h"
#import "DTKitMacro.h"

@implementation UIView (Background)

- (BOOL)hasBackgroundImageView
{
    UIImageView * imageView = nil;
    
    for ( UIView * subView in self.subviews )
    {
        if ( [subView isKindOfClass:[UIImageView class]] )
        {
            imageView = (UIImageView *)subView;
            break;
        }
    }
    
    return imageView ? YES : NO;
}

- (UIImageView *)backgroundImageView
{
    UIImageView * imageView = nil;
    
    for ( UIView * subView in self.subviews )
    {
        if ( dtIsKindOf(subView, UIImageView) && CGSizeEqualToSize(self.size, subView.size))
        {
            imageView = (UIImageView *)subView;
            break;
        }
    }
    
    if ( nil == imageView )
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizesSubviews = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
    }
    
    return imageView;
}

- (UIImage *)backgroundImage
{
    return self.backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage *)image
{
    UIImageView * imageView = self.backgroundImageView;
    if ( imageView )
    {
        if ( image )
        {
            imageView.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
            imageView.image = image;
            [imageView setNeedsDisplay];
        }
        else
        {
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
}

- (UIImage *)foregroundImage
{
    return self.backgroundImageView.image;
}

- (void)setForegroundImage:(UIImage *)image
{
    UIImageView *imageView = self.backgroundImageView;
    [self bringSubviewToFront:imageView];
    if ( imageView )
    {
        if ( image )
        {
            imageView.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height );
            imageView.image = image;
            [imageView setNeedsDisplay];
        }
        else
        {
            imageView.image = nil;
            [imageView removeFromSuperview];
        }
    }
}

@end
