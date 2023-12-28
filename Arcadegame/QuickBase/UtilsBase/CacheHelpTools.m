//
//  CacheHelpTools.m
//  Abner
//
//  Created by Abner on 15/3/20.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import "CacheHelpTools.h"

NSString *NSStringFromCacheTypeName(CacheTypeName typeName){
    ENUM_BEGIN
    ENUM_CASE(Cache_LoginEntity)
    ENUM_CASE(Cache_ExtendTarget)
    ENUM_CASE(Cache_ArList)
    ENUM_CASE(Cache_OAuthLogin)
    ENUM_CASE(Cache_EveryDayTarget)
    ENUM_CASE(Cache_QueueTarget)
    ENUM_CASE(Cache_UserInfo)
    ENUM_END
}

@implementation CacheHelpTools

+ (void)saveCacheFile:(CacheTypeName)typeName withFile:(id)fileData result:(void(^)(BOOL isSuccess))resultHandle{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolderWithUserMobilePhone];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    
    [self save:typeName withFile:fileData withPath:cacheFilePath result:resultHandle];
}

+ (void)saveCommonCacheFile:(CacheTypeName)typeName withFile:(id)fileData result:(void(^)(BOOL isSuccess))resultHandle{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    
    [self save:typeName withFile:fileData withPath:cacheFilePath result:resultHandle];
}

+ (void)save:(CacheTypeName)typeName withFile:(id)fileData withPath:(NSString *)filePath result:(void(^)(BOOL isSuccess))resultHandle{
    
    NSMutableData *cacheData = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cacheData];
    [archiver encodeObject:fileData forKey:NSStringFromCacheTypeName(typeName)];
    [archiver finishEncoding];
    
    BOOL isSuccess = NO;
    if(filePath){
        isSuccess = [cacheData writeToFile:filePath atomically:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(resultHandle){
            resultHandle(isSuccess);
        }
    });
    
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableData *cacheData = [NSMutableData data];
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:cacheData];
        [archiver encodeObject:fileData forKey:NSStringFromCacheTypeName(typeName)];
        [archiver finishEncoding];
        
        BOOL isSuccess = NO;
        if(filePath){
            isSuccess = [cacheData writeToFile:filePath atomically:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(resultHandle){
                resultHandle(isSuccess);
            }
        });
    });
     */
}

+ (void)saveCommonCacheFile:(CacheTypeName)typeName
            dynamicFileName:(NSString *)fileName
                   withFile:(id)fileData
                     result:(void(^)(BOOL isSuccess))resultHandle{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    cacheFilePath = [cacheFilePath stringByAppendingString:[NSString stringWithFormat:@"_%@", fileName]];
    
    [self save:typeName withFile:fileData withPath:cacheFilePath result:resultHandle];
}

+ (void)saveCommonCacheFileWithFileName:(NSString *)filename
                              cacheType:(CacheTypeName)typeName
                               withFile:(id)fileData
                                 result:(void(^)(BOOL isSuccess))resultHandle{
   
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:filename];
 
    [self save:typeName withFile:fileData withPath:cacheFilePath result:resultHandle];
}
//-------------------------------------------------------------------------------
+ (id)getCacheFile:(CacheTypeName)typeName{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolderWithUserMobilePhone];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    
    return [self get:typeName withPath:cacheFilePath];
}

+ (id)getCommonCacheFile:(CacheTypeName)typeName{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    
    return [self get:typeName withPath:cacheFilePath];
}

+ (id)get:(CacheTypeName)typeName withPath:(NSString *)filePath{
    if(!filePath) return nil;
    
    NSData *archiverData = [[NSData alloc] initWithContentsOfFile:filePath];
    if(!archiverData){
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archiverData];
    
    id entityData = [unarchiver decodeObjectForKey:NSStringFromCacheTypeName(typeName)];
    [unarchiver finishDecoding];
    
    return entityData;
}

+ (id)getCommonCacheFile:(CacheTypeName)typeName dynamicFileName:(NSString *)fileName{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    cacheFilePath = [cacheFilePath stringByAppendingString:[NSString stringWithFormat:@"_%@", fileName]];
    
    return [self get:typeName withPath:cacheFilePath];
}

+ (id)getCommonCacheFileWithFileName:(NSString *)filename cacheType:(CacheTypeName)typeName{
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:filename];
    
    return [self get:typeName withPath:cacheFilePath];
}

+ (BOOL)removeCommonCacheFile:(CacheTypeName)typeName {
    
    NSString *cacheFolderPath = [PathTools getDataCacheFolder];
    NSString *cacheFilePath = [cacheFolderPath stringByAppendingPathComponent:NSStringFromCacheTypeName(typeName)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:cacheFilePath]) {
        
        NSError *error;
        [fileManager removeItemAtPath:cacheFilePath error:&error];
        
        if(error) {
            
            NSLog(@"removeCommonCacheFile error:%@", error);
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

@end
