//
//  ESPriceManage.h
//  EShopClient
//
//  Created by Abner on 2019/6/28.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESPriceManage : NSObject

+ (NSMutableAttributedString *)priceStringWithOriginString:(NSString *)string withLabel:(UILabel *)priveLabel withSmallFont:(UIFont *)smallFont;

@end

NS_ASSUME_NONNULL_END
