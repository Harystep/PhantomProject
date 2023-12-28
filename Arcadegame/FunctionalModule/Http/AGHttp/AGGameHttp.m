//
//  AGGameHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "AGGameHttp.h"

@implementation AGGameHttp

@end

/**
 * AGGameRoomGroupListHttp
 */
@implementation AGGameRoomGroupListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_GAME_ROOMGROUP_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestGameRoomGroupListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGGameRoomGroupListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGGameRoomListHttp
 */
@implementation AGGameRoomListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?categoryId=%@&groupId=%@", AG_GAME_LIST_URLAPI, [NSString stringSafeChecking:self.categoryId], [NSString stringSafeChecking:self.groupId]];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestGameRoomListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGGameRoomListListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGGameRoomEnterHttp
 */
@implementation AGGameRoomEnterHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?roomId=%@", AG_GAME_ROOMENTER_URLAPI, self.roomID];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestGameRoomEnterResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGGameRoonEnterData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGGameVideoHttp
 */
@implementation AGGameVideoHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?roomId=%@", AG_GAME_VIDEO, self.roomID];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestGameVideoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGGameVideoData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
