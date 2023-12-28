//
//  AGMineCircleViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/9/22.
//

#import <UIKit/UIKit.h>
@class AGCircleGroupFollowData;

NS_ASSUME_NONNULL_BEGIN

@interface AGMineCircleViewController : BaseViewController

@end

/**
 * AGMineCircleViewTableViewCell
 */
@interface AGMineCircleViewTableViewCell : UITableViewCell

@property (strong, nonatomic) AGCircleGroupFollowData *data;

@end

NS_ASSUME_NONNULL_END
