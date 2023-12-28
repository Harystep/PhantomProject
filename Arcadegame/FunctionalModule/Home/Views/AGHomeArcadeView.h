//
//  AGHomeArcadeView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeArcadeView : AGHomeBaseView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^didHeadSelectedLeftHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didHeadSelectedRightCellHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didHeadSelectedRightHeadHandle)(void);

@end

/**
 * AGHomeArcadeHeadView
 */
@interface AGHomeArcadeHeadView : UIView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^didSelectedLeftHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didSelectedRightCellHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didSelectedRightHeadHandle)(void);

@end

/**
 * AGHomeArcadeHeadLeftView
 */
@interface AGHomeArcadeHeadLeftView : UIView

@property (strong, nonatomic) AGCicleHomeOtherDtoData *data;
@property (copy, nonatomic) void(^didSelectedHandle)(AGCicleHomeOtherDtoData *data);

@end

/**
 * AGHomeArcadeHeadRightView
 */
@interface AGHomeArcadeHeadRightView : UIView

@property (strong, nonatomic) NSArray<AGCicleHomeOtherDtoData *> *dataList;

@property (copy, nonatomic) void(^didSelectedHeadHandle)(void);
@property (copy, nonatomic) void(^didSelectedCellHandle)(AGCicleHomeOtherDtoData *data);

@end

/**
 * AGHomeArcadeHeadRightTableViewCell
 */
@interface AGHomeArcadeHeadRightTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *infoText;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
