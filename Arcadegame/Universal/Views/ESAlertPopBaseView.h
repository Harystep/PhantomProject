//
//  ESAlertPopBaseView.h
//  EShopClient
//
//  Created by Abner on 2019/7/6.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat kESAlertPopBaseViewMiniHeight = 180.f;

@interface ESAlertPopBaseView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) dispatch_block_t confirmBlock;

- (instancetype)initConfirmButton:(NSString *_Nullable)confirmTitle
                     cancelButton:(NSString *_Nullable)cancelTitle
                isShowCloseButton:(BOOL)isShowClose;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
