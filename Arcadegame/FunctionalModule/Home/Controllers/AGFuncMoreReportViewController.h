//
//  AGFuncMoreReportViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/7/4.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGFuncMoreReportViewController : BaseViewController

@property (copy, nonatomic) void(^didSelectedReportHandle)(NSString *reson);

@end

NS_ASSUME_NONNULL_END
