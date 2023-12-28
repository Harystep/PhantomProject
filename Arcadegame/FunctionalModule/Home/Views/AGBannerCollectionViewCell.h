//
//  AGBannerCollectionViewCell.h
//  Arcadegame
//
//  Created by rrj on 2023/6/25.
//

#import <UIKit/UIKit.h>

@class AGCicleHomeRArcadeData;
@class AGCicleHomeRBannerData;

NS_ASSUME_NONNULL_BEGIN

@interface AGBannerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AGCicleHomeRArcadeData *model;
@property (strong, nonatomic) AGCicleHomeRBannerData *bannerData;

@end

NS_ASSUME_NONNULL_END
