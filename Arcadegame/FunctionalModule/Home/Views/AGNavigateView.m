//
//  AGNavigateView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGNavigateView.h"

static const NSInteger kAGNavigateButtonBaseTag = 1000;

@interface AGNavigateView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *leftButton;
@property (nonatomic, strong) UIView *contentBackView;

@end

@implementation AGNavigateView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.shouldChangeStatusStyle = YES;
        
        [self addSubview:self.contentBackView];
        [self.contentBackView addSubview:self.leftButton];
        [self.contentBackView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentBackView.frame = self.bounds;
    
    self.leftButton.origin = CGPointMake(15.f, CGRectGetHeight([HelpTools statusBarFrame]) + (kNaviBarHeight - self.leftButton.height) / 2.f);
    
    self.titleLabel.frame = CGRectMake(self.leftButton.right + 10.f, CGRectGetHeight([HelpTools statusBarFrame]) + (kNaviBarHeight - self.titleLabel.font.lineHeight) / 2.f, self.contentBackView.width - (self.leftButton.right + 10.f) * 2.f, self.titleLabel.font.lineHeight);
}

- (void)agNavigateViewDidScrollOffsetY:(CGFloat)scrollOffsetY {
    
    if(scrollOffsetY > 0){
        
        CGFloat alpha = scrollOffsetY / self.height;
        if(alpha > 0.5){
            /*
            if(@available(iOS 13.0, *)){
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
            }
            else {
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
             */
            self.shouldChangeStatusStyle = NO;
        }
        else {
            /*
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
             */
            self.shouldChangeStatusStyle = YES;
        }
        
        self.contentBackView.alpha = scrollOffsetY / self.height;
    }
    else {
        self.shouldChangeStatusStyle = YES;
        self.contentBackView.alpha = 0.f;
    }
}

- (void)setNaviLeftWithImages:(NSArray<NSString *> *)images andHighImages:(NSArray<NSString *> *)highImages {
    
//    if(!images || !highImages ||
//       images.count != highImages.count) { return; }
//
//    CGFloat buttonHeight = kNaviBarHeight -  10.f;
//
//    for (int i = 0; i < images.count; ++i) {
//
//        UIImage *image = IMAGE_NAMED(images[i]);
//        //UIImage *highImage = IMAGE_NAMED(highImages[i]);
//
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, kNaviBarHeight*(image.size.width/image.size.height), buttonHeight);
//        [button setImage:image forState:UIControlStateNormal];
//
//        [button addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
//
//    }
}

- (void)setAGLeftNaviButtonHide:(BOOL)isHide {
    
    self.leftButton.hidden = isHide;
}

- (void)setAGNaviTitle:(NSString *)title {
    
    self.titleLabel.text = title;
    [self setNeedsLayout];
}

- (CGFloat)fixedTop {
    
    return [HelpTools statusBarFrame].size.height;
}

- (CGFloat)fixedHeight {
    
    return self.height - [HelpTools statusBarFrame].size.height;
}

#pragma mark - Selector
- (void)leftButtonAction:(UIButton *)button {
    
    if(self.navigateLeftDidSelected) {
        
        self.navigateLeftDidSelected();
    }
}

#pragma mark - Getter
- (UIView *)contentBackView{
    
    if(!_contentBackView){
        
        _contentBackView = [UIView new];
        _contentBackView.backgroundColor = [UIColor clearColor];
    }
    
    return _contentBackView;
}

- (UIButton *)leftButton {
    
    if(!_leftButton) {
        
        CGFloat buttonHeight = kNaviBarHeight -  10.f;
        UIImage *image = IMAGE_NAMED(@"navi_back_normal");
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, buttonHeight*(image.size.width/image.size.height), buttonHeight);
        [_leftButton setImage:image forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}

- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font18Bold];
        _titleLabel.textColor = UIColorFromRGB(0xF2FEFF);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

@end
