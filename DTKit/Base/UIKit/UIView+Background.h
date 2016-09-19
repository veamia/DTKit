//
//  UIView+Background.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Background)

@property (nonatomic, readonly) BOOL		hasBackgroundImageView;
@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong)   UIImage 	*backgroundImage;
@property (nonatomic, strong)   UIImage     *foregroundImage;

@end
