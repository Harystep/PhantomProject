//
//  AGCicleHomeOtherHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/21.
//

#import "BaseManage.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CICLE_HOMEOTHER_URLAPI = @"/group/category/recommend"; //首页分类推荐

@interface AGCicleHomeOtherHttp : BaseManage

- (void)requestHomeOtherDataResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;
@property (nonatomic, strong) AGCicleHomeOtherListData *mBase;
@property (strong, nonatomic) NSString *categoryId;

@end

NS_ASSUME_NONNULL_END
