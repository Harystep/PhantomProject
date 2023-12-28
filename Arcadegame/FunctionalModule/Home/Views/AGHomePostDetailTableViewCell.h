//
//  AGHomePostDetailTableViewCell.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "AGCircleData.h"
#import "AGCircleCommentData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomePostDetailTableViewCell : UITableViewCell

@end

/**
 * AGHomePostDetailTableHeadViewCell
 */
@interface AGHomePostDetailTableHeadViewCell : UITableViewCell

@property (copy, nonatomic) void(^didHeadIconSelectedHandle)(void);
@property (copy, nonatomic) void(^didFollowSelectedHandle)(BOOL isFollowed);
@property (strong, nonatomic) AGCircleDetailData *data;

@end

/**
 * AGHomePostDetailTableContentViewCell
 */
@interface AGHomePostDetailTableContentViewCell : UITableViewCell

@property (strong, nonatomic) NSString *data;

+ (CGFloat)getAGCircleCategoryTableViewCellHeight:(NSString *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index;

@end

/**
 * AGHomePostDetailTableRewardViewCell
 */
@interface AGHomePostDetailTableRewardViewCell : UITableViewCell

@property (copy, nonatomic) void(^didSelectedRewardHandle)(void);

@end

/**
 * AGHomePostDetailTableFunctionViewCell
 */
@interface AGHomePostDetailTableFunctionViewCell : UITableViewCell

@property (copy, nonatomic) void(^didLikeSelectedHandle)(BOOL isLiked);
@property (copy, nonatomic) void(^didMoreSelectedHandle)(void);
@property (strong, nonatomic) AGCircleDetailData *data;

@end

/**
 * AGHomePostDetailTableCircleView
 */
@interface AGHomePostDetailTableCircleView : UIView

@property (strong, nonatomic) AGCircleDetailGroupData *data;

@end

/**
 * AGHomePostDetailTableCommentHeadViewCell
 */
@interface AGHomePostDetailTableCommentHeadViewCell : UITableViewCell

@property (strong, nonatomic) NSString *data;

@end

/**
 * AGHomePostDetailTableCommentViewCell
 */
@interface AGHomePostDetailTableCommentViewCell : UITableViewCell

@property (copy, nonatomic) void(^didHeadIconSelectedHandle)(AGCircleCommentData *data);
@property (copy, nonatomic) void(^didComplainButtonSelectedHandle)(AGCircleCommentData *data);
@property (strong, nonatomic) AGCircleCommentData *data;

+ (CGFloat)getAGHomePostDetailTableCommentCellHeight:(AGCircleCommentData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index;

@end

NS_ASSUME_NONNULL_END
