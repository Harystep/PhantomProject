//
//  AGCicleHomeRecommendData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCicleHomeRecommendData;

@interface AGCicleHomeRecommendListData : AGBaseData

@property (strong, nonatomic) AGCicleHomeRecommendData *data;

@end

/**
 * AGCicleHomeRecommendData
 */
@interface AGCicleHomeRecommendData : NSObject

@property (strong, nonatomic) NSArray *arcadeList;
@property (strong, nonatomic) NSArray *bannerDtos;
@property (strong, nonatomic) NSArray *bannerDtos2;
@property (strong, nonatomic) NSArray *categoryList;
@property (strong, nonatomic) NSArray *groupDynamicList;
@property (strong, nonatomic) NSArray *segaList;

@end

/**
 * AGCicleHomeRArcadeData
 */
@interface AGCicleHomeRArcadeData : NSObject

@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *costType;
@property (strong, nonatomic) NSString *machineId;
@property (strong, nonatomic) NSString *machineSn;
@property (strong, nonatomic) NSString *machineType;
@property (strong, nonatomic) NSString *minGold;
@property (strong, nonatomic) NSString *minLevel;
@property (strong, nonatomic) NSString *multiple;
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *roomImg;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *homeImg;

@end

/**
 * AGCicleHomeRBannerData
 */
@interface AGCicleHomeRBannerData : NSObject

@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;

@end

/**
 * AGCicleHomeRCategoryData
 */
@interface AGCicleHomeRCategoryData : NSObject

@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *updateTime;

@end

/**
 * AGCicleHomeRGroupDynamicData
 */
@interface AGCicleHomeRGroupDynamicData : NSObject

@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *discussList;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *likeNum;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *recommend;
@property (strong, nonatomic) NSString *seeNum;
@property (strong, nonatomic) NSString *show;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *updateTime;

@end

/**
 * AGCicleHomeRSegaData
 */
@interface AGCicleHomeRSegaData : NSObject

@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *costType;
@property (strong, nonatomic) NSString *machineId;
@property (strong, nonatomic) NSString *machineSn;
@property (strong, nonatomic) NSString *machineType;
@property (strong, nonatomic) NSString *minGold;
@property (strong, nonatomic) NSString *minLevel;
@property (strong, nonatomic) NSString *multiple;
@property (strong, nonatomic) NSString *roomId;
@property (strong, nonatomic) NSString *roomImg;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *homeImg;

@end

NS_ASSUME_NONNULL_END
