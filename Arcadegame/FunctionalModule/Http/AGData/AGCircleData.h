//
//  AGCircleData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import "AGBaseData.h"
#import "AGListBaseData.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleHotData;
@class AGCircleDetailData;
@class AGCircleFollowLastData;
@class AGCircleGroupFollowData;
@class AGCircleDetailGroupData;
@class AGCircleDetailMemberBaseData;
@class AGCircleFollowLastListListData;
@class AGCircleGroupFollowListListData;

@interface AGCircleData : AGBaseData

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

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData;

@end

/**
 * AGCircleHotListData
 */
@interface AGCircleHotListData : AGBaseData

@property (strong, nonatomic) NSArray<AGCircleHotData *> *data;

@end

/**
 * AGCircleHotData
 */
@interface AGCircleHotData : AGBaseData

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

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData;

@end

/**
 * AGCircleFollowLastListData
 */
@interface AGCircleFollowLastListData : AGBaseData

@property (strong, nonatomic) AGCircleFollowLastListListData *data;

@end

/**
 * AGCircleFollowLastListListData
 */
@interface AGCircleFollowLastListListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGCircleFollowLastData *> *data;

@end

/**
 * AGCircleFollowLastData
 */
@interface AGCircleFollowLastData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) AGCircleDetailMemberBaseData *memberBaseDto;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger hasFocus;
@property (strong, nonatomic) NSString *hasLike;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *show;
@property (strong, nonatomic) NSString *seeNum;
@property (strong, nonatomic) NSString *likeNum;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *discussList;

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData;

@end

/**
 * AGCircleDetailMemberBaseData
 */
@interface AGCircleDetailMemberBaseData : NSObject

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *levelName;

@end

/**
 * AGCircleDetailContainerData
 */
@interface AGCircleDetailContainerData : AGBaseData

@property (strong, nonatomic) AGCircleDetailData *data;

@end

/**
 * AGCircleDetailData
 */
@interface AGCircleDetailData : NSObject

@property (strong, nonatomic) AGCircleDetailGroupData *group;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) AGCircleDetailMemberBaseData *memberBaseDto;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int hasFocus;
@property (assign, nonatomic) int hasLike;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *show;
@property (strong, nonatomic) NSString *seeNum;
@property (strong, nonatomic) NSString *likeNum;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *dateStr;
@property (strong, nonatomic) NSString *discussList;

@end

/**
 * AGCircleDetailGroupData
 */
@interface AGCircleDetailGroupData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *coverImage;
@property (strong, nonatomic) NSString *bgImage;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *userNum;
@property (strong, nonatomic) NSString *postNum;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *updateTime;

@end

/**
 * AGCircleListData
 */
@interface AGCircleListData : AGBaseData

@property (strong, nonatomic) NSArray<AGCircleData *> *data;

@end

/**
 * AGCircleGroupFollowListData
 */
@interface AGCircleGroupFollowListData : AGListBaseData

@property (strong, nonatomic) AGCircleGroupFollowListListData *data;

@end

/**
 * AGCircleGroupFollowListListData
 */
@interface AGCircleGroupFollowListListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGCircleGroupFollowData *> *data;

@end

/**
 * AGCircleGroupFollowData
 */
@interface AGCircleGroupFollowData : AGBaseData

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *coverImage;
@property (strong, nonatomic) NSString *bgImage;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *userNum;
@property (strong, nonatomic) NSString *postNum;
@property (strong, nonatomic) NSString *flag;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *updateTime;

- (AGCicleHomeOtherDtoData *)changeToHomeOtherDtoData;

@end


NS_ASSUME_NONNULL_END
