//
//  PathTools.m
//  Abner
//
//  Created by Abner on 15/3/13.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import "PathTools.h"

@implementation PathTools

#pragma mark - Background image
+ (NSString *)getBgImageFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imageCacheFolder = @"BgImageCache";
    NSString *imageCachePath = [[paths lastObject] stringByAppendingPathComponent:imageCacheFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:imageCachePath]){
        [fileManager createDirectoryAtPath:imageCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imageCachePath;
}

+ (NSString *)getBgImagePathIsDetail:(BOOL)isDetail{
    NSString *bgImagePathStr = [self getBgImageFolder];
    if(bgImagePathStr && ![bgImagePathStr isEqualToString:@""]){
        if(isDetail){
            bgImagePathStr = [bgImagePathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kDetailBackgroundImageName, @"png"]];
        }
        else {
            bgImagePathStr = [bgImagePathStr stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", kBackgroundImageName, @"png"]];
        }
        
        return bgImagePathStr;
    }
    
    return nil;
}

#pragma mark - DataCache
+ (NSString *)getDataCacheFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *dataCacheFolder =  @"datacache";
    NSString *hostname = [NSURL URLWithString:[HelpTools sharedAppSingleton].baseUrlString].host;
    if([NSString isNotEmptyAndValid:hostname]){
        
        dataCacheFolder = [NSString stringWithFormat:@"datacache@%@", hostname];
    }
    
    NSString *dataCachePath = [[paths lastObject] stringByAppendingPathComponent:dataCacheFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dataCachePath]){
        [fileManager createDirectoryAtPath:dataCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return dataCachePath;
}

+ (NSString *)getDataCacheFolderWithUserMobilePhone{
    NSString *cacheFilePath = [self getDataCacheFolder];
    NSString *mobilePhoneNum = [HelpTools getUserMobilePhomeNumber];
    if([NSObject isNotEmptyAndValid:mobilePhoneNum]){
        return cacheFilePath;
    }
    
    if([NSObject isNotEmptyAndValid:mobilePhoneNum]){
        NSString *singleUserCacheFilePath = [cacheFilePath stringByAppendingPathComponent:mobilePhoneNum];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:singleUserCacheFilePath]){
            [fileManager createDirectoryAtPath:singleUserCacheFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        return singleUserCacheFilePath;
    }
    
    return nil;
}

@end
