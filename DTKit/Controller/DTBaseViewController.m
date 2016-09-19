//
//  DTBaseViewController.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTBaseViewController.h"
#import "DTBaseNavigationController.h"
#import "DTKitMacro.h"
#import "DTButton.h"
#import "UIView+Animation.h"
#import "UIView+Frame.h"
#import "NSObject+Notification.h"

@interface DTBaseViewController () <UIGestureRecognizerDelegate>
{
    UIView *_keyboarkMoveView;
}

//标记是哪个UITextField被点击了
@property (nonatomic, strong) UITextField *markTextField;
@property (nonatomic) float moveViewOrgY; //将要移动的视图的位置
@property (nonatomic) float markViewOrgY; //点击文本视图初始位置

@end

@implementation DTBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        self.isCustomNaviBar = YES;
        self.title = self.mainTitle;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isHaveKeyboard)
    {
        [self addNotification:UIKeyboardWillShowNotification];
        [self addNotification:UIKeyboardWillHideNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isHaveKeyboard)
    {
        [self removeNotification:UIKeyboardWillShowNotification];
        [self removeNotification:UIKeyboardWillHideNotification];
    }
}

#pragma mark - 默认导航栏-title
- (void)setTitle:(NSString *)title
{
    self.mainTitle = title;
    if (!title) {
        self.mainTitle = title = @"";
    }
    if (self.isCustomNaviBar) {
        self.customNaviBar.title = title;
    } else {
        self.navigationItem.title = title;
    }
}

- (NSString *)title
{
    return self.mainTitle;
}

- (void)setIsCustomNaviBar:(BOOL)isCustomNaviBar
{
    _isCustomNaviBar = isCustomNaviBar;
    if (isCustomNaviBar) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBarHidden = YES;
        if (self.customNaviBar.superview == nil) {
            [self.view addSubview:self.customNaviBar];
        }
    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBarHidden = NO;
    }
    
    [self showBackButtonItem];
}

- (DTNavigationBar *)customNaviBar
{
    if (!_customNaviBar) {
        CGFloat width = dtScreenWidth; CGFloat height = dtNavBarHeight;
        _customNaviBar = [[DTNavigationBar alloc] initWithFrame:
                          CGRectMake(0, 0, width, height)];
    }
    return _customNaviBar;
}

- (UIView *)backView
{
    if (!_backView) {
        CGFloat height = dtScreenHeight-dtNavBarHeight;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarHeight, dtScreenWidth, height)];
        [self.view addSubview:_backView];
        [self.view sendSubviewToBack:_backView];
    }
    return _backView;
}

- (void)setNaviBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.isCustomNaviBar) {
        if (animated) {
            if (hidden) {
                [self.customNaviBar animationPush:DTDirectionTop];
            } else {
                [self.customNaviBar animationPush:DTDirectionBottom];
            }
        }
        self.customNaviBar.hidden = hidden;
    } else {
        [self.navigationController setNavigationBarHidden:hidden animated:YES];
    }
}

- (void)showBackButtonItem
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1) {
        [self showReturnButton];
    }
}

- (void)showReturnButton
{
    if (self.navigationController.navigationBarHidden) {
        if (dtIsKindOf(self.customNaviBar.leftView, DTButton)) {
            DTButton *btn = (DTButton *)self.customNaviBar.leftView;
            btn.stateNormal.image = dtImageByName(@"return");
            [btn setTarget:self action:@selector(popPrevController)];
        }
    } else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:dtImageByName(@"return") style:UIBarButtonItemStylePlain target:self action:@selector(popPrevController)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)setGesturePop:(BOOL)isPop
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = isPop;
    }
}

#pragma mark -
#pragma mark keyborad

- (UIView *)keyboarkMoveView
{
    if (!_keyboarkMoveView) {
        _keyboarkMoveView = self.view;
        self.moveViewOrgY = self.view.y;
    }
    
    return _keyboarkMoveView;
}

- (void)setKeyboarkMoveView:(UIView *)keyboarkMoveView
{
    _keyboarkMoveView = keyboarkMoveView;
    self.moveViewOrgY = keyboarkMoveView.y;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.markViewOrgY = textField.offset.y;
    self.markTextField = textField;
}

#pragma mark - UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    self.markViewOrgY = textView.offset.y;
//    self.markTextField = (UITextField *)textView;
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // textView委托执行顺序不一样
    self.markViewOrgY = textView.offset.y;
    self.markTextField = (UITextField *)textView;
    
    return YES;
}

#pragma mark - 键盘隐藏显示通知事件
ON_Notification(notification)
{
    NSString *name = notification.name;
    BOOL keyboardHidden = [name isEqualToString:UIKeyboardWillHideNotification];
    BOOL keyboardShow   = [name isEqualToString:UIKeyboardWillShowNotification];
    if (keyboardHidden || keyboardShow) {
        NSDictionary *info = [notification userInfo];
        [self keyboardWillBecomeHidden:keyboardHidden withNotificationInfo:info];
    }
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withNotificationInfo:(NSDictionary *)notificationInfo
{
    UIViewAnimationCurve animationCurve; [[notificationInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect keyboardFrameAtEndOfAnimation;
    [[notificationInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameAtEndOfAnimation];
    CGFloat keyboardHeight;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        keyboardHeight = keyboardFrameAtEndOfAnimation.size.width;
    }
    else {
        keyboardHeight = keyboardFrameAtEndOfAnimation.size.height;
    }
    
    NSTimeInterval animationDuration = [[notificationInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self keyboardWillBecomeHidden:keyboardHidden withAnimationDuration:animationDuration curve:animationCurve keyboardHeight:keyboardHeight];
}

- (void)keyboardWillBecomeHidden:(BOOL)keyboardHidden withAnimationDuration:(NSTimeInterval)animationDuration curve:(UIViewAnimationCurve)curve keyboardHeight:(CGFloat)_keyboardHeight
{
    curve |= UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:(UIViewAnimationOptions)curve animations:^{
        CGFloat keyboardHeight = keyboardHidden ? 0.0 : _keyboardHeight;
        
        [self viewWillAdjustForKeyboardHidden:keyboardHidden keyboardHeight:keyboardHeight];
        
    } completion:NULL];
}

- (void)viewWillAdjustForKeyboardHidden:(BOOL)keyboardHidden keyboardHeight:(CGFloat)keyboardHeight
{
    if (!self.markTextField) return;
    
    // 得到下边框到底部的距离
    float bottomY = dtScreenHeight-self.markViewOrgY-self.markTextField.height-10;
    if (keyboardHeight && bottomY >= keyboardHeight) {
        [self keyboardShowHideComplete:!keyboardHidden];
        return;
    }
    float moveY = keyboardHeight - self.moveViewOrgY - (bottomY>0?bottomY:0);
    self.keyboarkMoveView.top = keyboardHeight == 0.0 ? self.moveViewOrgY : -moveY;
    [self keyboardShowHideComplete:!keyboardHidden];
}

- (void)keyboardShowHideComplete:(BOOL)show
{
    
}

#pragma mark -
#pragma mark push pop present dismiss

- (void)push:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController
                                         animated:animated];
}

- (void)push:(UIViewController *)viewController
{
    [self push:viewController animated:YES];
}

- (void)popPrevController
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)popRootController
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (__kindof UIViewController *)popToViewControllerClass:(Class)className
{
    if (!self.navigationController) return nil;
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *viewController = nil;
    for (int i=0; i<array.count; i++) {
        UIViewController *vc = array[i];
        if (dtIsKindOf(vc, className)) {
            viewController = vc;
            break;
        }
    }
    if (viewController) {
        [self.navigationController popToViewController:viewController animated:YES];
    }
    return viewController;
}

- (void)present:(UIViewController *)viewController animated:(BOOL)animated
{
    [self presentViewController:viewController animated:animated completion:NULL];
}

- (void)present:(UIViewController *)viewController
{
    [self present:viewController animated:YES];
}

- (void)presentWithNaviRoot:(UIViewController *)viewController
{
    DTBaseNavigationController *navi = [[DTBaseNavigationController alloc] initWithRootViewController:viewController];
    [self present:navi];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark 

//iOS8下横屏会隐藏掉状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
}

@end
