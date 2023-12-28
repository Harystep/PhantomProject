//
//  AGMemberHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/28.
//

#import "BaseManage.h"
#import "AGMemberData.h"
#import "AGUserData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_MEMBER_LOGIN_APPLE_URLAPI = @"/apple/login"; //苹果登录
static const NSString *AG_MEMBER_LOGIN_PHONENUM_URLAPI = @"/user/mobile/one_key_login"; //手机号一键登录，适用于自动获取手机号的方式登录
static const NSString *AG_MEMBER_LOGIN_ALIYUN_URLAPI = @"/user/aliyun/one_key_login"; //阿里云认证，获取手机号
 
static const NSString *AG_MEMBER_USERINFO_URLAPI = @"/group/my"; // 用户详情
static const NSString *AG_MEMBER_SIGN_URLAPI = @"/sign/v2"; // 签到
static const NSString *AG_MEMBER_INVITECONFIRM_URLAPI = @"/invite/code"; // 输入邀请码
static const NSString *AG_MEMBER_INVITEINFO_URLAPI = @"/invite/v2"; // 邀请信息
static const NSString *AG_MEMBER_DELETE_URLAPI = @"/member/cancel/v2"; // 账号注销
static const NSString *AG_MEMBER_USERINFOEDIT_URLAPI = @"/user/edit"; // 用户信息修改
static const NSString *AG_CIRCLE_MYCIRCLE_URLAPI = @"/group/my/dynamic"; // 我的动态

static const NSString *AG_USER_INFO_URLAPI = @"/user/info/v2"; // 用户信息
static const NSString *AG_MEMBER_REWARD_URLAPI = @"/member/rewardDiamond"; // 钻石打赏

@interface AGMemberHttp : BaseManage

@end

/**
 * AGMemberLoginAppleHttp
 */
@interface AGMemberLoginAppleHttp : BaseManage

- (void)requestMemberLoginAppleHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGUserData *mBase;
@property (strong, nonatomic) NSString *identityToken;

@end

/**
 * AGMemberLoginPhoneNumHttp
 */
@interface AGMemberLoginPhoneNumHttp : BaseManage

- (void)requestMemberLoginPhoneNumHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGUserData *mBase;
@property (strong, nonatomic) NSString *phoneNum;

@end

/**
 * AGMemberLoginAliYunHttp
 */
@interface AGMemberLoginAliYunHttp : BaseManage

- (void)requestMemberLoginAliYunResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGMemberLoginAliYunData *mBase;
@property (strong, nonatomic) NSString *loginToken;

@end

/**
 * AGMemberUserInfoHttp
 */
@interface AGMemberUserInfoHttp : BaseManage

- (void)requestMemberUserInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGMemberUserInfoData *mBase;

@end

/**
 * AGMemberSignHttp
 */
@interface AGMemberSignHttp : BaseManage

@end

/**
 * AGMemberInviteConfirmHttp
 */
@interface AGMemberInviteConfirmHttp : BaseManage

@end

/**
 * AGMemberInviteInfoHttp
 */
@interface AGMemberInviteInfoHttp : BaseManage

- (void)requestMemberInviteInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGMemberInviteInfoDataData *mBase;

@end

/**
 * AGMemberMemberDeleteHttp
 */
@interface AGMemberMemberDeleteHttp : BaseManage

- (void)requestMemberMemberDeleteResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) NSData *mBase;

@end

/**
 * AGMemberUserInfoEditHttp
 */
@interface AGMemberUserInfoEditHttp : BaseManage

- (void)requestMemberUserInfoEditResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *avatar;
@property (nonatomic, strong) NSData *mBase;

@end

/**
 * AGMemberMyCircleHttp
 */
@interface AGMemberMyCircleHttp : BaseManage

- (void)requestMemberMyCircleResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGMemberMyCircleListData *mBase;

@end

/**
 * AGUserInfoHttp
 */
@interface AGUserInfoHttp : BaseManage

- (void)requestUserInfoResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGGlobalUserInfoData *mBase;

@end

/**
 * AGMemberRewardHttp
 */
@interface AGMemberRewardHttp : BaseManage

- (void)requestMemberRewardResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (strong, nonatomic) NSString *diamondNum;
@property (strong, nonatomic) NSString *memberId;

@property (nonatomic, strong) AGBaseData *mBase;

@end

NS_ASSUME_NONNULL_END
