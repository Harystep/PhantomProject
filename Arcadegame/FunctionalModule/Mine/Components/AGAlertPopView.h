//
//  AGAlertPopView.h
//  Arcadegame
//
//  Created by Abner on 2023/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat kAGAlertPopViewMinHeight = 145.f;
static CGFloat kAGConfirmButtonHeight = 42.f;
static CGFloat kAGAlertPopViewWidth = 310.f;
static CGFloat kAGCornerRadius = 20.f;

typedef NS_ENUM(NSInteger, AGAlertType) {
    
    AGAlertType_Defalut = 0,
    AGAlertType_Verified,
    AGAlertType_Usermodify,
    AGAlertType_Invitationcode,
    AGAlertType_IntegralConfirm,
    AGAlertType_Check,
};

@interface AGAlertPopView : UIView

@property (nonatomic, strong) UILabel *infoLable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskBackView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, copy) dispatch_block_t confirmBlock;
@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (strong, nonatomic) void(^confirmTextBlock)(NSString *textFieldText);

@property (strong, nonatomic) NSString *textFieldText;

// 支持只显示确定按钮 cancelTitle 传空
- (instancetype)initWithTitle:(NSString *)title
                         info:(NSString *)info
                confirmButton:(NSString *)confirmTitle
                 cancelButton:(NSString *)cancelTitle
                  closeButton:(BOOL)isShowClose;

- (instancetype)initWithType:(AGAlertType)type
                       title:(NSString *)title
                        info:(NSString *)info
               confirmButton:(NSString *)confirmTitle
                cancelButton:(NSString *)cancelTitle
                   autoClose:(BOOL)isAutoClose;

- (void)show;
- (void)hide;

+ (AVAlertPopView *)getAVAlertViewWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
