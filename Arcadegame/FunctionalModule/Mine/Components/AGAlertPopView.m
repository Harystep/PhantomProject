//
//  AGAlertPopView.m
//  Arcadegame
//
//  Created by Abner on 2023/7/4.
//

#import "AGAlertPopView.h"

@interface AGAlertPopView () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *mTextField;
@property (strong, nonatomic) UIView *mContentContainView;

@end

@implementation AGAlertPopView

- (instancetype)initWithTitle:(NSString *)title
                         info:(NSString *)info
                confirmButton:(NSString *)confirmTitle
                 cancelButton:(NSString *)cancelTitle
                  closeButton:(BOOL)isShowClose{
    
    if(self = [super init]){
        
        self.width = kAGAlertPopViewWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLable];
        [self addSubview:self.closeButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.cancelButton];
        
        self.titleLabel.text = [NSString stringSafeChecking:title];
        
        CGFloat titleLabelHeight = [self.titleLabel sizeThatFits:CGSizeMake(self.width - kPadding * 10.f, CGFLOAT_MAX)].height;
        
        if(titleLabelHeight / self.titleLabel.font.lineHeight >= 2){
            
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        else {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        self.titleLabel.origin = CGPointMake(kPadding * 5, kPadding * 4);
        self.titleLabel.size = CGSizeMake(self.width - kPadding * 10.f, titleLabelHeight);
        
        self.infoLable.text = [NSString stringSafeChecking:info];
        
        CGFloat infoLableHeight = [self.infoLable sizeThatFits:CGSizeMake(self.width - kPadding * 10.f, CGFLOAT_MAX)].height;
        
        self.infoLable.origin = CGPointMake(self.titleLabel.left, self.titleLabel.bottom + kPadding * 2);
        self.infoLable.size = CGSizeMake(self.width - kPadding * 10.f, infoLableHeight);
        
        CGFloat viewHeight = self.infoLable.bottom + kPadding * 5 + kAGConfirmButtonHeight;
        
        if(viewHeight < kAGAlertPopViewMinHeight){
            
            viewHeight = kAGAlertPopViewMinHeight;
        }
        
        self.size = CGSizeMake(kAGAlertPopViewWidth, viewHeight);
        
        if([NSString isNotEmptyAndValid:cancelTitle]){
            
            self.cancelButton.hidden = NO;
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            
            self.cancelButton.origin = CGPointMake(kCornerRadius / 2.f, self.height -  kAGConfirmButtonHeight);
            self.cancelButton.size = CGSizeMake(self.width / 2.f - kCornerRadius / 2.f - 0.5, kAGConfirmButtonHeight);
        }
        else {
            self.cancelButton.hidden = YES;
            self.cancelButton.height = 0.f;
        }
        
        if([NSString isNotEmptyAndValid:confirmTitle]){
            
            self.confirmButton.hidden = NO;
            [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
            
            self.confirmButton.origin = CGPointMake(self.width / 2.f + 0.5, self.height -  kAGConfirmButtonHeight);
            self.confirmButton.size = CGSizeMake(self.width / 2.f - kCornerRadius / 2.f - 0.5, kAGConfirmButtonHeight);
            if(self.cancelButton.hidden){
                
                self.confirmButton.origin = CGPointMake(0, self.height -  kAGConfirmButtonHeight);
                self.confirmButton.centerX = self.width / 2.f;
            }
        }
        else {
            self.confirmButton.hidden = YES;
            self.confirmButton.height = 0.f;
        }
        
        if(isShowClose){
            
            self.closeButton.hidden = NO;
            self.closeButton.origin = CGPointMake(self.width - self.closeButton.width + kPadding / 1.5, -kPadding / 1.5);
        }
        else {
            self.closeButton.hidden = YES;
        }
        
        self.layer.cornerRadius = kCornerRadius;
    }
    
    return self;
}

- (instancetype)initWithType:(AGAlertType)type
                       title:(NSString *)title
                        info:(NSString *)info
               confirmButton:(NSString *)confirmTitle
                cancelButton:(NSString *)cancelTitle
                   autoClose:(BOOL)isAutoClose {
    if(self = [super init]){
        self.width = kAGAlertPopViewWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor whiteColor];

        UIImage *backImage = nil;
        switch (type) {
            case AGAlertType_Verified:
                backImage = IMAGE_NAMED(@"ag_alert_back_verified");
                break;
            case AGAlertType_Usermodify:
                backImage = IMAGE_NAMED(@"ag_alert_back_usermodify");
                break;
            case AGAlertType_Invitationcode:
                backImage = IMAGE_NAMED(@"ag_alert_back_invitationcode");
                break;
            case AGAlertType_IntegralConfirm:
                //积分兑换
                backImage = IMAGE_NAMED(@"");
                break;
            case AGAlertType_Check:
                backImage = IMAGE_NAMED(@"ag_alert_back_check");
                break;
                
            default:
                break;
        }

        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLable];
        [self addSubview:self.closeButton];
        [self addSubview:self.confirmButton];
        [self addSubview:self.cancelButton];

        self.titleLabel.text = [NSString stringSafeChecking:title];

        CGFloat titleLabelHeight = [self.titleLabel sizeThatFits:CGSizeMake(self.width - kPadding * 10.f, CGFLOAT_MAX)].height;

        if(titleLabelHeight / self.titleLabel.font.lineHeight >= 2){
            
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        else {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }

        self.titleLabel.origin = CGPointMake(kPadding * 5, kPadding * 4);
        self.titleLabel.size = CGSizeMake(self.width - kPadding * 10.f, titleLabelHeight);

        self.infoLable.text = [NSString stringSafeChecking:info];

        CGFloat infoLableHeight = [self.infoLable sizeThatFits:CGSizeMake(self.width - kPadding * 10.f, CGFLOAT_MAX)].height;

        self.infoLable.origin = CGPointMake(self.titleLabel.left, self.titleLabel.bottom + kPadding * 2);
        self.infoLable.size = CGSizeMake(self.width - kPadding * 10.f, infoLableHeight);

        CGFloat viewHeight = self.infoLable.bottom + kPadding * 5 + kAGConfirmButtonHeight;

        if(viewHeight < kAGAlertPopViewMinHeight){
            
            viewHeight = kAGAlertPopViewMinHeight;
        }
        
        self.height = backImage ? (backImage.size.height / backImage.size.width * self.width) : viewHeight;
        //self.size = CGSizeMake(kAGAlertPopViewWidth, viewHeight);
        if(backImage) {
            
            self.backgroundColor = [UIColor colorWithPatternImage:backImage];
            
            self.mContentContainView.origin = CGPointMake(15.f, 110.f * (282.f / self.height));
            self.mContentContainView.size = CGSizeMake(self.width - 15.f * 2, self.height - self.mContentContainView.origin.y - 15.f);
            [self addSubview:self.mContentContainView];
            [self.mContentContainView sendToBack];
        }

        if([NSString isNotEmptyAndValid:cancelTitle]){
            
            self.cancelButton.hidden = NO;
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            
            self.cancelButton.size = CGSizeMake(118.f, kAGConfirmButtonHeight);
            self.cancelButton.origin = CGPointMake(self.width / 2.f - self.cancelButton.width - 12.f, self.height -  kAGConfirmButtonHeight - 12.f - (backImage ? 15.f : 0.f));
            
            [self.cancelButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0xF2F2F2)] forState:UIControlStateNormal];
            [self.cancelButton setBackgroundImage:[HelpTools createImageWithColor:[UIColorFromRGB(0xF2F2F2) colorWithAlphaComponent:0.8f]] forState:UIControlStateHighlighted];
        }
        else {
            self.cancelButton.hidden = YES;
            self.cancelButton.height = 0.f;
        }
        
        if([NSString isNotEmptyAndValid:confirmTitle]){
            
            self.confirmButton.hidden = NO;
            [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
            
            self.confirmButton.size = CGSizeMake(118.f, kAGConfirmButtonHeight);
            self.confirmButton.origin = CGPointMake(self.width / 2.f + 12.f, self.height -  kAGConfirmButtonHeight - 12.f - (backImage ? 15.f : 0.f));
            if(self.cancelButton.hidden){
                
                self.confirmButton.origin = CGPointMake(0, self.height -  kAGConfirmButtonHeight - 12.f - (backImage ? 15.f : 0.f));
                self.confirmButton.centerX = self.width / 2.f;
            }
            [self.confirmButton setBackgroundImage:[HelpTools createGradientImageWithSize:self.confirmButton.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:0] forState:UIControlStateNormal];
            [self.confirmButton setBackgroundImage:[HelpTools createGradientImageWithSize:self.confirmButton.size colors:@[[UIColorFromRGB(0x41E1E0) colorWithAlphaComponent:0.8f], [UIColorFromRGB(0x31E79D) colorWithAlphaComponent:0.8f]] gradientType:0] forState:UIControlStateHighlighted];
        }
        else {
            self.confirmButton.hidden = YES;
            self.confirmButton.height = 0.f;
        }
        
        if(AGAlertType_Usermodify == type) {
            
            self.mTextField.frame = CGRectMake(16.f, 0.f, self.mContentContainView.width - 16.f * 2, 35.f);
            self.mTextField.centerY = self.mContentContainView.height / 2.f - 25.f;
            [self.mContentContainView addSubview:self.mTextField];
            
            UIView *bottomLineView = [[UIView alloc] initWithFrame:self.mTextField.frame];
            bottomLineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
            bottomLineView.top = self.mTextField.bottom;
            bottomLineView.height = 1.f;
            
            [self.mContentContainView addSubview:bottomLineView];
        }

        if(isAutoClose){
            
            self.closeButton.hidden = NO;
            self.closeButton.origin = CGPointMake(self.width - self.closeButton.width + kPadding / 1.5, -kPadding / 1.5);
        }
        else {
            self.closeButton.hidden = YES;
        }

        self.layer.cornerRadius = kCornerRadius;
        }

        return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if(!newSuperview)
        return;
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.3f;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            //[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                            //[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f/*, @0.5f, @0.75f*/, @0.4f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]/*,[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]*/];
    [self.layer addAnimation:popAnimation forKey:@"show"];
    
    self.alpha = 0.0f;
    self.maskBackView.alpha = 0.f;
    
    [UIView animateWithDuration:0.15f animations:^{
        
        self.alpha = 1.0f;
        self.maskBackView.alpha = 0.3f;
    }];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0.0f;
        self.maskBackView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.maskBackView removeFromSuperview];
        [super removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    self.center = CGPointMake(window.bounds.size.width / 2, window.bounds.size.height / 2);
    
    [window addSubview:self.maskBackView];
    [window addSubview:self];
}

- (void)hide{
    
    [self removeFromSuperview];
    
    if(self.dismissBlock){
        
        self.dismissBlock();
    }
}

- (NSString *)textFieldText {
    
    return self.mTextField.text;
}

#pragma mark -

+ (AVAlertPopView *)getAVAlertViewWithTag:(NSInteger)tag{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    return (AVAlertPopView *)[window viewWithTag:tag];
}

#pragma mark - Selector

- (void)tapGestureRecognizerAction:(id)sender{
    
    // [self hide];
    [self.mTextField resignFirstResponder];
}

- (void)closeButtonAction:(UIButton *)button{
    
    [self hide];
}

- (void)confirmButtonAction:(UIButton *)button{
    
    [self hide];
    
    if(self.confirmBlock){
        
        self.confirmBlock();
    }
    
    if(self.confirmTextBlock) {
        
        self.confirmTextBlock(self.textFieldText);
    }
}

- (void)cancelButtonAction:(UIButton *)button{
    
    [self hide];
    
    if(self.cancelBlock){
        self.cancelBlock();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL shouldEdit = YES;
    
    if((string.length > range.length) &&
       (([HelpTools convertToInt:textField.text] + [HelpTools convertToInt:string] - range.length) > 16)){
        
        shouldEdit = NO;
    }
    
    return shouldEdit;
}

- (void)textFieldChanged:(UITextField *)textField {
    
    DLOG(@"textFieldChanged:%@", textField.text);
}

#pragma mark - Getter

- (UIView *)maskBackView{
    
    if(!_maskBackView){
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        
        _maskBackView = [[UIView alloc] initWithFrame:window.bounds];
        _maskBackView.backgroundColor = [UIColor blackColor];
        _maskBackView.alpha = 0.3f;
        
        _maskBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [_maskBackView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _maskBackView;
}

- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_BOLD_SYSTEM(15.f);
        _titleLabel.textColor = [UIColor blackColor333333];
        _titleLabel.numberOfLines = 0;
    }
    
    return _titleLabel;
}

- (UILabel *)infoLable{
    
    if(!_infoLable){
        
        _infoLable = [UILabel new];
        _infoLable.font = FONT_SYSTEM(15.f);
        _infoLable.textColor = [UIColor blackColor333333];
        _infoLable.textAlignment = NSTextAlignmentCenter;
        _infoLable.numberOfLines = 0;
    }
    
    return _infoLable;
}

- (UIButton *)closeButton{

    if(!_closeButton){
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:IMAGE_NAMED(@"btn_close_normal") forState:UIControlStateNormal];
        [_closeButton setImage:IMAGE_NAMED(@"btn_close_pressed") forState:UIControlStateHighlighted];
        
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.size = CGSizeMake(32.f, 32.f);
    }
    
    return _closeButton;
}

- (UIButton *)confirmButton{
    
    if(!_confirmButton){
        
        _confirmButton = [UIButton new];
        _confirmButton.layer.cornerRadius = 10.f;
        _confirmButton.clipsToBounds = YES;
        
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        
        //_confirmButton.backgroundColor = [UIColor clearColor];
        _confirmButton.titleLabel.font = FONT_SYSTEM(16.f);
        
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UIButton *)cancelButton{
    
    if(!_cancelButton){
        
        _cancelButton = [UIButton new];
        _cancelButton.layer.cornerRadius = 10.f;
        _cancelButton.clipsToBounds = YES;
        
        [_cancelButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB_ALPHA(0x333333, 0.8) forState:UIControlStateHighlighted];
        
        //_cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = FONT_SYSTEM(16.f);
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

- (UIView *)mContentContainView {
    
    if(!_mContentContainView) {
        
        _mContentContainView = [UIView new];
        _mContentContainView.backgroundColor = [UIColor whiteColor];
        _mContentContainView.layer.cornerRadius = 20.f;
    }
    
    return _mContentContainView;
}

- (UITextField *)mTextField{
    
    if(!_mTextField){
        
        _mTextField = [UITextField new];
        _mTextField.font = [UIFont font16];
        _mTextField.textColor = [UIColor blackColor333333];
        _mTextField.placeholder = @"请输入用户名";
        _mTextField.delegate = self;
        
        [_mTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _mTextField;
}

@end
