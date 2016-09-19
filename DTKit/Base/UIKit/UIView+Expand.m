//
//  UIView+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIView+Expand.h"

@implementation UIView (Expand)

- (UIViewController *)viewController
{
    //下一个响应者
    UIResponder *next=self.nextResponder;
    //循环查找viewController
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}

- (UIView *)subViewWithTag:(int)tag
{
    for (UIView *v in self.subviews)
    {
        if (v.tag == tag)
        {
            return v;
        }
    }
    return nil;
}

- (UIView *)duplicate
{
    // 妙用NSCoding协议，来实现copy
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)removeAllSubviews
{
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
//    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)hideAllSubviews:(BOOL)hide
{
    for (UIView *child in self.subviews) {
        child.hidden = hide;
    }
}

- (void)setAllSubviewsAlpha:(CGFloat)alpha
{
    for (UIView *child in self.subviews) {
        child.alpha = alpha;
    }
}

- (void)removeAfterDelay:(NSTimeInterval)time
{
    [self performSelector:@selector(removeFromSuperview)
               withObject:nil
               afterDelay:time];
}

- (UIImage *)imageRepresentation {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSArray *)superviews {
    NSMutableArray *superviews = [[NSMutableArray alloc] init];
    
    UIView *view = self;
    UIView *superview = nil;
    while (view) {
        superview = [view superview];
        if (!superview) break;
        [superviews addObject:superview];
        view = superview;
    }
    return superviews;
}

- (void)fadeOut {
    if (self.alpha == 0) return;
    UIView *view = self;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 0.0f;
    } completion:nil];
}


- (void)fadeOutAndRemoveFromSuperview {
    UIView *view = self;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)fadeIn {
    if (self.alpha == 1) return;
    UIView *view = self;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1.0f;
    } completion:nil];
}

@end
