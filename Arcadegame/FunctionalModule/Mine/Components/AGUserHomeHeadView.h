//
//  AGUserHomeHeadView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import <UIKit/UIKit.h>
#import "AGCircleMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGUserHomeHeadView : UIView

@property (assign, nonatomic) CGFloat topOffsetY;
@property (strong, nonatomic) AGCircleMemberOtherData *data;

@property (copy, nonatomic) void(^didFollowedSelectedHandle)(BOOL isFollowed);

@end

NS_ASSUME_NONNULL_END
