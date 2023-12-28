//
//  AVAlertPopView.m
//  Interactive
//
//  Created by Abner on 16/7/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "AVAlertPopView.h"

@interface AVAlertPopView ()

@end

@implementation AVAlertPopView

- (instancetype)initWithTitle:(NSString *)title
                         info:(NSString *)info
                confirmButton:(NSString *)confirmTitle
                 cancelButton:(NSString *)cancelTitle
                  closeButton:(BOOL)isShowClose{
    
    if(self = [super init]){
        
        self.width = kAlertPopViewWidth;
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
        
        CGFloat viewHeight = self.infoLable.bottom + kPadding * 5 + kConfirmButtonHeight;
        
        if(viewHeight < kAlertPopViewMinHeight){
            
            viewHeight = kAlertPopViewMinHeight;
        }
        
        self.size = CGSizeMake(kAlertPopViewWidth, viewHeight);
        
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height -  kConfirmButtonHeight - 1.f, self.width, 1.f)];
        _topLineView.backgroundColor = UIColorFromRGB(0xE1DDDD);
        [self addSubview:_topLineView];
        
        if([NSString isNotEmptyAndValid:cancelTitle]){
            
            self.cancelButton.hidden = NO;
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            
            self.cancelButton.origin = CGPointMake(kCornerRadius / 2.f, self.height -  kConfirmButtonHeight);
            self.cancelButton.size = CGSizeMake(self.width / 2.f - kCornerRadius / 2.f - 0.5, kConfirmButtonHeight);
        }
        else {
            self.cancelButton.hidden = YES;
            self.cancelButton.height = 0.f;
        }
        
        _centerLineView = [[UIView alloc] initWithFrame:CGRectMake(self.width / 2.f - 0.5, self.height -  kConfirmButtonHeight, 1.f, kConfirmButtonHeight)];
        _centerLineView.backgroundColor = UIColorFromRGB(0xE1DDDD);
        [self addSubview:_centerLineView];
        
        if([NSString isNotEmptyAndValid:confirmTitle]){
            
            self.confirmButton.hidden = NO;
            [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
            
            self.confirmButton.origin = CGPointMake(self.width / 2.f + 0.5, self.height -  kConfirmButtonHeight);
            self.confirmButton.size = CGSizeMake(self.width / 2.f - kCornerRadius / 2.f - 0.5, kConfirmButtonHeight);
            if(self.cancelButton.hidden){
                
                _centerLineView.hidden = YES;
                
                self.confirmButton.origin = CGPointMake(0, self.height -  kConfirmButtonHeight);
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

#pragma mark -

+ (AVAlertPopView *)getAVAlertViewWithTag:(NSInteger)tag{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    return (AVAlertPopView *)[window viewWithTag:tag];
}

#pragma mark - Selector

- (void)tapGestureRecognizerAction:(id)sender{
    
    // [self hide];
}

- (void)closeButtonAction:(UIButton *)button{
    
    [self hide];
}

- (void)confirmButtonAction:(UIButton *)button{
    
    [self hide];
    
    if(self.confirmBlock){
        
        self.confirmBlock();
    }
}

- (void)cancelButtonAction:(UIButton *)button{
    
    [self hide];
    
    if(self.cancelBlock){
        self.cancelBlock();
    }
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
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:[UIColor eshopColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[[UIColor eshopColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        
        _confirmButton.backgroundColor = [UIColor clearColor];
        _confirmButton.titleLabel.font = FONT_SYSTEM(15.f);
        
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UIButton *)cancelButton{
    
    if(!_cancelButton){
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB_ALPHA(0x999999, 0.8) forState:UIControlStateHighlighted];
        
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = FONT_SYSTEM(15.f);
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

@end
