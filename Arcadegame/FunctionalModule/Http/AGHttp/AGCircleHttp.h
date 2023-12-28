//
//  AGCircleHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/21.
//

#import "BaseManage.h"
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_HOTLIST_URLAPI = @"/group/hot"; // 热门圈子
static const NSString *AG_CICLE_LIST_URLAPI = @"/group/list"; // 圈子列表含搜索
static const NSString *AG_CICLE_LIST_FOLLOW_URLAPI = @"/group/dynamic/follow"; // 关注的动态列表
static const NSString *AG_CICLE_LIST_LATER_URLAPI = @"/group/dynamic/later"; // 最新的动态列表
static const NSString *AG_CICLE_DETAIL_URLAPI = @"/group/dynamic/info"; // 动态明细
static const NSString *AG_CICLE_PUBLISH_URLAPI = @"/group/dynamic/publish";  // 发布动态
static const NSString *AG_CICLE_GROUPFOLLOW_URLAPI = @"/group/follow"; //关注的圈子列表

@interface AGCircleHttp : BaseManage

@end

/**
 * AGCircleHotListHttp
 */
@interface AGCircleHotListHttp : BaseManage

- (void)requestCircleHotListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleHotListData *mBase;

@end

/**
 * AGCircleListHttp
 */
@interface AGCircleListHttp : BaseManage

- (void)requestCircleListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleListData *mBase;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *keyword;

@end

/**
 * AGCircleFollowListHttp
 */
@interface AGCircleFollowListHttp : BaseManage

- (void)requestCircleFollowListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleFollowLastListData *mBase;

@end

/**
 * AGCircleLaterListHttp
 */
@interface AGCircleLaterListHttp : BaseManage

- (void)requestCircleLaterListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleFollowLastListData *mBase;
@property (strong, nonatomic) NSString *groupId;

@end

/**
 * AGCircleDetailHttp
 */
@interface AGCircleDetailHttp : BaseManage

- (void)requestCircleDetailDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleDetailContainerData *mBase;
@property (strong, nonatomic) NSString *dynamicId;

@end

/**
 * AGCircleDetailHttp
 */
@interface AGCirclePublishHttp : BaseManage

- (void)requestCirclePublishDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;

@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *discuss; // 话题，用,隔开
@property (strong, nonatomic) NSString *images; // 图片，用;分割

@end

/**
 * AGCircleGroupFllowHttp
 */
@interface AGCircleGroupFllowHttp : BaseManage

- (void)requestCircleGroupFllowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleGroupFollowListData *mBase;

@end

NS_ASSUME_NONNULL_END
