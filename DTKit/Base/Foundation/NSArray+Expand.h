//
//  NSArray+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );
typedef NSComparisonResult	(^NSMutableArrayCompareBlock)( id left, id right );

#pragma mark -

@interface NSArray (Expand)

@property (nonatomic, readonly) NSArrayAppendBlock			append;
@property (nonatomic, readonly) NSMutableArray *			mutableArray;

- (NSArray *)head:(NSUInteger)count;
- (NSArray *)tail:(NSUInteger)count;

// 安全获取对象，防止crash
- (id)safeObjectAtIndex:(NSInteger)index;
- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSString *)join:(NSString *)delimiter; // 用分隔符隔开，形成字符串
- (NSArray *)randomizedArray; // 将数组中的元素随机排列
- (NSArray *)randomizedArray:(NSInteger)count; // 随机从数组中取出count个数据

- (NSArray *)reverseArray; // 将数组倒序排列

@end

@interface NSMutableArray (Expand)

@property (nonatomic, readonly) NSMutableArrayAppendBlock	APPEND;

+ (NSMutableArray *)nonRetainingArray; // copy from Three20

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSMutableArrayCompareBlock)compare;

- (void)unique;
- (void)unique:(NSMutableArrayCompareBlock)compare;

- (void)sort;
- (void)sort:(NSMutableArrayCompareBlock)compare;

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

- (void)removeObject:(NSObject *)obj usingComparator:(NSMutableArrayCompareBlock)cmptr;

@end
