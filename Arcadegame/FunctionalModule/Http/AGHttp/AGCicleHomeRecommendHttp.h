//
//  AGCicleHomeRecommendHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/14.
//

#import "BaseManage.h"

#import "AGCicleHomeRecommendData.h"
#import "AGHomeClassifyData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_HOMEREC_URLAPI = @"/group/home"; //首页推荐
static const NSString *AG_CICLE_HOME_CLASSIFY_URLAPI = @"/group/category"; //圈子分类

@interface AGCicleHomeRecommendHttp : BaseManage

- (void)requestHomeRecommendDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCicleHomeRecommendListData *mBase;

@end

/**
 * AGCicleHomeClassifyHttp
 */
@interface AGCicleHomeClassifyHttp : BaseManage

- (void)requestHomeClassifyDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGHomeClassifyListData *mBase;

@end

NS_ASSUME_NONNULL_END
