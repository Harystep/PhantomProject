//
//  AGCircleFunctionHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "BaseManage.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_FOLLOW_URLAPI = @"/group/focus/group";
static const NSString *AG_CICLE_UNFOLLOW_URLAPI = @"/group/unfocus/group";
static const NSString *AG_CICLE_LIKE_URLAPI = @"/group/dynamic/like";
static const NSString *AG_CICLE_REPORT_URLAPI = @"/group/accusation/dynamic";

@interface AGCircleFunctionHttp : BaseManage

@end

/**
 * AGCircleFollowHttp
 */
@interface AGCircleFollowHttp : BaseManage

- (void)requestCircleFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *groupId;

@end

/**
 * AGCircleUnFollowHttp
 */
@interface AGCircleUnFollowHttp : BaseManage

- (void)requestCircleUnFollowDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *groupId;

@end

/**
 * AGCircleLikeHttp
 */
@interface AGCircleLikeHttp : BaseManage

- (void)requestCircleLikeDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *dynamicId;

@end

/**
 * AGCircleREPORTHttp
 */
@interface AGCircleREPORTHttp : BaseManage

- (void)requestCircleAGCircleREPORTHttpDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *dynamicId;
@property (strong, nonatomic) NSString *content;

@end


NS_ASSUME_NONNULL_END
