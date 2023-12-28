//
//  AGHotGameBackCollectionViewCell.h
//  Arcadegame
//
//  Created by rrj on 2023/6/26.
//

#import <UIKit/UIKit.h>

@class AGCicleHomeRSegaData;
@class AGCicleHomeRBannerData;

NS_ASSUME_NONNULL_BEGIN

@interface AGHotGameBackCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) AGCicleHomeRSegaData *model;
@property (strong, nonatomic) AGCicleHomeRBannerData *bannerModel;

@end

NS_ASSUME_NONNULL_END
