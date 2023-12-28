//
//  AGHomeRecommendView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"
#import "AGCicleHomeRecommendData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeRecommendView : AGHomeBaseView

@property (strong, nonatomic) AGCicleHomeRecommendData *data;
@property (copy, nonatomic) void(^headSegaDidSelectedHandle)(AGCicleHomeRSegaData *data);
@property (copy, nonatomic) void(^headArcadeDidSelectedHandle)(AGCicleHomeRArcadeData *data);

@end

/**
 * AGHomeRecommendHeadView
 */
@interface AGHomeRecommendHeadView : UIView

@property (strong, nonatomic) AGCicleHomeRecommendData *data;
@property (copy, nonatomic) void(^headSegaDidSelectedHandle)(AGCicleHomeRSegaData *data);
@property (copy, nonatomic) void(^headArcadeDidSelectedHandle)(AGCicleHomeRArcadeData *data);

@end

/**
 * AGHomeRecommendHeadArcadeView
 * 街机房间
 */
@interface AGHomeRecommendHeadArcadeView : UIView

@property (strong, nonatomic) NSArray<AGCicleHomeRArcadeData *> *dataList;
@property (strong, nonatomic) NSArray<AGCicleHomeRBannerData *> *bannerData;
@property (copy, nonatomic) void(^headArcadeDidSelectedHandle)(AGCicleHomeRArcadeData *data);

@end

/**
 * AGHomeRecommendHeadSegaView
 * 推币机房间
 */
@interface AGHomeRecommendHeadSegaView : UIView

@property (strong, nonatomic) NSArray<AGCicleHomeRSegaData *> *dataList;
@property (copy, nonatomic) void(^headSegaDidSelectedHandle)(AGCicleHomeRSegaData *data);

@end

/**
 * AGHomeRecommendHeadImageView
 */
@interface AGHomeRecommendHeadImageView : UIView

@property (strong, nonatomic) NSArray<AGCicleHomeRBannerData *> *dataList;

@end


NS_ASSUME_NONNULL_END
