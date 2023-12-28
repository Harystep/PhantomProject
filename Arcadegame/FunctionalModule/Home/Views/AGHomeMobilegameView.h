//
//  AGHomeMobilegameView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeMobilegameView : AGHomeBaseView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^didHeadSelectedCellHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didHeadSelectedRightHeadHandle)(void);
@property (copy, nonatomic) void(^didHeadSelectedLeftHeadHandle)(void);

@end

/**
 * AGHomeMobilegameHeadView
 */
@interface AGHomeMobilegameHeadView : UIView

@property (strong, nonatomic) AGCicleHomeOtherData *data;
@property (copy, nonatomic) void(^didSelectedCellHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didSelectedRightHeadHandle)(void);
@property (copy, nonatomic) void(^didSelectedLeftHeadHandle)(void);

@end

/**
 * AGHomeMobilegameHeadContentView
 */
@interface AGHomeMobilegameHeadContentView : UIView

@property (assign, nonatomic) BOOL isHot;
@property (strong, nonatomic) NSArray<AGCicleHomeOtherDtoData *> *dataList;

@property (copy, nonatomic) void(^didSelectedCellHandle)(AGCicleHomeOtherDtoData *data);
@property (copy, nonatomic) void(^didSelectedHeadHandle)(void);

@end

/**
 * AGHomeMobilegameHeadCTableViewCell
 */
@interface AGHomeMobilegameHeadCTableViewCell : UITableViewCell

@property (strong, nonatomic) AGCicleHomeOtherDtoData *data;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
