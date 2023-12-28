//
//  ESPopBaseView.m
//  EShopClient
//
//  Created by Abner on 2019/5/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESPopBaseView.h"

@interface ESPopBaseView ()

@property (nonatomic, strong) UIView *maskBackView;

@end

@implementation ESPopBaseView

- (instancetype)init{
    
    if(self = [super init]){
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), 500.f);
        self.backgroundColor = [UIColor whiteColor];
        
        if([HelpTools iPhoneNotchScreen]) {
            
            CGRect rect = self.frame;
            rect.size.height +=  kSafeAreaHeight;
            
            self.frame = rect;
        }
        
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.f, 10.f) forView:self];
        
        self.closeButton.frame = ({
            CGRect rect = self.closeButton.frame;
            rect.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(self.closeButton.frame);
            rect;
        });
        [self addSubview:self.closeButton];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if(!newSuperview)
        return;
    
    __block CGRect popRect = self.frame;
    popRect.origin.y = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds);
    
    self.frame = popRect;
    self.maskBackView.alpha = 0.f;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        popRect.origin.y = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds) - CGRectGetHeight(popRect);
        
        self.frame = popRect;
        self.maskBackView.alpha = 0.3f;
        
    }];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    
    CGRect popRect = self.frame;
    popRect.origin.y = CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = popRect;
        self.maskBackView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.maskBackView removeFromSuperview];
        [super removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
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

- (UIButton *)closeButton{
    
    if(!_closeButton){
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:IMAGE_NAMED(@"universal_icon_close") forState:UIControlStateNormal];
        //[_closeButton setImage:IMAGE_NAMED(@"btn_close_pressed") forState:UIControlStateHighlighted];
        
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.size = CGSizeMake(42.f, 42.f);
    }
    
    return _closeButton;
}

@end
