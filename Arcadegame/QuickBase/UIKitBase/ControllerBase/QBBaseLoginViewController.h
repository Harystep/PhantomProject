//
//  QBBaseLoginViewController.h
//  QuickBase
//
//  Created by Abner on 2019/6/21.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Login View 基于此类建立, 保证数据错误的时候能处理登录逻辑
 */
@interface QBBaseLoginViewController : BaseViewController

@property (nonatomic, copy) void (^loginSuccessHandle)(void);
@property (nonatomic, copy) void (^loginCancelHandle)(void);

- (void)backToParentViewAnimate:(BOOL)Animate;
- (void)backToPresentRootVCAnimate:(BOOL)animate;
- (void)backToRootViewControllerAnimate:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
