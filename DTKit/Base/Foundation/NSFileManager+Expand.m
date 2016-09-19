//
//  NSFileManager+Expand.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "NSFileManager+Expand.h"

@implementation NSFileManager (Expand)

#pragma mark -
+ (BOOL)createFolder:(NSString *)folder atPath:(NSString *)path
{
    NSString *savePath = path;
    if (folder) {
        savePath = [path stringByAppendingPathComponent:folder];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL exist = [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
    NSError *error = nil;
    if (!exist || !isDirectory)
    {
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return [fileManager fileExistsAtPath:savePath isDirectory:&isDirectory];
}

+ (BOOL)createFolder:(NSString *)path
{
    return [self createFolder:nil atPath:path];
}

+ (BOOL)saveData:(NSData *)data withName:(NSString *)name atPath:(NSString *)path
{
    if (data && name && path)
    {
        NSString *filePath = [path stringByAppendingPathComponent:name];
        return [data writeToFile:filePath atomically:YES];
    }
    
    return NO;
}

+ (NSData *)findFile:(NSString *)fileName atPath:(NSString *)path
{
    NSData *data = nil;
    if (fileName && path)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:filePath])
        {
            data = [NSData dataWithContentsOfFile:filePath];
        }
    }
    
    return data;
}

+ (BOOL)deleteFile:(NSString *)fileName atPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    return success;
}

+ (BOOL)deleteFilePath:(NSString *)path
{
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

#pragma mark - documents
- (NSURL *)documentsDirectoryURL {
    return [[self URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)documentPath
{
    return self.documentsDirectoryURL.path;
}

+ (NSURL *)documentURL
{
    return [[self defaultManager] documentsDirectoryURL];
}

+ (NSString *)documentPath
{
    return [[self defaultManager] documentPath];
}

#pragma mark - caches
- (NSURL *)cachesDirectoryURL {
    return [[self URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)cachesPath {
    return self.cachesDirectoryURL.path;
}

+ (NSURL *)cachesURL
{
    return [[self defaultManager] cachesDirectoryURL];
}

+ (NSString *)cachesPath
{
    return [[self defaultManager] cachesPath];
}

#pragma mark -
- (NSURL *)downloadsDirectoryURL {
    return [[self URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)downloadsPath {
    return self.downloadsDirectoryURL.path;
}

#pragma mark - library
- (NSURL *)libraryDirectoryURL {
    return [[self URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)libraryPath {
    return self.libraryDirectoryURL.path;
}

+ (NSURL *)libraryURL
{
    return [[self defaultManager] libraryDirectoryURL];
}

+ (NSString *)libraryPath
{
    return [[self defaultManager] libraryPath];
}

#pragma mark - temp
- (NSURL *)tempDirectoryURL {
    return [NSURL fileURLWithPath:self.tempPath];
}

- (NSString *)tempPath {
    return [self.libraryPath stringByAppendingPathComponent:@"tmp"];
}

+ (NSURL *)tempURL
{
    return [[self defaultManager] tempDirectoryURL];
}

+ (NSString *)tempPath
{
    return [[self defaultManager] tempPath];
}

#pragma mark -
- (NSURL *)applicationSupportDirectoryURL {
    return [[self URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
