//
//  AGCicleHomeRecommendHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/14.
//

#import "AGCicleHomeRecommendHttp.h"

@implementation AGCicleHomeRecommendHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_HOMEREC_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestHomeRecommendDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCicleHomeRecommendListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCicleHomeClassifyHttp
 */
@implementation AGCicleHomeClassifyHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_HOME_CLASSIFY_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestHomeClassifyDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGHomeClassifyListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
