//
//  AGCicleHomeOtherData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGCicleHomeOtherData.h"

@implementation AGCicleHomeOtherListData

@end

/**
 * AGCicleHomeOtherData
 */
@implementation AGCicleHomeOtherData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"groupDtoList":@"AGCicleHomeOtherDtoData",
             @"groupDynamicList":@"AGCicleHomeRGroupDynamicData",
    };
}

@end

/**
 * AGCicleHomeOtherDtoData
 */
@implementation AGCicleHomeOtherDtoData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Description": @"description",
             @"ID": @"id"};
}

@end
