//
//  AGUserHomeHeadView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGUserHomeHeadView.h"

static const CGFloat kUHHUserIconHeight = 70.f;

@interface AGUserHomeHeadView ()

@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UIImageView *mUserLevelImageView;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UILabel *mUserInfoLabel;
@property (strong, nonatomic) UILabel *mUserFansLabel;
@property (strong, nonatomic) UILabel *mUserFollowLabel;
@property (strong, nonatomic) UIButton *mFollowButton;

@end

@implementation AGUserHomeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mUserIconImageView];
        [self addSubview:self.mUserLevelImageView];
        [self addSubview:self.mUserFollowLabel];
        [self addSubview:self.mUserNameLabel];
        [self addSubview:self.mUserInfoLabel];
        [self addSubview:self.mUserFansLabel];
        [self addSubview:self.mFollowButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mUserIconImageView.origin = CGPointMake(15.f, 80.f - self.topOffsetY);
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.member.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mUserLevelImageView.centerX = self.mUserIconImageView.centerX;
    self.mUserLevelImageView.top = self.mUserIconImageView.bottom - self.mUserLevelImageView.height / 2.f;
    
    NSString *level = self.data.member.level;
    if([NSString isNotEmptyAndValid:level] &&
       [level integerValue] > 0) {
        self.mUserLevelImageView.hidden = NO;
        self.mUserLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", level]];
    }
    else {
        self.mUserLevelImageView.hidden = YES;
    }
    
    self.mFollowButton.left = self.width - self.mFollowButton.width - 15.f;
    self.mFollowButton.centerY = self.mUserIconImageView.centerY;
    /*
    if(self.data.attention) {
        
        [self.mFollowButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else {
        [self.mFollowButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    */
    
    self.mUserNameLabel.top = self.mUserIconImageView.top;
    self.mUserNameLabel.left = self.mUserIconImageView.right + 15.f;
    self.mUserNameLabel.width = self.mFollowButton.left - self.mUserIconImageView.right - 15.f * 2;
    self.mUserNameLabel.text = [NSString stringSafeChecking:self.data.member.nickname];
    
    self.mUserFollowLabel.text = [NSString stringWithFormat:@"%@关注", [HelpTools checkNumberInfo:self.data.focusCount]];
    [self.mUserFollowLabel sizeToFit];
    
    self.mUserFollowLabel.left = self.mUserNameLabel.left;
    
    self.mUserFansLabel.text = [NSString stringWithFormat:@"%@粉丝", [HelpTools checkNumberInfo:self.data.fansCount]];
    [self.mUserFansLabel sizeToFit];
    
    self.mUserFansLabel.left = self.mUserFollowLabel.right + 15.f;
    self.mUserFollowLabel.centerY = self.mUserFansLabel.centerY = self.mUserIconImageView.centerY;
    
    self.mUserInfoLabel.top = self.mUserIconImageView.bottom - self.mUserInfoLabel.height;
    self.mUserInfoLabel.left = self.mUserNameLabel.left;
    self.mUserInfoLabel.width = self.mUserNameLabel.width;
    self.mUserInfoLabel.text = [NSString stringSafeChecking:self.data.member.remark];
}

- (void)setData:(AGCircleMemberOtherData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark - Selector
- (void)followButtonAction:(UIButton *)button {
    
    if(self.didFollowedSelectedHandle) {
        
        self.didFollowedSelectedHandle(self.data.attention ? YES : NO);
    }
}

#pragma mark - Getter
- (CarouselImageView *)mUserIconImageView {
    
    if(!_mUserIconImageView) {
        
        _mUserIconImageView = [CarouselImageView new];
        _mUserIconImageView.size = CGSizeMake(kUHHUserIconHeight, kUHHUserIconHeight);
        _mUserIconImageView.layer.cornerRadius = _mUserIconImageView.height / 2.f;
        _mUserIconImageView.userInteractionEnabled = YES;
        _mUserIconImageView.clipsToBounds = YES;
        _mUserIconImageView.ignoreCache = YES;
    }
    
    return _mUserIconImageView;
}

- (UILabel *)mUserNameLabel {
    
    if(!_mUserNameLabel) {
        
        _mUserNameLabel = [UILabel new];
        _mUserNameLabel.font = [UIFont font18Bold];
        _mUserNameLabel.textColor = [UIColor whiteColor];
        
        _mUserNameLabel.height = _mUserNameLabel.font.lineHeight;
    }
    
    return _mUserNameLabel;
}

- (UILabel *)mUserInfoLabel {
    
    if(!_mUserInfoLabel) {
        
        _mUserInfoLabel = [UILabel new];
        _mUserInfoLabel.font = [UIFont font14];
        _mUserInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mUserInfoLabel.height = _mUserInfoLabel.font.lineHeight;
    }
    
    return _mUserInfoLabel;
}

- (UILabel *)mUserFansLabel {
    
    if(!_mUserFansLabel) {
        
        _mUserFansLabel = [UILabel new];
        _mUserFansLabel.font = [UIFont font14];
        _mUserFansLabel.textColor = [UIColor whiteColor];
        
        _mUserFansLabel.height = _mUserFansLabel.font.lineHeight;
    }
    
    return _mUserFansLabel;
}

- (UILabel *)mUserFollowLabel {
    
    if(!_mUserFollowLabel) {
        
        _mUserFollowLabel = [UILabel new];
        _mUserFollowLabel.font = [UIFont font14];
        _mUserFollowLabel.textColor = [UIColor whiteColor];
        
        _mUserFollowLabel.height = _mUserFollowLabel.font.lineHeight;
    }
    
    return _mUserFollowLabel;
}

- (UIImageView *)mUserLevelImageView {
    
    if(!_mUserLevelImageView) {
        
        _mUserLevelImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"user_level_1")];
    }
    
    return _mUserLevelImageView;
}

- (UIButton *)mFollowButton {
    
    if(!_mFollowButton) {
        /*
        _mFollowButton = [UIButton new];
        _mFollowButton.size = CGSizeMake(70.f, 32.f);
        _mFollowButton.layer.cornerRadius = 7.f;
        _mFollowButton.clipsToBounds = YES;
        
        [_mFollowButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mFollowButton.size colors:@[UIColorFromRGB(0x2BDD9A), UIColorFromRGB(0x36CBD1)] gradientType:1] forState:UIControlStateNormal];
        [_mFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mFollowButton setTitle:@"关注" forState:UIControlStateNormal];
        _mFollowButton.titleLabel.font = [UIFont font15];
         */
        _mFollowButton = [UIButton new];
        _mFollowButton.size = CGSizeMake(24.f, 24.f);
        
        [_mFollowButton setImage:IMAGE_NAMED(@"ag_list_dot_func_icon") forState:UIControlStateNormal];
        
        [_mFollowButton setTitleColor:UIColorFromRGB(0xF2FEFF) forState:UIControlStateNormal];
        [_mFollowButton setTitleColor:[UIColorFromRGB(0xF2FEFF) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [_mFollowButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        [_mFollowButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mFollowButton;
}

@end
