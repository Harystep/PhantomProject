//
//  AGServiceHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/27.
//

#import "AGServiceHttp.h"

@implementation AGServiceHttp

@end

/**
 * AGServiceUploadImageHttp
 */
@implementation AGServiceUploadImageHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_SERVICE_UPLOADI_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestServiceUploadImageResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGServiceUploadImageData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

- (void)setFilePath:(NSString *)pathString{
    
    if(pathString && pathString.length) {
        
        [self.fileArray addObject:@{[NSString stringWithFormat:@"image"] : pathString}];
    }
}

@end

/**
 * AGServiceBannerHttp
 */
@implementation AGServiceBannerHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{@"position": @"3"};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_SERVICE_BANNER_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestServiceBannerResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGServiceBannerListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
