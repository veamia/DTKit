//
//  DTBaseViewController.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTNavigationBar.h"

@interface DTBaseViewController : UIViewController
<UITextFieldDelegate, UITextViewDelegate>

// 主标题
@property (nonatomic, copy) NSString *mainTitle;

// 是否有键盘
@property (nonatomic) BOOL isHaveKeyboard;
// UITextView的初始Y值是否跟着改变，默认NO
@property (nonatomic) BOOL isTextViewShouldChange;
//键盘显示需要移动的视图,默认为当前视图
@property (nonatomic, strong) UIView *keyboarkMoveView;

// 是否是自定义的导航栏，默认YES
@property (nonatomic) BOOL isCustomNaviBar;
@property (nonatomic, strong) DTNavigationBar *customNaviBar;

// 可操作View，可用也可不用
@property (nonatomic, strong) UIView *backView;

// 显示隐藏navibar
- (void)setNaviBarHidden:(BOOL)hidden animated:(BOOL)animated;

// 侧滑手势开关，在viewDidAppear后设置
- (void)setGesturePop:(BOOL)isPop;

// push or pop
- (void)push:(UIViewController *)viewController;
- (void)push:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popPrevController;
- (void)popRootController;
- (__kindof UIViewController *)popToViewControllerClass:(Class)className;

// presend and dismiss
- (void)present:(UIViewController *)viewController;
- (void)present:(UIViewController *)viewController animated:(BOOL)animated;
- (void)presentWithNaviRoot:(UIViewController *)viewController;
- (void)dismiss;

// 键盘消失
- (void)keyboardShowHideComplete:(BOOL)show;

@end
