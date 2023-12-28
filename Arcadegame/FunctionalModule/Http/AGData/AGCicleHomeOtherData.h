//
//  AGCicleHomeOtherData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/22.
//

#import "AGBaseData.h"
#import "AGCicleHomeRecommendData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCicleHomeOtherDtoData;
@class AGCicleHomeOtherData;

@interface AGCicleHomeOtherListData : AGBaseData

@property (strong, nonatomic) AGCicleHomeOtherData *data;

@end

/**
 * AGCicleHomeOtherData
 */
@interface AGCicleHomeOtherData : NSObject

@property (strong, nonatomic) NSArray<AGCicleHomeOtherDtoData *> *groupDtoList;
@property (strong, nonatomic) NSArray<AGCicleHomeRGroupDynamicData *> *groupDynamicList;

@end

/**
 * AGCicleHomeOtherDtoData
 */
@interface AGCicleHomeOtherDtoData : NSObject

@property (strong, nonatomic) NSString *bgImage;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *coverImage;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSArray *followImages;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *postNum;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *updateTime;
@property (strong, nonatomic) NSString *userNum;
@property (assign, nonatomic) NSInteger hasFocus;

@end

NS_ASSUME_NONNULL_END
