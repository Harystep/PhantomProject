//
//  ESAlertPopBaseView.m
//  EShopClient
//
//  Created by Abner on 2019/7/6.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESAlertPopBaseView.h"

@interface ESAlertPopBaseView ()

@property (nonatomic, strong) UIView *maskBackView;

@end

@implementation ESAlertPopBaseView

- (instancetype)initConfirmButton:(NSString *_Nullable)confirmTitle
                 cancelButton:(NSString *_Nullable)cancelTitle
                isShowCloseButton:(BOOL)isShowClose{
    
    if(self = [super init]){
        
        self.width = CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame) - 26.f * 2;
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15.f;
        self.clipsToBounds = YES;
        
        [self addSubview:self.confirmButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.closeButton];
        
        
        if([NSString isNotEmptyAndValid:confirmTitle]){
            
            self.confirmButton.hidden = NO;
            [self.confirmButton setTitle:confirmTitle forState:UIControlStateNormal];
            self.confirmButton.left = self.width - self.confirmButton.width - 30.f;
        }
        else {
            self.confirmButton.hidden = YES;
        }
        
        if([NSString isNotEmptyAndValid:cancelTitle]){
            
            self.cancelButton.hidden = NO;
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            self.cancelButton.left = 30.f;
        }
        else {
            self.cancelButton.hidden = YES;
        }
        
        if(isShowClose){
            
            self.closeButton.hidden = NO;
            self.closeButton.origin = CGPointMake(self.width - self.closeButton.width - 13.f, 13.f);
        }
        else {
            self.closeButton.hidden = YES;
        }
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

#pragma mark - Selector

- (void)tapGestureRecognizerAction:(id)sender{
    
    [self hide];
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
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if(!view){
        
        CGPoint newPoint = [self.closeButton convertPoint:point fromView:self];
        
        if(CGRectContainsPoint(self.closeButton.bounds, newPoint)){
            
            view = self.closeButton;
        }
    }
    
    return view;
}

#pragma mark - Getter
// universal_icon_close
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

- (UIButton *)closeButton{
    
    if(!_closeButton){
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:IMAGE_NAMED(@"universal_icon_close") forState:UIControlStateNormal];
        
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.size = CGSizeMake(32.f, 32.f);
    }
    
    return _closeButton;
}

- (UIButton *)confirmButton{
    
    if(!_confirmButton){
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.size = CGSizeMake(125.f, 33.f);
        
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_confirmButton setBackgroundImage:[HelpTools createImageWithColor:[UIColor eshopColor] withRect:_confirmButton.bounds] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[HelpTools createImageWithColor:[[UIColor eshopColor] colorWithAlphaComponent:0.5f] withRect:_confirmButton.bounds] forState:UIControlStateHighlighted];
        
        _confirmButton.titleLabel.font = FONT_SYSTEM(15.f);
        _confirmButton.layer.cornerRadius = 3.f;
        _confirmButton.clipsToBounds = YES;
        
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UIButton *)cancelButton{
    
    if(!_cancelButton){
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.size = CGSizeMake(125.f, 33.f);
        
        [_cancelButton setTitleColor:[UIColor eshopColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[[UIColor eshopColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_cancelButton setBackgroundImage:[HelpTools imageBlankWithOneWeightsBorderForSize:_cancelButton.size color:[UIColor eshopColor] corner:3.f] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[HelpTools imageBlankWithOneWeightsBorderForSize:_cancelButton.size color:[[UIColor eshopColor] colorWithAlphaComponent:0.5] corner:3.f] forState:UIControlStateHighlighted];
        
        _cancelButton.titleLabel.font = FONT_SYSTEM(15.f);
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}

@end
