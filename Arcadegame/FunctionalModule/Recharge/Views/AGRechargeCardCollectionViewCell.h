//
//  AGRechargeCardCollectionViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/8/15.
//

#import <UIKit/UIKit.h>
#import "AGChargeHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGRechargeCardCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AGChargeOrderListOptionData *data;
@property (copy, nonatomic) void(^didPriceButtonSelectedHandle)(AGChargeOrderListOptionData *data);

@end

NS_ASSUME_NONNULL_END
