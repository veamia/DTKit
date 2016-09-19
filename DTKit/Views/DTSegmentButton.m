//
//  DTSegmentButton.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTSegmentButton.h"
#import "DTButton.h"
#import "UIView+Layer.h"

@interface DTSegmentButton ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation DTSegmentButton

- (id)initWithFrame:(CGRect)frame items:(NSArray *)buttonItems;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isCanSelect = YES;
        _selectIndex = -1;
        NSInteger btnCount = buttonItems.count;
        [self.items setArray:buttonItems];
        CGFloat btnWidth = (self.frame.size.width)*1.0/btnCount;
        for (int i=0; i<btnCount; i++) {
            DTButton *button = buttonItems[i];
            button.tag = i;
            button.frame = CGRectMake(btnWidth*i, 0, btnWidth, frame.size.height);
            [button setTarget:self action:@selector(buttonClick:)];
            [self addSubview:button];
        }
    }
    return self;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (void)reLayout
{
    CGFloat btnWidth = (self.frame.size.width)*1.0/self.items.count;
    for (int i=0; i<self.items.count; i++) {
        DTButton *button = self.items[i];
        button.frame = CGRectMake(btnWidth*i, 0, btnWidth, self.frame.size.height);
    }
    [self setNeedsDisplay];
}

- (void)buttonClick:(DTButton *)button
{
    if (self.isSupportMutableSelect) {
        button.selected = !button.selected;
        if (self.blockSelect) {
            self.blockSelect(button.tag);
        }
    } else if (self.isCanSelect) {
        if (button.tag != self.selectIndex) {
            self.selectIndex = button.tag;
        }
    } else {
        self.selectIndex = button.tag;
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (self.isCanSelect) {
        for (int i=0; i<self.items.count; i++) {
            DTButton *button = self.items[i];
            if (button.tag == selectIndex) {
                button.selected = YES;
                if (self.blockSelectButton) {
                    self.blockSelectButton(button);
                }
            } else {
                button.selected = NO;
            }
        }
    }
    
    if (self.blockSelect) {
        self.blockSelect(selectIndex);
    }
}

- (void)setSeptalLineHeight:(float)septalLineHeight
{
    _septalLineHeight = septalLineHeight;
    [self setNeedsDisplay];
}

- (void)setSeptalLineColor:(UIColor *)septalLineColor
{
    _septalLineColor = septalLineColor;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(float)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self cornerRadius:cornerRadius];
}

- (void)selectToIndex:(NSInteger)index
{
    _selectIndex = index;
    if (self.isCanSelect) {
        for (int i=0; i<self.items.count; i++) {
            DTButton *button = self.items[i];
            if (button.tag == index) {
                button.selected = YES;
            } else {
                button.selected = NO;
            }
        }
    }
}

- (void)selectFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    for (int i=0; i<self.items.count; i++) {
        DTButton *button = self.items[i];
        if (button.tag>=fromIndex && button.tag<=toIndex) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

- (DTButton *)buttonWithIndex:(NSInteger)index
{
    if (self.items.count > index) {
        for (DTButton *btn in self.items) {
            if (btn.tag == index) {
                return btn;
            }
        }
    }
    return nil;
}

- (void)insertButton:(DTButton *)button toIndex:(NSInteger)index
{
    if (self.items.count > index) {
        [button setTarget:self action:@selector(buttonClick:)];
        [self addSubview:button];
        [self.items insertObject:button atIndex:index];
    }
    
    for (int i=0; i<self.items.count; i++) {
        DTButton *btn = self.items[i];
        btn.tag = i;
    }
    [self reLayout];
}

- (void)removeButtonWithIndex:(NSInteger)index
{
    if (self.items.count > index) {
        DTButton *btn = self.items[index];
        [self.items removeObjectAtIndex:index];
        [btn removeFromSuperview];
    }
    
    for (int i=0; i<self.items.count; i++) {
        DTButton *btn = self.items[i];
        btn.tag = i;
    }
    [self reLayout];
}

- (void)removeButtonWithTitle:(NSString *)title
{
    for (DTButton *btn in self.items) {
        if ([btn.stateNormal.title isEqualToString:title]) {
            [self.items removeObject:btn];
            [btn removeFromSuperview];
            break;
        }
    }
    
    for (int i=0; i<self.items.count; i++) {
        DTButton *btn = self.items[i];
        btn.tag = i;
    }
    [self reLayout];
}

- (void)drawRect:(CGRect)rect
{
    if (self.septalLineHeight>0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *color = self.septalLineColor;
        if (!color) {
            color = [UIColor lightGrayColor];
        }
        float width = rect.size.width/self.items.count;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 0.5f);
        
        float distanse = self.septalLineHeight;
        for (int i=1; i<self.items.count; i++) {
            CGContextMoveToPoint(context, width*i, distanse);
            CGContextAddLineToPoint(context, width*i, rect.size.height-distanse);
            CGContextStrokePath(context);
        }
    }
}


@end
