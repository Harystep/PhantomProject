//
//  AGServiceData.h
//  Arcadegame
//
//  Created by Abner on 2023/6/27.
//

#import "AGBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGServiceBannerData;

@interface AGServiceData : NSObject

@end

/**
 * AGServiceUploadImageData
 */
@interface AGServiceUploadImageData : AGBaseData

@property (strong, nonatomic) NSString *data;

@end

/**
 * AGServiceBannerListData
 */
@interface AGServiceBannerListData : AGBaseData

@property (strong, nonatomic) NSArray<AGServiceBannerData *> *data;

@end

/**
 * AGServiceBannerData
 */
@interface AGServiceBannerData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *type;

@end

NS_ASSUME_NONNULL_END
