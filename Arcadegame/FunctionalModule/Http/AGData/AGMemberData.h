//
//  AGMemberData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/28.
//

#import "AGBaseData.h"
#import "AGListBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGUserInfoData;
@class AGUserMember;
@class AGMemberMyCircleData;
@class AGMemberInviteInfoData;
@class AGMemberMyCircleListListData;
@class AGMemberMyCircleMemberBaseDto;
@class AGGlobalUserInfoLevelDtoData;
@class AGGlobalUserInfoInfoData;

@interface AGMemberData : AGBaseData

@end

/**
 * AGMemberUserInfoData
 */
@interface AGMemberUserInfoData : AGBaseData

@property (strong, nonatomic) AGUserInfoData *data;

@end

/**
 * AGUserInfoData
 */
@interface AGUserInfoData : NSObject

@property (strong, nonatomic) NSString *fansCount;
@property (strong, nonatomic) NSString *focusCount;
@property (strong, nonatomic) NSString *groupCount;
@property (strong, nonatomic) NSArray *groupDynamics; // 我的动态
@property (strong, nonatomic) AGUserMember *member;

@property (strong, nonatomic) NSString *token;

@end

/**
 * AGUserMember
 */
@interface AGUserMember : NSObject

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *aliasId;
@property (strong, nonatomic) NSString *authStatus;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *giveGoldCoin;
@property (strong, nonatomic) NSString *giveMoney;
@property (strong, nonatomic) NSString *goldCoin;
@property (strong, nonatomic) NSString *hxId;
@property (strong, nonatomic) NSString *hxPwd;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *inviteCode;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *platform;
@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSString *registerTime;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *updateTime;
@property (strong, nonatomic) NSString *userId;

@end

/**
 *  AGMemberLoginAliYunData
 */
@interface AGMemberLoginAliYunData : AGBaseData

@property (strong, nonatomic) NSString *data;

@end

/**
 *  AGMemberMyCircleListData
 */
@interface AGMemberMyCircleListData : AGBaseData

@property (strong, nonatomic) AGMemberMyCircleListListData *data;

@end

/**
 *  AGMemberMyCircleListListData
 */
@interface AGMemberMyCircleListListData : AGListBaseData

@property (strong, nonatomic) NSArray<AGMemberMyCircleData *> *data;

@end

/**
 *  AGMemberMyCircleData
 */
@interface AGMemberMyCircleData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *commentNum;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *hasFocus;
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
@property (strong, nonatomic) AGMemberMyCircleMemberBaseDto *memberBaseDto;

@end

/**
 *  AGMemberMyCircleMemberBaseDto
 */
@interface AGMemberMyCircleMemberBaseDto : NSObject

@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *levelName;

@end

/**
 *  AGMemberInviteInfoDataData
 */
@interface AGMemberInviteInfoDataData : AGBaseData

@property (strong, nonatomic) AGMemberInviteInfoData *data;

@end

/**
 *  AGMemberInviteInfoData
 */
@interface AGMemberInviteInfoData : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *max_rewards;
@property (strong, nonatomic) NSString *rewards;

@end

/**
 *  AGGlobalUserInfoData
 */
@interface AGGlobalUserInfoData : AGBaseData

@property (strong, nonatomic) AGGlobalUserInfoInfoData *data;

@end

/**
 *  AGGlobalUserInfoInfoData
 */
@interface AGGlobalUserInfoInfoData : NSObject

@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *money; // 钻石
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *authStatus;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *hxId;
@property (strong, nonatomic) NSString *hxPwd;
@property (strong, nonatomic) NSString *inviteCode;
@property (strong, nonatomic) NSString *aliasId;
@property (strong, nonatomic) NSString *goodsNum;
@property (strong, nonatomic) NSString *isSign;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *goldCoin; // 金币
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *points; // 积分
@property (strong, nonatomic) NSString *registerTime;
@property (strong, nonatomic) AGGlobalUserInfoLevelDtoData *memberLevelDto;

@end

/**
 *  AGGlobalUserInfoLevelDtoData
 */
@interface AGGlobalUserInfoLevelDtoData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *level;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *targetMoney;
@property (strong, nonatomic) NSString *progress;
@property (strong, nonatomic) NSString *tips;

@end

NS_ASSUME_NONNULL_END
