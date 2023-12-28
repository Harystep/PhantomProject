//
//  AGCircleData.m
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import "AGCircleData.h"

@implementation AGCircleData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id",
             @"Description": @"description"};
}

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData {
    
    AGCicleHomeOtherDtoData *choDtoData = [AGCicleHomeOtherDtoData new];
    
    choDtoData.bgImage = self.bgImage;
    choDtoData.categoryId = self.categoryId;
    choDtoData.coverImage = self.coverImage;
    choDtoData.createTime = self.createTime;
    choDtoData.Description = self.Description;
    choDtoData.flag = self.flag;
    choDtoData.followImages = self.followImages;
    choDtoData.ID = self.ID;
    choDtoData.name = self.name;
    choDtoData.postNum = self.postNum;
    choDtoData.sort = self.sort;
    choDtoData.status = self.status;
    choDtoData.updateTime = self.updateTime;
    choDtoData.userNum = self.userNum;
    choDtoData.hasFocus = 0;
    
    return choDtoData;
}

@end

/**
 * AGCircleHotListData
 */
@implementation AGCircleHotListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleHotData"};
}

@end

/**
 * AGCircleHotData
 */
@implementation AGCircleHotData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id",
             @"Description": @"description"};
}

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData {
    
    AGCicleHomeOtherDtoData *choDtoData = [AGCicleHomeOtherDtoData new];
    
    choDtoData.bgImage = self.bgImage;
    choDtoData.categoryId = self.categoryId;
    choDtoData.coverImage = self.coverImage;
    choDtoData.createTime = self.createTime;
    choDtoData.Description = self.Description;
    choDtoData.flag = self.flag;
    choDtoData.followImages = self.followImages;
    choDtoData.ID = self.ID;
    choDtoData.name = self.name;
    choDtoData.postNum = self.postNum;
    choDtoData.sort = self.sort;
    choDtoData.status = self.status;
    choDtoData.updateTime = self.updateTime;
    choDtoData.userNum = self.userNum;
    
    return choDtoData;
}

@end

/**
 * AGCircleFollowLastListData
 */
@implementation AGCircleFollowLastListData

@end

/**
 * AGCircleFollowLastListListData
 */
@implementation AGCircleFollowLastListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleFollowLastData"};
}

@end

/**
 * AGCircleFollowLastData
 */
@implementation AGCircleFollowLastData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData {
    
    AGCicleHomeOtherDtoData *choDtoData = [AGCicleHomeOtherDtoData new];
    
    NSArray *medias = [self.media componentsSeparatedByString:@";"];
    
    choDtoData.bgImage = @"";
    choDtoData.categoryId = self.memberId;
    choDtoData.coverImage = medias.count ? medias.firstObject : @"";
    choDtoData.createTime = self.createTime;
    choDtoData.Description = self.content;
    choDtoData.flag = @"";
    choDtoData.followImages = @[];
    choDtoData.ID = self.ID;
    choDtoData.name = self.title;
    choDtoData.postNum = @"";
    choDtoData.sort = self.sort;
    choDtoData.status = self.status;
    choDtoData.updateTime = self.createTime;
    choDtoData.userNum = @"";
    choDtoData.hasFocus = self.hasFocus;
    
    return choDtoData;
}

@end

/**
 * AGCircleDetailMemberBaseData
 */
@implementation AGCircleDetailMemberBaseData

@end

/**
 * AGCircleDetailContainerData
 */
@implementation AGCircleDetailContainerData

@end

/**
 * AGCircleDetailData
 */
@implementation AGCircleDetailData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGCircleDetailGroupData
 */
@implementation AGCircleDetailGroupData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id",
             @"Description": @"description"};
}

@end

/**
 * AGCircleListData
 */
@implementation AGCircleListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleData"};
}

@end

/**
 * AGCircleGroupFollowListData
 */
@implementation AGCircleGroupFollowListData

@end

/**
 * AGCircleGroupFollowListListData
 */
@implementation AGCircleGroupFollowListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"AGCircleGroupFollowData"};
}

@end

/**
 * AGCircleGroupFollowData
 */
@implementation AGCircleGroupFollowData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id",
             @"Description": @"description"};
}

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData {
    
    AGCicleHomeOtherDtoData *choDtoData = [AGCicleHomeOtherDtoData new];
    
    choDtoData.bgImage = self.bgImage;
    choDtoData.categoryId = self.categoryId;
    choDtoData.coverImage = self.coverImage;
    choDtoData.createTime = self.createTime;
    choDtoData.Description = self.Description;
    choDtoData.flag = self.flag;
    choDtoData.ID = self.ID;
    choDtoData.name = self.name;
    choDtoData.postNum = self.postNum;
    choDtoData.sort = self.sort;
    choDtoData.status = self.status;
    choDtoData.updateTime = self.updateTime;
    choDtoData.userNum = self.userNum;
    
    return choDtoData;
}

@end
