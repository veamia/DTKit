//
//  NSDictionary+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

typedef NSDictionary *	(^NSDictionaryAppendBlock)( NSString * key, id value );

#pragma mark -


@interface NSDictionary (Expand)

@property (nonatomic, readonly) NSDictionaryAppendBlock	append;

- (NSMutableDictionary *)mutableDeepCopy;

- (id)objectOfAny:(NSArray *)array;
- (NSString *)stringOfAny:(NSArray *)array;

- (id)objectAtPath:(NSString *)path;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other;

- (id)objectAtPath:(NSString *)path separator:(NSString *)separator;
- (id)objectAtPath:(NSString *)path otherwise:(NSObject *)other separator:(NSString *)separator;

- (BOOL)boolAtPath:(NSString *)path;
- (BOOL)boolAtPath:(NSString *)path otherwise:(BOOL)other;

- (NSNumber *)numberAtPath:(NSString *)path;
- (NSNumber *)numberAtPath:(NSString *)path otherwise:(NSNumber *)other;

- (NSString *)stringAtPath:(NSString *)path;
- (NSString *)stringAtPath:(NSString *)path otherwise:(NSString *)other;

- (NSArray *)arrayAtPath:(NSString *)path;
- (NSArray *)arrayAtPath:(NSString *)path otherwise:(NSArray *)other;

- (NSMutableArray *)mutableArrayAtPath:(NSString *)path;
- (NSMutableArray *)mutableArrayAtPath:(NSString *)path otherwise:(NSMutableArray *)other;

- (NSDictionary *)dictAtPath:(NSString *)path;
- (NSDictionary *)dictAtPath:(NSString *)path otherwise:(NSDictionary *)other;

- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path;
- (NSMutableDictionary *)mutableDictAtPath:(NSString *)path otherwise:(NSMutableDictionary *)other;

@end

@interface NSMutableDictionary (Expand)

@property (nonatomic, readonly) NSDictionaryAppendBlock	APPEND;

+ (NSMutableDictionary *)nonRetainingDictionary;// copy from Three20

- (NSString *)stringOfAny:(NSArray *)array removeAll:(BOOL)flag;

- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path;
- (BOOL)setObject:(NSObject *)obj atPath:(NSString *)path separator:(NSString *)separator;

//- (BOOL)setKeyValues:(id)first, ...;

+ (NSMutableDictionary *)keyValues:(id)first, ...;

@end