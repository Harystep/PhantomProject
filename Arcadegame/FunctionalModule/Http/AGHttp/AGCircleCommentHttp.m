//
//  AGCircleCommentHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGCircleCommentHttp.h"

@implementation AGCircleCommentHttp

@end

/**
 * AGCircleCommentListHttp
 */
@implementation AGCircleCommentListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"dynamicId": [NSString stringSafeChecking:self.dynamicId]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?dynamicId=%@", AG_CICLE_COMMENT_LIST_URLAPI, [NSString stringSafeChecking:self.dynamicId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleCommentListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGCircleCommentListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGCircleCommentUpHttp
 */
@implementation AGCircleCommentUpHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    
    NSDictionary *paramDic = @{@"dynamicId": [NSString stringSafeChecking:self.dynamicId],
                               @"content": [NSString stringSafeChecking:self.content]};
    
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?dynamicId=%@&content=%@", AG_CICLE_COMMENT_UP_URLAPI, [NSString stringSafeChecking:self.dynamicId], [NSString stringSafeChecking:self.content]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return true;
}

- (void)requestCircleCommentUpDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
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
