//
//  AGMemberHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/28.
//

#import "AGMemberHttp.h"

@implementation AGMemberHttp

@end

/**
 * AGMemberLoginAppleHttp
 */
@implementation AGMemberLoginAppleHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    
    return [NSString stringWithFormat:@"%@?identityToken=%@", AG_MEMBER_LOGIN_APPLE_URLAPI, self.identityToken];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberLoginAppleHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGUserData mj_objectWithKeyValues:responseObject[@"data"]];
            [HelpTools saveUserData:self.mBase];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberLoginPhoneNumHttp
 */
@implementation AGMemberLoginPhoneNumHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    NSString *phoneSign = [HelpTools md5:[NSString stringWithFormat:@"%@@@%@", self.phoneNum, self.phoneNum]];
    
    return [NSString stringWithFormat:@"%@?mobile=%@&sign=%@", AG_MEMBER_LOGIN_PHONENUM_URLAPI, self.phoneNum, phoneSign];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberLoginPhoneNumHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGUserData mj_objectWithKeyValues:responseObject[@"data"]];
            [HelpTools saveUserData:self.mBase];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberLoginAliYunHttp
 */
@implementation AGMemberLoginAliYunHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{@"loginToken": [NSString stringSafeChecking:self.loginToken]};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?loginToken=%@", AG_MEMBER_LOGIN_ALIYUN_URLAPI, [NSString stringSafeChecking:self.loginToken]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberLoginAliYunResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGMemberLoginAliYunData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberUserInfoHttp
 */
@implementation AGMemberUserInfoHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_MEMBER_USERINFO_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberUserInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGMemberUserInfoData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberSignHttp
 */
@implementation AGMemberSignHttp

@end

/**
 * AGMemberInviteConfirmHttp
 */
@implementation AGMemberInviteConfirmHttp

@end

/**
 * AGMemberInviteInfoHttp
 */
@implementation AGMemberInviteInfoHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_MEMBER_INVITEINFO_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberInviteInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGMemberInviteInfoDataData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberMemberDeleteHttp
 */
@implementation AGMemberMemberDeleteHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_MEMBER_DELETE_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberMemberDeleteResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
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
 * AGMemberUserInfoEditHttp
 */
@implementation AGMemberUserInfoEditHttp

- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    
    return [NSString stringWithFormat:@"%@?accessToken=%@&nickname=%@&avatar=%@", AG_MEMBER_USERINFOEDIT_URLAPI, [HelpTools userDataForToken], self.nickName, self.avatar];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberUserInfoEditResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [NSData mj_objectWithKeyValues:responseObject[@"data"]];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberMyCircleHttp
 */
@implementation AGMemberMyCircleHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CIRCLE_MYCIRCLE_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberMyCircleResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGMemberMyCircleListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGUserInfoHttp
 */
@implementation AGUserInfoHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_USER_INFO_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestUserInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGGlobalUserInfoData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGMemberRewardHttp
 */
@implementation AGMemberRewardHttp

- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    
    return [NSString stringWithFormat:@"%@?accessToken=%@&memberId=%@&diamondNum=%@", AG_MEMBER_REWARD_URLAPI, [HelpTools userDataForToken], self.memberId, self.diamondNum];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestMemberRewardResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle {
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGBaseData mj_objectWithKeyValues:responseObject[@"data"]];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
