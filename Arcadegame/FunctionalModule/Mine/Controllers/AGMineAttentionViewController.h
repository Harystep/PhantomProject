//
//  AGMineAttentionViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/7/5.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleMemberAttentionData;

@interface AGMineAttentionViewController : BaseViewController

@end

/**
 * AGMineAttentionTableViewCell
 */
typedef NS_ENUM(NSInteger, MineAttentionTableViewCorner) {
    
    KMineAttentionTableViewCorner_top,
    KMineAttentionTableViewCorner_Bottom,
    KMineAttentionTableViewCorner_All,
    KMineAttentionTableViewCorner_None,
};

@interface AGMineAttentionTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) AGCircleMemberAttentionData *data;
@property (assign, nonatomic) MineAttentionTableViewCorner corner;

@property (copy, nonatomic) void(^didFollowedSelectedHandle)(AGCircleMemberAttentionData *data);

@end

NS_ASSUME_NONNULL_END
