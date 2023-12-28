//
//  AGMineViewController.h
//  Arcadegame
//
//  Created by rrj on 2023/6/9.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AGServiceBannerData;

@interface AGMineViewController : BaseViewController

@end

/**
 * AGMineViewBannerView
 */
@interface AGMineViewBannerView : UIView

@property (copy, nonatomic) void(^didSelectedHandle)(NSString *urlString);
@property (strong, nonatomic) NSArray<AGServiceBannerData *> *data;

@end

/**
 * AGMineViewBannerCollectionViewCell
 */
@interface AGMineViewBannerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AGServiceBannerData *data;

@end

NS_ASSUME_NONNULL_END
