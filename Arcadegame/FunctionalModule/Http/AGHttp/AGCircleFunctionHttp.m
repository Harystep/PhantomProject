//
//  AGCircleFunctionHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGCircleFunctionHttp.h"

@implementation AGCircleFunctionHttp

@end

/**
 * AGCircleFollowHttp
 */
@implementation AGCircleFollowHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"groupId": [NSString stringSafeChecking:self.groupId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?groupId=%@", AG_CICLE_FOLLOW_URLAPI, [NSString stringSafeChecking:self.groupId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
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
 * AGCircleUnFollowHttp
 */
@implementation AGCircleUnFollowHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"groupId": [NSString stringSafeChecking:self.groupId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?groupId=%@", AG_CICLE_UNFOLLOW_URLAPI, [NSString stringSafeChecking:self.groupId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleUnFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
 * AGCircleLikeHttp
 */
@implementation AGCircleLikeHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"dynamicId": [NSString stringSafeChecking:self.dynamicId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?dynamicId=%@", AG_CICLE_LIKE_URLAPI, [NSString stringSafeChecking:self.dynamicId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleLikeDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
 * AGCircleREPORTHttp
 */
@implementation AGCircleREPORTHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"dynamicId": [NSString stringSafeChecking:self.dynamicId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?dynamicId=%@&content=%@", AG_CICLE_REPORT_URLAPI, [NSString stringSafeChecking:self.dynamicId], [NSString stringSafeChecking:self.content]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleAGCircleREPORTHttpDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
