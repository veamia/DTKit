//
//  UIView+Gesture.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "UIView+Gesture.h"
#import "NSObject+SEL.h"

@implementation UIView (Gesture)

DEF_Gesture(LongPress)
DEF_Gesture(Tap)
DEF_Gesture(Pan)
DEF_Gesture(Swipe)
DEF_Gesture(Pinch)
DEF_Gesture(Rotation)

- (UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)target
{
    UILongPressGestureRecognizer *gesture = nil;
    for ( UIGestureRecognizer * ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UILongPressGestureRecognizer) )
        {
            gesture = (UILongPressGestureRecognizer *)ges;
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target
                                                                action:[self selWithName:self.LongPress]];
        gesture.minimumPressDuration = 0.75f;
        gesture.delegate = target;
        [self addGestureRecognizer:gesture];
    }
    
    return gesture;
}

- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target fingerCount:(NSUInteger)fingerCount
{
    //这里处理了在一个视图中出现两个Tap手势（单击和双击）导致并行触发的行为
    UITapGestureRecognizer *gesture = nil;
    UITapGestureRecognizer *otherGesture = nil;
    for ( UIGestureRecognizer *ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UITapGestureRecognizer) )
        {
            NSUInteger count = ((UITapGestureRecognizer *)ges).numberOfTapsRequired;
            if (count == fingerCount ) {
                gesture = (UITapGestureRecognizer *)ges;
            } else {
                otherGesture = (UITapGestureRecognizer *)ges;
            }
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:target
                                                          action:[self selWithName:self.Tap]];
        gesture.numberOfTapsRequired = fingerCount;
        gesture.delegate = target;
        [self addGestureRecognizer:gesture];
    }
    
    if (otherGesture && gesture != otherGesture) {
        if (gesture.numberOfTapsRequired == 1) {
            [gesture requireGestureRecognizerToFail:otherGesture];
        } else {
            [otherGesture requireGestureRecognizerToFail:gesture];
        }
    }
    
    return gesture;
}

- (UIPanGestureRecognizer *)addPanGestureWithTarget:(id)target
{
    UIPanGestureRecognizer *gesture = nil;
    for ( UIGestureRecognizer * ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UIPanGestureRecognizer) )
        {
            gesture = (UIPanGestureRecognizer *)ges;
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:target
                                                          action:[self selWithName:self.Pan]];
        gesture.delegate = target;
        [self addGestureRecognizer:gesture];
    }
    return gesture;
}

- (UIPinchGestureRecognizer *)addPinchGestureWithTarget:(id)target
{
    UIPinchGestureRecognizer *gesture = nil;
    for ( UIGestureRecognizer * ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UIPinchGestureRecognizer) )
        {
            gesture = (UIPinchGestureRecognizer *)ges;
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:target
                                                            action:[self selWithName:self.Pinch]];
        gesture.delegate = target;
        [self addGestureRecognizer:gesture];
    }
    return gesture;
}

- (UISwipeGestureRecognizer *)addSwipeGestureWithTarget:(id)target
{
    UISwipeGestureRecognizer *gesture = nil;
    for ( UIGestureRecognizer * ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UISwipeGestureRecognizer) )
        {
            gesture = (UISwipeGestureRecognizer *)ges;
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:target
                                                            action:[self selWithName:self.Swipe]];
        gesture.delegate = target;
//        gesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:gesture];
    }
    
    return gesture;
}

- (UIRotationGestureRecognizer *)addRotationGestureWithTarget:(id)target
{
    UIRotationGestureRecognizer *gesture = nil;
    for ( UIGestureRecognizer * ges in self.gestureRecognizers )
    {
        if ( dtIsKindOf(ges, UIRotationGestureRecognizer) )
        {
            gesture = (UIRotationGestureRecognizer *)ges;
        }
    }
    
    if ( nil == gesture )
    {
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:target
                                                               action:[self selWithName:self.Rotation]];
        gesture.delegate = target;
        [self addGestureRecognizer:gesture];
    }
    return gesture;
}

- (void)removeAllGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
}

@end
