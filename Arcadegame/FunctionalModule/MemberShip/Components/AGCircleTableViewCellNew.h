//
//  AGCircleTableViewCellNew.h
//  Arcadegame
//
//  Created by Abner on 2023/9/25.
//

#import <UIKit/UIKit.h>
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleTableViewCellNew : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) AGCircleFollowLastData *mCFLData;
@property (copy, nonatomic) void(^didHeadIconSelectedHandle)(AGCircleFollowLastData *data);
@property (copy, nonatomic) void(^moreDidSelectedHandle)(AGCircleFollowLastData *data);

+ (CGFloat)getAGCircleSingleCategoryTableViewCellHeight:(AGCircleFollowLastData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
