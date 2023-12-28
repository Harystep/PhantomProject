//
//  AGCircleMemberHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "BaseManage.h"
#import "AGCircleMemberData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_MEMBER_OTHERS_URLAPI = @"/group/others/info";
static const NSString *AG_CICLE_MEMBER_FOLLOW_URLAPI = @"/group/focus/user";
static const NSString *AG_CICLE_MEMBER_UNFOLLOW_URLAPI = @"/group/unfocus/user";
static const NSString *AG_CICLE_MEMBER_FANS_URLAPI = @"/group/fans/list";
static const NSString *AG_CICLE_MEMBER_ATTENTION_URLAPI = @"/group/attention/list";
static const NSString *AG_CICLE_MEMBER_BLACKUSER_URLAPI = @"/group/black/user";

@interface AGCircleMemberHttp : BaseManage

@end

/**
 * AGCircleMemberOthersHttp
 */
@interface AGCircleMemberOthersHttp : BaseManage

- (void)requestCircleMemberOthersDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleMemberOthersData *mBase;
@property (strong, nonatomic) NSString *memberId;

@end

/**
 * AGCircleMemberFollowHttp
 */
@interface AGCircleMemberFollowHttp : BaseManage

- (void)requestCircleMemberFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *memberId;

@end

/**
 * AGCircleMemberUnFollowHttp
 */
@interface AGCircleMemberUnFollowHttp : BaseManage

- (void)requestCircleMemberUnFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *memberId;

@end

/**
 * AGCircleMemberFansHttp
 */
@interface AGCircleMemberFansHttp : BaseManage

- (void)requestCircleMemberFansDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleMemberFansListData *mBase;

@end

/**
 * AGCircleMemberAttentionHttp
 */
@interface AGCircleMemberAttentionHttp : BaseManage

- (void)requestCircleMemberAttentionDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleMemberAttentionListData *mBase;

@end

/**
 * AGCircleMemberBlackUserHttp
 */
@interface AGCircleMemberBlackUserHttp : BaseManage

- (void)requestCircleMemberBlackUserDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *memberId;

@end

NS_ASSUME_NONNULL_END
