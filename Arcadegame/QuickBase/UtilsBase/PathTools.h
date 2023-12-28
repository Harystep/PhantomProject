//
//  PathTools.h
//  Abner
//
//  Created by Abner on 15/3/13.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathTools : NSObject

/**
 *  获取背景缓存路径
 */
+ (NSString *)getBgImagePathIsDetail:(BOOL)isDetail;

/**
 *  获取数据缓存
 */
+ (NSString *)getDataCacheFolder;

/**
 *  根据每一个用户区分缓存路径;如果尚未登陆 则返回CommonCacheFolder
 */
+ (NSString *)getDataCacheFolderWithUserMobilePhone;

@end
