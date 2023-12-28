//
//  AVAlertPopView.h
//  Interactive
//
//  Created by Abner on 16/7/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kAlertPopViewMinHeight = 145.f;
static CGFloat kConfirmButtonHeight = 50.f;
static CGFloat kAlertPopViewWidth = 310.f;
static CGFloat kCornerRadius = 20.f;

@interface AVAlertPopView : UIView

@property (nonatomic, strong) UILabel *infoLable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskBackView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *centerLineView;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) dispatch_block_t confirmBlock;
@property (nonatomic, copy) dispatch_block_t cancelBlock;

// 支持只显示确定按钮 cancelTitle 传空
- (instancetype)initWithTitle:(NSString *)title
                         info:(NSString *)info
                confirmButton:(NSString *)confirmTitle
                 cancelButton:(NSString *)cancelTitle
                  closeButton:(BOOL)isShowClose;

- (void)show;
- (void)hide;

+ (AVAlertPopView *)getAVAlertViewWithTag:(NSInteger)tag;

@end
