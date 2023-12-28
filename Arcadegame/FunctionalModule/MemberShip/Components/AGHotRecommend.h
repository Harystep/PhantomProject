//
//  AGHotRecommend.h
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import "AGGradientView.h"
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHotRecommend : UIView

@property (strong, nonatomic) AGCircleHotListData *data;
@property (copy, nonatomic) void(^didSelectedHeadHandle)(void);
@property (copy, nonatomic) void(^didSelectedContentHandle)(AGCircleHotData *data);

@end

NS_ASSUME_NONNULL_END
