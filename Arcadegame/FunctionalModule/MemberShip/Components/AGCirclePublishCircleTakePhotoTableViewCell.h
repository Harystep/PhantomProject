//
//  AGCirclePublishCircleTakePhotoTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const NSInteger kMaxCountTag = 3;

@interface AGCirclePublishCircleTakePhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray<NSString *> *imagePaths;

@property (nonatomic, copy) void(^didSelectedTakePhotoHandle)(NSIndexPath *indexPath);

@end

NS_ASSUME_NONNULL_END
