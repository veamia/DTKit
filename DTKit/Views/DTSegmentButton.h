//
//  DTSegmentButton.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTButton;
typedef void (^SelectSegmentButtonIndex) (NSInteger index);
typedef void (^SelectSegmentButton) (DTButton *button);

@interface DTSegmentButton : UIView

@property (nonatomic, strong, readonly) NSMutableArray *items;      // 选项 所有按钮
@property (nonatomic) NSInteger selectIndex;// 选择的按钮索引
@property (nonatomic, copy) SelectSegmentButtonIndex blockSelect;
@property (nonatomic, copy) SelectSegmentButton blockSelectButton;

@property (nonatomic) BOOL isCanSelect; // 是否可选，默认YES

@property (nonatomic) float septalLineHeight;
@property (nonatomic, strong) UIColor *septalLineColor;
@property (nonatomic) float cornerRadius; // 圆角，默认为 0
@property (nonatomic) BOOL isSupportMutableSelect; //支持多选，默认NO

- (id)initWithFrame:(CGRect)frame items:(NSArray *)buttonItems;
- (void)selectToIndex:(NSInteger)index;
- (void)selectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;//多选

- (DTButton *)buttonWithIndex:(NSInteger)index;

- (void)insertButton:(DTButton *)button toIndex:(NSInteger)index;

- (void)removeButtonWithIndex:(NSInteger)index;
- (void)removeButtonWithTitle:(NSString *)title;

@end
