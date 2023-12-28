//
//  AGCircleSingleCategoryHeadView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCircleSingleCategoryHeadView.h"

static const CGFloat kCSCHUserIconHeight = 61.f;

@interface AGCircleSingleCategoryHeadView ()

@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UILabel *mUserInfoLabel;
@property (strong, nonatomic) UILabel *mContentLabel;

@property (strong, nonatomic) CarouselImageView *mUserHeadImageView1;
@property (strong, nonatomic) CarouselImageView *mUserHeadImageView2;
@property (strong, nonatomic) UIView *mUserHeadContainerView;
@property (strong, nonatomic) UILabel *mHeadCircleInfoLabel;
@property (strong, nonatomic) UIButton *mFollowButton;

@end

@implementation AGCircleSingleCategoryHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mUserIconImageView];
        [self addSubview:self.mUserNameLabel];
        [self addSubview:self.mUserInfoLabel];
        [self addSubview:self.mContentLabel];
        [self addSubview:self.mFollowButton];
        
        [self addSubview:self.mUserHeadContainerView];
        [self.mUserHeadContainerView addSubview:self.mUserHeadImageView1];
        [self.mUserHeadContainerView addSubview:self.mUserHeadImageView2];
        [self.mUserHeadContainerView addSubview:self.mHeadCircleInfoLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mUserIconImageView.origin = CGPointMake(20.f, 19.f);
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.coverImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mFollowButton.left = self.width - self.mFollowButton.width - 15.f;
    self.mFollowButton.centerY = self.mUserIconImageView.centerY;
    
    [self.mFollowButton setTitle:(self.data.hasFocus ? @"取消关注" : @"关注") forState:UIControlStateNormal];
    
    self.mUserNameLabel.text = [NSString stringSafeChecking:self.data.name];
    self.mUserNameLabel.width = self.width - self.mUserIconImageView.right - 12.f - 5.f;
    
    CGFloat originFixedY = (self.mUserIconImageView.height - (self.mUserNameLabel.height + self.mUserInfoLabel.height + 3.f)) / 2;
    self.mUserNameLabel.origin = CGPointMake(self.mUserIconImageView.right + 5.f, self.mUserIconImageView.top + originFixedY);
    
    self.mUserInfoLabel.origin = CGPointMake(self.mUserNameLabel.left, self.mUserNameLabel.bottom + 3.f);
    self.mUserInfoLabel.text = [NSString stringSafeChecking:self.data.updateTime];
    self.mUserInfoLabel.width = self.mUserNameLabel.width;
    
    self.mUserHeadImageView1.hidden = self.mUserHeadImageView2.hidden = YES;
    
//    self.data.followImages = @[@"https://t7.baidu.com/it/u=3332251293,4211134448&fm=193&f=GIF", @"https://t7.baidu.com/it/u=3332251293,4211134448&fm=193&f=GIF"];
    if(self.data.followImages && self.data.followImages.count) {
        
        NSString *userImage1 = [self.data.followImages objectAtIndexForSafe:0];
        NSString *userImage2 = [self.data.followImages objectAtIndexForSafe:1];
        
        if([NSString isNotEmptyAndValid:userImage1]) {
            
            self.mUserHeadImageView1.hidden = NO;
            [self.mUserHeadImageView1 setImageWithObject:userImage1 withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        }
        
        if([NSString isNotEmptyAndValid:userImage2]) {
            
            self.mUserHeadImageView2.hidden = NO;
            [self.mUserHeadImageView2 setImageWithObject:userImage1 withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        }
    }
    
    self.mUserHeadImageView1.left = 3.f;
    self.mUserHeadImageView2.left = self.mUserHeadImageView1.right - self.mUserHeadImageView1.width / 4.f;
    
    CGFloat ciOriginX = self.mUserHeadImageView2.right + 5.f;
    if(self.mUserHeadImageView1.hidden) {
        
        ciOriginX = 3.f;
    }
    else if(self.mUserHeadImageView2.hidden) {
        
        ciOriginX = self.mUserHeadImageView1.right + 5.f;
    }
    
    self.mHeadCircleInfoLabel.left = ciOriginX;
    self.mHeadCircleInfoLabel.text = [HelpTools checkCircleInfo:self.data.userNum];
    [self.mHeadCircleInfoLabel sizeToFit];
    
    CGFloat referWidth = self.width - self.mUserHeadImageView2.right - 12.f - 5.f;
    self.mHeadCircleInfoLabel.width = (self.mHeadCircleInfoLabel.width > referWidth) ? referWidth : self.mHeadCircleInfoLabel.width;
    
    self.mUserHeadContainerView.frame = CGRectMake(self.mUserIconImageView.left, self.height - 37.f - 27.f, self.mHeadCircleInfoLabel.right + 5.f, 27.f);
    if(self.mUserHeadImageView1.hidden && self.mUserHeadImageView2.hidden && self.mHeadCircleInfoLabel.width == 0.f) {
        
        self.mUserHeadContainerView.width = 0.f;
    }
    
    self.mUserHeadImageView1.centerY = self.mUserHeadImageView2.centerY = self.mHeadCircleInfoLabel.centerY = self.mUserHeadContainerView.height / 2.f;
    
    self.mContentLabel.attributedText = [AGCircleSingleCategoryHeadView checkContentString:self.data.Description];
    //self.mContentLabel.text = [NSString stringSafeChecking:self.data.Description];
    self.mContentLabel.frame = CGRectMake(self.mUserIconImageView.left, self.mUserIconImageView.bottom + 10.f, self.width - self.mUserIconImageView.left * 2, ((self.mUserHeadContainerView.width == 0.f) ? (self.height - 27.f) : self.mUserHeadContainerView.top) - self.mUserIconImageView.bottom - 10.f * 2);
}

- (void)setData:(AGCicleHomeOtherDtoData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

+ (NSMutableAttributedString*)checkContentString:(NSString*)string {
    if(![NSString isNotEmptyAndValid:string]) {
        
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setLineSpacing:4.5];
        
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont font14]}];
    
    return attributedString;
}

#pragma mark - Selector
- (void)followButtonAction:(UIButton *)button {
    
    if(self.didFollowSelectedHandle) {
        
        self.didFollowSelectedHandle(self.data.hasFocus ? YES : NO);
    }
}

#pragma mark - Getter
- (CarouselImageView *)mUserIconImageView {
    
    if(!_mUserIconImageView) {
        
        _mUserIconImageView = [CarouselImageView new];
        _mUserIconImageView.size = CGSizeMake(kCSCHUserIconHeight, kCSCHUserIconHeight);
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
        _mUserNameLabel.font = [UIFont font16Bold];
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

- (UILabel *)mContentLabel {
    
    if(!_mContentLabel) {
        
        _mContentLabel = [UILabel new];
        _mContentLabel.font = [UIFont font14];
        _mContentLabel.textColor = [UIColor whiteColor];
        _mContentLabel.numberOfLines = 0;
    }
    
    return _mContentLabel;
}

- (UILabel *)mHeadCircleInfoLabel {
    
    if(!_mHeadCircleInfoLabel) {
        _mHeadCircleInfoLabel = [UILabel new];
        _mHeadCircleInfoLabel.font = [UIFont font14];
        _mHeadCircleInfoLabel.textColor = UIColorFromRGB(0xF2FEFF);
        _mHeadCircleInfoLabel.height = _mHeadCircleInfoLabel.font.lineHeight;
    }
    
    return _mHeadCircleInfoLabel;
}

- (CarouselImageView *)mUserHeadImageView1 {
    
    if(!_mUserHeadImageView1) {
        
        _mUserHeadImageView1 = [CarouselImageView new];
        _mUserHeadImageView1.size = CGSizeMake(14.f, 14.f);
        _mUserHeadImageView1.layer.cornerRadius = _mUserHeadImageView1.height / 2.f;
        _mUserHeadImageView1.clipsToBounds = YES;
        _mUserHeadImageView1.ignoreCache = YES;
    }
    
    return _mUserHeadImageView1;
}

- (CarouselImageView *)mUserHeadImageView2 {
    
    if(!_mUserHeadImageView2) {
        
        _mUserHeadImageView2 = [CarouselImageView new];
        _mUserHeadImageView2.size = CGSizeMake(14.f, 14.f);
        _mUserHeadImageView2.layer.cornerRadius = _mUserHeadImageView2.height / 2.f;
        _mUserHeadImageView2.clipsToBounds = YES;
        _mUserHeadImageView2.ignoreCache = YES;
    }
    
    return _mUserHeadImageView2;
}

- (UIView *)mUserHeadContainerView {
    
    if(!_mUserHeadContainerView) {
        
        _mUserHeadContainerView = [UIView new];
        _mUserHeadContainerView.layer.cornerRadius = 5.f;
        _mUserHeadContainerView.backgroundColor = UIColorFromRGB_ALPHA(0x3CE3C9, 0.22f);
        _mUserHeadContainerView.layer.borderColor = UIColorFromRGB(0x3CE2CE).CGColor;
        _mUserHeadContainerView.layer.borderWidth = 1.f;
    }
    
    return _mUserHeadContainerView;
}

- (UIButton *)mFollowButton {
    
    if(!_mFollowButton) {
        
        _mFollowButton = [UIButton new];
        _mFollowButton.size = CGSizeMake(70.f, 32.f);
        _mFollowButton.layer.cornerRadius = 7.f;
        _mFollowButton.clipsToBounds = YES;
        
        [_mFollowButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mFollowButton.size colors:@[UIColorFromRGB(0x2BDD9A), UIColorFromRGB(0x36CBD1)] gradientType:1] forState:UIControlStateNormal];
        [_mFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mFollowButton setTitle:@"关注" forState:UIControlStateNormal];
        _mFollowButton.titleLabel.font = [UIFont font15];
        
        [_mFollowButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mFollowButton;
}

@end
