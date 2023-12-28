//
//  AGHomeBoardGameView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeBoardGameView : AGHomeBaseView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);
@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);

@end

/**
 * AGHomeBoardGameHeadView
 */
@interface AGHomeBoardGameHeadView : UIView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);
@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);

@end

/**
 * AGHomeBoardGameHeadContentView
 */
@interface AGHomeBoardGameHeadContentView : UIView

@property (strong, nonatomic) AGCicleHomeOtherDtoData *data;
@property (copy, nonatomic) void(^headContentDidSelectedHandle)(AGCicleHomeOtherDtoData * data);

@end

/**
 * AGHomeBoardGameHeadContentBottomView
 */
@interface AGHomeBoardGameHeadContentBottomView : UIView

@property (copy, nonatomic) void(^headBottomDidSelectedHandle)(void);

@end

NS_ASSUME_NONNULL_END
