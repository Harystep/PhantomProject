//
//  CacheHelpTools.h
//  Abner
//
//  Created by Abner on 15/3/20.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  在.m中的 NSStringFromCacheTypeName 中注册；
 *  e.g.:ENUM_CASE(Cache_LoginEntity)
 */
typedef NS_ENUM(NSInteger, CacheTypeName){
    Cache_LoginEntity,      // 用户登陆数据
    Cache_ExtendTarget,     // 随机事件
    Cache_ArList,           // 识别点列表
    Cache_OAuthLogin,       // 登陆后用户的关键KEY
    Cache_EveryDayTarget,   // 日常事件
    Cache_QueueTarget,      // 序列事件
    Cache_UserInfo,
};


@interface CacheHelpTools : NSObject

/**
 *  Cache file for single user
 *
 *  @param typeName     Cache file type
 *  @param fileData     Data
 *  @param resultHandle Resule block
 */
+ (void)saveCacheFile:(CacheTypeName)typeName withFile:(id)fileData result:(void(^)(BOOL isSuccess))resultHandle;

/**
 *  Cache file for CacheFolder
 *
 *  @param typeName     idem
 *  @param fileData     idem
 *  @param resultHandle idem
 */
+ (void)saveCommonCacheFile:(CacheTypeName)typeName withFile:(id)fileData result:(void(^)(BOOL isSuccess))resultHandle;

/**
 *  Cache file with dynamic name for CacheFolder
 *
 *  @param typeName     idem
 *  @param fileName     dynamic filename
 *  @param fileData     idem
 *  @param resultHandle idem
 */
+ (void)saveCommonCacheFile:(CacheTypeName)typeName
            dynamicFileName:(NSString *)fileName
                   withFile:(id)fileData
                     result:(void(^)(BOOL isSuccess))resultHandle;

/**
 *  Save file with filename for CacheFolder
 *
 *  @param filename     idem
 *  @param typeName     idem
 *  @param fileData     idem
 *  @param resultHandle idem
 */
+ (void)saveCommonCacheFileWithFileName:(NSString *)filename
                              cacheType:(CacheTypeName)typeName
                               withFile:(id)fileData
                                 result:(void(^)(BOOL isSuccess))resultHandle;
//-------------------------------------------------------------------------------

/**
 *  Get file for single user
 *
 *  @param typeName     Cache file type
 *  @param resultHandle Resule block
 */
+ (id)getCacheFile:(CacheTypeName)typeName;

/**
 *  Get file for CacheFolder
 *
 *  @param typeName     Cache file type
 *  @param resultHandle Resule block
 */
+ (id)getCommonCacheFile:(CacheTypeName)typeName;

/**
 *  Get file with dynamic name for CacheFolder
 *
 *  @param typeName dynamic filename
 *  @param fileName idem
 *
 *  @return Result
 */
+ (id)getCommonCacheFile:(CacheTypeName)typeName dynamicFileName:(NSString *)fileName;

/**
 *  Get file with filename for CacheFolder
 *
 *  @param filename filename
 *
 *  @return idem
 */
+ (id)getCommonCacheFileWithFileName:(NSString *)filename cacheType:(CacheTypeName)typeName;

//-------------------------------------------------------------------------------

/**
 *  remove file for CacheFolder
 *
 *  @param typeName     Cache file type
 */
+ (BOOL)removeCommonCacheFile:(CacheTypeName)typeName;

@end
