//
//  AGCircleSingleCategoryHeadView.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "AGCicleHomeOtherData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGCircleSingleCategoryHeadView : UIView

@property (strong, nonatomic) AGCicleHomeOtherDtoData *data;

@property (copy, nonatomic) void(^didFollowSelectedHandle)(BOOL isFollowed);

@end

NS_ASSUME_NONNULL_END
