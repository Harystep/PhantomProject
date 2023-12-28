//
//  AGCircleMemberHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "AGCircleMemberHttp.h"

@implementation AGCircleMemberHttp

@end

/**
 * AGCircleMemberOthersHttp
 */
@implementation AGCircleMemberOthersHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"memberId": [NSString stringSafeChecking:self.memberId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?memberId=%@", AG_CICLE_MEMBER_OTHERS_URLAPI, [NSString stringSafeChecking:self.memberId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberOthersDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleMemberOthersData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleMemberFollowHttp
 */
@implementation AGCircleMemberFollowHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"memberId": [NSString stringSafeChecking:self.memberId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?memberId=%@", AG_CICLE_MEMBER_FOLLOW_URLAPI, [NSString stringSafeChecking:self.memberId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
 * AGCircleMemberUnFollowHttp
 */
@implementation AGCircleMemberUnFollowHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"memberId": [NSString stringSafeChecking:self.memberId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?memberId=%@", AG_CICLE_MEMBER_UNFOLLOW_URLAPI, [NSString stringSafeChecking:self.memberId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberUnFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
 * AGCircleMemberFansHttp
 */
@implementation AGCircleMemberFansHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_MEMBER_FANS_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberFansDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleMemberFansListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleMemberAttentionHttp
 */
@implementation AGCircleMemberAttentionHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_MEMBER_ATTENTION_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberAttentionDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleMemberAttentionListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleMemberBlackUserHttp
 */
@implementation AGCircleMemberBlackUserHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?memberId=%@", AG_CICLE_MEMBER_BLACKUSER_URLAPI, [NSString stringSafeChecking:self.memberId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestCircleMemberBlackUserDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
