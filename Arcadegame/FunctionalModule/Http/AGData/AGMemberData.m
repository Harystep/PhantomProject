//
//  AGMemberData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/28.
//

#import "AGMemberData.h"

@implementation AGMemberData

@end

/**
 * AGMemberUserInfoData
 */
@implementation AGMemberUserInfoData

@end

/**
 * AGUserInfoData
 */
@implementation AGUserInfoData

@end

/**
 * AGUserMember
 */
@implementation AGUserMember

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 *  AGMemberLoginAliYunData
 */
@implementation AGMemberLoginAliYunData

@end

/**
 *  AGMemberMyCircleListData
 */
@implementation AGMemberMyCircleListData

@end

/**
 *  AGMemberMyCircleListListData
 */
@implementation AGMemberMyCircleListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGMemberMyCircleData"};
}

@end

/**
 *  AGMemberMyCircleData
 */
@implementation AGMemberMyCircleData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 *  AGMemberMyCircleMemberBaseDto
 */
@implementation AGMemberMyCircleMemberBaseDto

@end

/**
 *  AGMemberInviteInfoDataData
 */
@implementation AGMemberInviteInfoDataData

@end

/**
 *  AGMemberInviteInfoData
 */
@implementation AGMemberInviteInfoData

@end

/**
 *  AGGlobalUserInfoData
 */
@implementation AGGlobalUserInfoData

@end

/**
 *  AGGlobalUserInfoInfoData
 */
@implementation AGGlobalUserInfoInfoData

@end

/**
 *  AGGlobalUserInfoLevelDtoData
 */
@implementation AGGlobalUserInfoLevelDtoData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

