//
//  AGCircleCategoryTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import <UIKit/UIKit.h>
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleCategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) AGCircleHotData *data;

+ (CGFloat)getAGCircleCategoryTableViewCellHeight:(AGCircleHotData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
