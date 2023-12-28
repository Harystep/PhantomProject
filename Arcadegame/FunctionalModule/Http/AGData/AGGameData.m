//
//  AGGameData.m
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "AGGameData.h"

@implementation AGGameData

@end

/**
 * AGGameRoomGroupListData
 */
@implementation AGGameRoomGroupListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGGameRoomGroupData"};
}

@end

/**
 * AGGameRoomGroupData
 */
@implementation AGGameRoomGroupData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"roomGroupList":@"AGGameRoomGroupSubListData"};
}

@end

/**
 * AGGameRoomGroupSubListData
 */
@implementation AGGameRoomGroupSubListData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGGameRoomListListData
 */
@implementation AGGameRoomListListData

@end

/**
 * AGGameRoomListData
 */
@implementation AGGameRoomListData

@end

/**
 * AGGameRoomData
 */
@implementation AGGameRoomData

@end

/**
 * AGGameRoonEnterData
 */
@implementation AGGameRoonEnterData

@end

/**
 * AGGameVideoData
 */
@implementation AGGameVideoData

@end
