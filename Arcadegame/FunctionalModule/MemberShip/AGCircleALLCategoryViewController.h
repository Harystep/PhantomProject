//
//  AGCircleALLCategoryViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AGCircleData;

@interface AGCircleALLCategoryViewController : BaseViewController

@property (copy, nonatomic) void(^didSelectedHandle)(AGCircleData *circleData);

@end

NS_ASSUME_NONNULL_END
