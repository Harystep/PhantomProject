//
//  AGCirclePublishCircleConfirmTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGCirclePublishCircleConfirmTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^didSelectedHandle)(void);

@end

NS_ASSUME_NONNULL_END
