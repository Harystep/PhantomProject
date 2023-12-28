//
//  AGMineFansViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleMemberFansData;

@interface AGMineFansViewController : BaseViewController

@end

/**
 * AGMineFansTableViewCell
 */
typedef NS_ENUM(NSInteger, MineFansTableViewCorner) {
    
    KMineFansTableViewCorner_top,
    KMineFansTableViewCorner_Bottom,
    KMineFansTableViewCorner_All,
    KMineFansTableViewCorner_None,
};

@interface AGMineFansTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) AGCircleMemberFansData *data;
@property (assign, nonatomic) MineFansTableViewCorner corner;

@property (copy, nonatomic) void(^didFollowedSelectedHandle)(AGCircleMemberFansData *data);

@end

NS_ASSUME_NONNULL_END
