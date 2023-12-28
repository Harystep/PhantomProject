//
//  AGCicleHomeOtherHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/21.
//

#import "AGCicleHomeOtherHttp.h"

@implementation AGCicleHomeOtherHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{@"categoryId": [NSString stringSafeChecking:self.categoryId]};
    //手游2 电竞3 桌游4 网游5 街机1
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CICLE_HOMEOTHER_URLAPI];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestHomeOtherDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCicleHomeOtherListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
