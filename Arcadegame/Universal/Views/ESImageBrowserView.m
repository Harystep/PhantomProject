
//
//  ESImageBrowserView.m
//  EShopClient
//
//  Created by Abner on 2019/6/10.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESImageBrowserView.h"
#import "CarouselPictureView.h"

@interface ESImageBrowserView () <CarouselPictureDelegate>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) CarouselPictureView *mCarouselPictureView;

@end

@implementation ESImageBrowserView

- (instancetype)init{
    
    if(self = [super init]){
        
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor blackColor000000Alpha08];
        
        [self addSubview:self.mCarouselPictureView];
        [self addSubview:self.closeButton];
        
        self.closeButton.origin = CGPointMake(15.f, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setImagesArray:(NSArray *)imagesArray withCurrentIndex:(NSInteger)index withCacheKey:(NSString *)cacheKey{
    
    self.mCarouselPictureView.cacheKey = cacheKey;
    self.mCarouselPictureView.currentPicIndex = index + 1;
    [self.mCarouselPictureView setPictureData:imagesArray];
}

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if(!newSuperview)
        return;
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    }];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [super removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

- (void)hide{
    
    [self removeFromSuperview];
}

#pragma mark -

- (void)shortTapPicture:(id)unitObject index:(NSInteger)index{
    
    [self hide];
}

#pragma mark - Selector

- (void)closeButtonAction:(UIButton *)button{
    
    [self hide];
}

#pragma mark - Getter

- (UIButton *)closeButton{
    
    if(!_closeButton){
        
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
        [_closeButton setImage:IMAGE_NAMED(@"bank_card_pop_close") forState:UIControlStateNormal];
        
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (CarouselPictureView *)mCarouselPictureView{
    
    if(!_mCarouselPictureView){
        
        _mCarouselPictureView = [[CarouselPictureView alloc] initWithFrame:self.bounds];
        _mCarouselPictureView.pageControlStyle = PAGECONTROL_STYLE_NUMBER;
        _mCarouselPictureView.ignoreCache = YES;
        _mCarouselPictureView.delegate = self;
        _mCarouselPictureView.carouselViewStyle = CAROUSELVIEW_STYLE_SCAN_AND_ZOMMING;
        _mCarouselPictureView.subscriptTextColor = [UIColor whiteColor];
        _mCarouselPictureView.scrollBarEdgeOff = ([HelpTools iPhoneNotchScreen] ? (kSafeAreaHeight + 6.f) : 6.f);
    }
    
    return _mCarouselPictureView;
}

@end
