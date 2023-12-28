//
//  AGCircleMemberData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "AGCircleMemberData.h"

@implementation AGCircleMemberData

@end

/**
 * AGCircleMemberOthersData
 */
@implementation AGCircleMemberOthersData

@end

/**
 * AGCircleMemberOtherData
 */
@implementation AGCircleMemberOtherData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"groupList":@"AGCircleMemberOtherGroupData",
             @"groupDynamics":@"AGCircleMemberOtherGroupDynamicsData"};
}

@end

/**
 * AGCircleMemberOtherData
 */
@implementation AGCircleMemberOtherMemberData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCircleMemberOtherGroupData
 */
@implementation AGCircleMemberOtherGroupData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id",
             @"Description": @"description"};
}

@end

/**
 * AGCircleMemberOtherGroupDynamicsData
 */
@implementation AGCircleMemberOtherGroupDynamicsData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCircleMemberFansListData
 */
@implementation AGCircleMemberFansListData

@end

/**
 * AGCircleMemberFansListListData
 */
@implementation AGCircleMemberFansListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleMemberFansData"};
}

@end

/**
 * AGCircleMemberFansData
 */
@implementation AGCircleMemberFansData

@end

/**
 * AGCircleMemberAttentionListData
 */
@implementation AGCircleMemberAttentionListData

@end

/**
 * AGCircleMemberAttentionListListData
 */
@implementation AGCircleMemberAttentionListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleMemberAttentionData"};
}

@end

/**
 * AGCircleMemberAttentionData
 */
@implementation AGCircleMemberAttentionData

@end
