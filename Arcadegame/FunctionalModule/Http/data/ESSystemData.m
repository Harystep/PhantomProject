//
//  ESSystemData.m
//  EShopClient
//
//  Created by Abner on 2019/7/16.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESSystemData.h"

@implementation ESSystemData

@end

/**
 ESSystemResonListData
 */
@implementation ESSystemResonListData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"list": @"data"};
}

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"list":@"ESSystemResonData"};
}

@end

/**
 ESSystemResonData
 */
@implementation ESSystemResonData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 ESSystemUPAppVersionData
 */
@implementation ESSystemUPAppVersionData

@end

/**
ESSystemAllLogisticsData
*/
@implementation ESSystemAllLogisticsData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"logistics":@"ESSystemLogisticsData"};
}

@end

@implementation ESSystemLogisticsData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end
