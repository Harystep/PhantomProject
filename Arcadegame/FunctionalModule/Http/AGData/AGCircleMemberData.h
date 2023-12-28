//
//  AGCircleMemberData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "AGBaseData.h"
#import "AGListBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleMemberOtherData;
@class AGCircleMemberOtherGroupData;
@class AGCircleMemberOtherMemberData;
@class AGCircleMemberOtherGroupDynamicsData;
@class AGCircleMemberAttentionListListData;
@class AGCircleMemberFansListListData;
@class AGCircleMemberAttentionData;
@class AGCircleMemberFansData;

@interface AGCircleMemberData : AGBaseData

@end

/**
 * AGCircleMemberOthersData
 */
@interface AGCircleMemberOthersData : AGBaseData

@property (strong, nonatomic) AGCircleMemberOtherData *data;

@end

/**
 * AGCircleMemberOtherData
 */
@interface AGCircleMemberOtherData : NSObject

@property (assign, nonatomic) int attention;
@property (strong, nonatomic) NSString *fansCount;
@property (strong, nonatomic) NSString *focusCount;

@property (strong, nonatomic) AGCircleMemberOtherMemberData *member;
@property (strong, nonatomic) NSArray<AGCircleMemberOtherGroupData *> *groupList;
@property (strong, nonatomic) NSArray<AGCircleMemberOtherGroupDynamicsData *> *groupDynamics;

@end

/**
 * AGCircleMemberOtherData
 */
@interface AGCircleMemberOtherMemberData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *aliasId;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *authStatus;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *registerTime;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *giveMoney;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSString *hxId;
@property (strong, nonatomic) NSString *hxPwd;
@property (strong, nonatomic) NSString *inviteCode;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *angelPoints;
@property (strong, nonatomic) NSString *goldCoin;
@property (strong, nonatomic) NSString *giveGoldCoin;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *remark;

@end

/**
 * AGCircleMemberOtherGroupData
 */
@interface AGCircleMemberOtherGroupData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *categoryName;
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
 * AGCircleMemberOtherGroupDynamicsData
 */
@interface AGCircleMemberOtherGroupDynamicsData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *memberName;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *hasFocus;
@property (strong, nonatomic) NSString *hasLike;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *media;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *show;
@property (strong, nonatomic) NSString *discussList;
@property (strong, nonatomic) NSString *seeNum;
@property (strong, nonatomic) NSString *likeNum;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *createTime;

@end

/**
 * AGCircleMemberFansListData
 */
@interface AGCircleMemberFansListData : AGBaseData

@property (strong, nonatomic) AGCircleMemberFansListListData *data;

@end

/**
 * AGCircleMemberFansListListData
 */
@interface AGCircleMemberFansListListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGCircleMemberFansData *> *data;

@end

/**
 * AGCircleMemberFansData
 */
@interface AGCircleMemberFansData : AGBaseData

@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *nickName;
@property (assign, nonatomic) int hasFocus;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *registerTime;

@end

/**
 * AGCircleMemberAttentionListData
 */
@interface AGCircleMemberAttentionListData : AGBaseData

@property (strong, nonatomic) AGCircleMemberAttentionListListData *data;

@end

/**
 * AGCircleMemberAttentionListListData
 */
@interface AGCircleMemberAttentionListListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGCircleMemberAttentionData *> *data;

@end

/**
 * AGCircleMemberAttentionData
 */
@interface AGCircleMemberAttentionData : AGBaseData

@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *nickName;
@property (assign, nonatomic) int hasFocus;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *registerTime;

@end

NS_ASSUME_NONNULL_END
