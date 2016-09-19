//
//  UIView+Gesture.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTKitMacro.h"

#pragma mark -

#undef	AS_Gesture
#define AS_Gesture( __name ) \
AS_Static_Property( __name )

// 定义手势名称
#undef	DEF_Gesture
#define DEF_Gesture( __name ) \
DEF_Static_Property2( __name, @"gesture" )

// 接收手势

/* *****
 * __class:   手势视图的类
 * __name :   手势的名字, 如 longPress or tap
 * __gesture: 手势参数
 */
#undef	ON_Gesture
#define ON_Gesture( __name, __gesture ) \
- (void)handleSignal_gesture_##__name:(UI##__name##GestureRecognizer *)__gesture

#pragma mark -

#pragma mark - 快速定义手势事件

#undef  ON_LongPressGesture
#define ON_LongPressGesture(gesture) ON_Gesture(LongPress, gesture)

#undef  ON_TapGesture
#define ON_TapGesture(gesture)       ON_Gesture(Tap, gesture)

#undef  ON_PanGesture
#define ON_PanGesture(gesture)       ON_Gesture(Pan, gesture)

#undef  ON_SwipeGesture
#define ON_SwipeGesture(gesture)     ON_Gesture(Swipe, gesture)

#undef  ON_PinchGesture
#define ON_PinchGesture(gesture)     ON_Gesture(Pinch, gesture)

#undef  ON_RotationGesture
#define ON_RotationGesture(gesture)  ON_Gesture(Rotation, gesture)

#pragma mark -

@interface UIView (Gesture)
AS_Gesture(LongPress)
AS_Gesture(Tap)
AS_Gesture(Pan)
AS_Gesture(Swipe)
AS_Gesture(Pinch)
AS_Gesture(Rotation)

/***********预防手势冲突，可以在target中设置手势的代理，来处理冲突事件，如下:
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
 {
 // 输出点击的view的类名
 NSLog(@"%@", NSStringFromClass([touch.view class]));
 
 // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
 if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
 return NO;
 }
 return  YES;
 }
 *************/

- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target;
- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target
                                        fingerCount:(NSUInteger)fingerCount;
- (UIPanGestureRecognizer *)addPanGestureWithTarget:(id)target;
- (UISwipeGestureRecognizer *)addSwipeGestureWithTarget:(id)target;//擦碰
- (UIPinchGestureRecognizer *)addPinchGestureWithTarget:(id)target;
- (UIRotationGestureRecognizer *)addRotationGestureWithTarget:(id)target;

- (void)removeAllGestures;

@end
