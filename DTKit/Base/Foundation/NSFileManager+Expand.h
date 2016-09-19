//
//  NSFileManager+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSFileManager (Expand)

// 在相应目录下创建一个文件夹
+ (BOOL)createFolder:(NSString *)folder atPath:(NSString *)path;
+ (BOOL)createFolder:(NSString *)path;

// 保存文件到相应路径下
+ (BOOL)saveData:(NSData *)data withName:(NSString *)name atPath:(NSString *)path;

// 查找并返回文件
+ (NSData *)findFile:(NSString *)fileName atPath:(NSString *)path;

// 删除文件
+ (BOOL)deleteFile:(NSString *)fileName atPath:(NSString *)path;
+ (BOOL)deleteFilePath:(NSString *)path;

// 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
@property (nonatomic, strong, readonly) NSURL    *documentsDirectoryURL;
@property (nonatomic, strong, readonly) NSString *documentPath;
+ (NSURL *)documentURL;
+ (NSString *)documentPath;
// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
@property (nonatomic, strong, readonly) NSURL    *cachesDirectoryURL;
@property (nonatomic, strong, readonly) NSString *cachesPath;
+ (NSURL *)cachesURL;
+ (NSString *)cachesPath;
// 配置目录，配置文件存这里
@property (nonatomic, strong, readonly) NSURL    *libraryDirectoryURL;
@property (nonatomic, strong, readonly) NSString *libraryPath;
+ (NSURL *)libraryURL;
+ (NSString *)libraryPath;
// 缓存目录，APP退出后，系统可能会删除这里的内容
@property (nonatomic, strong, readonly) NSURL    *tempDirectoryURL;
@property (nonatomic, strong, readonly) NSString *tempPath;
+ (NSURL *)tempURL;
+ (NSString *)tempPath;
// 下载目录
@property (nonatomic, strong, readonly) NSURL    *downloadsDirectoryURL;
@property (nonatomic, strong, readonly) NSString *downloadsPath;
// 不常用
@property (nonatomic, strong, readonly) NSURL *applicationSupportDirectoryURL;

@end
