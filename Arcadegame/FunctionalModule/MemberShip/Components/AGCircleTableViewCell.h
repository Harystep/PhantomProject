//
//  AGCircleTableViewCell.h
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import <UIKit/UIKit.h>
#import "AGCircleData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleTableViewCell : UITableViewCell

+ (CGFloat)calculateHeightWithCFLData:(AGCircleFollowLastData *)cflData;

@property (strong, nonatomic) AGCircleFollowLastData *mCFLData;
@property (copy, nonatomic) void(^didHeadIconSelectedHandle)(AGCircleFollowLastData *data);
@property (copy, nonatomic) void(^moreDidSelectedHandle)(AGCircleFollowLastData *data);

@end

NS_ASSUME_NONNULL_END
