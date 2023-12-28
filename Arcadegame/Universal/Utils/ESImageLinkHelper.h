//
//  ESImageLinkHelper.h
//  EShopClient
//
//  Created by Abner on 2019/11/27.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESImageLinkHelper : NSObject

+ (NSString *)fixedImageLinkWithURLString:(NSString *)URLString withSize:(CGSize)imageSize;

@end

NS_ASSUME_NONNULL_END
