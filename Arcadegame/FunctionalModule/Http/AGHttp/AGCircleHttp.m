//
//  AGCircleHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/21.
//

#import "AGCircleHttp.h"

@implementation AGCircleHttp

@end

/**
 * AGCircleHotListHttp
 */
@implementation AGCircleHotListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_HOTLIST_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleHotListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleHotListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleListHttp
 */
@implementation AGCircleListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{@"categoryId": [NSString stringSafeChecking:self.categoryId],
                               @"keyword": [NSString stringSafeChecking:self.keyword]};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_LIST_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleFollowListHttp
 */
@implementation AGCircleFollowListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_LIST_FOLLOW_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleFollowListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleFollowLastListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleLaterListHttp
 */
@implementation AGCircleLaterListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{};
    
    if([NSString isNotEmptyAndValid:self.groupId]) {
        
        paramDic = @{@"groupId": self.groupId};
    }
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_LIST_LATER_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleLaterListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleFollowLastListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleDetailHttp
 */
@implementation AGCircleDetailHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"dynamicId": [NSString stringSafeChecking:self.dynamicId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?dynamicId=%@", AG_CICLE_DETAIL_URLAPI, [NSString stringSafeChecking:self.dynamicId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleDetailDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleDetailContainerData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleDetailHttp
 */
@implementation AGCirclePublishHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"groupId": [NSString stringSafeChecking:self.groupId],
                               @"content": [NSString stringSafeChecking:self.content],
                               @"discuss": [NSString stringSafeChecking:self.discuss],
                               @"images": [NSString stringSafeChecking:self.images]
    };
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    
    return [NSString stringWithFormat:@"%@?groupId=%@&content=%@&discuss=%@&images=%@", AG_CICLE_PUBLISH_URLAPI, [NSString stringSafeChecking:self.groupId], [NSString stringSafeChecking:self.content], [NSString stringSafeChecking:self.discuss], [NSString stringSafeChecking:self.images]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCirclePublishDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [NSData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleGroupFllowHttp
 */
@implementation AGCircleGroupFllowHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    
    return [NSString stringWithFormat:@"%@", AG_CICLE_GROUPFOLLOW_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleGroupFllowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleGroupFollowListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
