//
//  DTSingleton.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

/*简单单例模式*/
// @interface
#define dt_Singleton_ITF(className) \
+ (instancetype)sharedInstance;

// @implementation
#define dt_Singleton_IMP(className) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)sharedInstance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
