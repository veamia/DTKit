//
//  DTNavigationBar.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DTNavigationBarTitleView)
@property (nonatomic, strong) NSString *text;
@end

@interface DTNavigationBar : UIView

@property (nonatomic, strong) NSString         *title;
@property (nonatomic, strong) UIView           *titleView;

@property (nonatomic, strong) UIView           *leftView;
@property (nonatomic, strong) UIView           *rightView;

@property (nonatomic, strong) UIImage          *naviBackImage;

@end
