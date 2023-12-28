//
//  AGServiceHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/6/27.
//

#import "BaseManage.h"
#import "AGServiceData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_SERVICE_UPLOADI_URLAPI = @"/upload/image";
static const NSString *AG_SERVICE_BANNER_URLAPI = @"/banner/v1";

@interface AGServiceHttp : BaseManage

@end

/**
 * AGServiceUploadImageHttp
 */
@interface AGServiceUploadImageHttp : BaseManage

- (void)requestServiceUploadImageResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGServiceUploadImageData *mBase;
- (void)setFilePath:(NSString *)pathString;

@end

/**
 * AGServiceBannerHttp
 */
@interface AGServiceBannerHttp : BaseManage

- (void)requestServiceBannerResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGServiceBannerListData *mBase;

@end

NS_ASSUME_NONNULL_END
