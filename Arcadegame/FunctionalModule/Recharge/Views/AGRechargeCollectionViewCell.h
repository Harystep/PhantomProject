//
//  AGRechargeCollectionViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/7/19.
//

#import <UIKit/UIKit.h>
#import "AGChargeHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGRechargeCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) AGChargeOrderListType type;
@property (strong, nonatomic) AGChargeOrderListOptionData *data;

@end

NS_ASSUME_NONNULL_END
