//
//  AGHomeGamingView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeGamingView : AGHomeBaseView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);
@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);


@end

/**
 * AGHomeGamingHeadView
 */
@interface AGHomeGamingHeadView : UIView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);
@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);

@end

/**
 * AGHomeGamingHeadContentView
 */
@interface AGHomeGamingHeadContentView : UIView

@property (strong, nonatomic) AGCicleHomeOtherDtoData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);

@end

/**
 * AGHomeGamingHeadContentBottomView
 */
@interface AGHomeGamingHeadContentBottomView : UIView

@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);

@end

NS_ASSUME_NONNULL_END
