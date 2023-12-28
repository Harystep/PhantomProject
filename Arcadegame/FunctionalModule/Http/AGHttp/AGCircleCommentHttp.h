//
//  AGCircleCommentHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "BaseManage.h"
#import "AGCircleCommentData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_COMMENT_LIST_URLAPI = @"/group/comment/list";
static const NSString *AG_CICLE_COMMENT_UP_URLAPI = @"/group/dynamic/comment";

@interface AGCircleCommentHttp : BaseManage

@end

/**
 * AGCircleCommentListHttp
 */
@interface AGCircleCommentListHttp : BaseManage

- (void)requestCircleCommentListDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCircleCommentListData *mBase;
@property (strong, nonatomic) NSString *dynamicId;

@end

/**
 * AGCircleCommentUpHttp
 */
@interface AGCircleCommentUpHttp : BaseManage

- (void)requestCircleCommentUpDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) NSData *mBase;

@property (strong, nonatomic) NSString *dynamicId;
@property (strong, nonatomic) NSString *content;

@end

NS_ASSUME_NONNULL_END
