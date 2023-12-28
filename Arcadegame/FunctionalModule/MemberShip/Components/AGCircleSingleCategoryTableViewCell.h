//
//  AGCircleSingleCategoryTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleSingleCategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) AGCircleFollowLastData *data;
@property (copy, nonatomic) void(^didHeadIconSelectedHandle)(NSIndexPath *indexPath);
@property (copy, nonatomic) void(^didFuncBtnSelectedHandle)(NSIndexPath *indexPath);

+ (CGFloat)getAGCircleSingleCategoryTableViewCellHeight:(AGCircleFollowLastData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
