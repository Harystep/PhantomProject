//
//  AGCircleCommentData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGCircleCommentData.h"

@implementation AGCircleCommentData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCircleCommentListData
 */
@implementation AGCircleCommentListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleCommentData"};
}

@end

/**
 * AGCircleCommentMemberBaseDtoData
 */
@implementation AGCircleCommentMemberBaseDtoData

@end
