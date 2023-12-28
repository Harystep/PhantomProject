//
//  AGCicleHomeRecommendData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGCicleHomeRecommendData.h"

@implementation AGCicleHomeRecommendListData

@end

/**
 * AGCicleHomeRecommendData
 */
@implementation AGCicleHomeRecommendData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"arcadeList":@"AGCicleHomeRArcadeData",
             @"bannerDtos":@"AGCicleHomeRBannerData",
             @"bannerDtos2":@"AGCicleHomeRBannerData",
             @"categoryList":@"AGCicleHomeRCategoryData",
             @"groupDynamicList":@"AGCicleHomeRGroupDynamicData",
             @"segaList":@"AGCicleHomeRSegaData",
    };
}

@end

/**
 * AGCicleHomeRArcadeData
 */
@implementation AGCicleHomeRArcadeData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCicleHomeRBannerData
 */
@implementation AGCicleHomeRBannerData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCicleHomeRCategoryData
 */
@implementation AGCicleHomeRCategoryData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCicleHomeRGroupDynamicData
 */
@implementation AGCicleHomeRGroupDynamicData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCicleHomeRSegaData
 */
@implementation AGCicleHomeRSegaData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end
