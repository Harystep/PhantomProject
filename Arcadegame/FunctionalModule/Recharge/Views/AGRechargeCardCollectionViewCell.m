//
//  AGRechargeCardCollectionViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/8/15.
//

#import "AGRechargeCardCollectionViewCell.h"

@interface AGRechargeCardCollectionViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIView *mTopImageView;
@property (strong, nonatomic) UIButton *mPriceButton;
@property (strong, nonatomic) UILabel *mDetailLabel;
@property (strong, nonatomic) UILabel *mTitleLabel;
@property (strong, nonatomic) UILabel *mDescLabel;

@end

@implementation AGRechargeCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mTopImageView];
        
        [self.mTopImageView addSubview:self.mTitleLabel];
        [self.mTopImageView addSubview:self.mDescLabel];
        
        [self.mContainerView addSubview:self.mDetailLabel];
        [self.mContainerView addSubview:self.mPriceButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = self.bounds;
    CGFloat topImageViewWidth = self.mContainerView.width - 8.f * 2;
    self.mTopImageView.origin = CGPointMake(8.f, 8.f);
    self.mTopImageView.width = topImageViewWidth;
    self.mTopImageView.height = topImageViewWidth * 117.f / 154.f;
    // 154 * 117
    
    if([self.data.title isEqualToString:@"周卡"]) {
        
        self.mContainerView.backgroundColor = UIColorFromRGB(0x381F6A);
        self.mContainerView.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
        self.mDescLabel.textColor = UIColorFromRGB(0x603B86);
        
        self.mTopImageView.backgroundColor = [UIColor colorWithPatternImage:IMAGE_NAMED(@"charge_top_week")];
        [self.mPriceButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0x683DBA)] forState:UIControlStateNormal];
        [self.mPriceButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB_ALPHA(0x683DBA, 0.5f)] forState:UIControlStateHighlighted];
        self.mTitleLabel.textColor = UIColorFromRGB(0x603B86);
        self.mTitleLabel.text = @"周卡";
        [self.mTitleLabel sizeToFit];
    }
    else {
        self.mContainerView.backgroundColor = UIColorFromRGB(0xDD5C29);
        self.mContainerView.layer.borderColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.3] CGColor];
        self.mDescLabel.textColor = UIColorFromRGB(0xAC581C);
        
        self.mTopImageView.backgroundColor = [UIColor colorWithPatternImage:IMAGE_NAMED(@"charge_top_month")];
        [self.mPriceButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0x934813)] forState:UIControlStateNormal];
        [self.mPriceButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB_ALPHA(0x934813, 0.5f)] forState:UIControlStateHighlighted];
        self.mTitleLabel.textColor = UIColorFromRGB(0x934813);
        self.mTitleLabel.text = @"月卡";
        [self.mTitleLabel sizeToFit];
    }
    
    self.mTitleLabel.origin = CGPointMake(15.f, 22.f * (self.mTopImageView.height / 117.f));
    
    self.mDescLabel.text = [NSString stringSafeChecking:self.data.desc];
    
    self.mDescLabel.left = 5.f;
    self.mDescLabel.width = self.mTopImageView.width - self.mDescLabel.left * 2;
    self.mDescLabel.height = [self.mDescLabel sizeThatFits:CGSizeMake(self.mDescLabel.width, CGFLOAT_MAX)].height;
    
    CGFloat fixTop = 68.f * (self.mTopImageView.height / 117.f);
    self.mDescLabel.top = (self.mTopImageView.height - fixTop - self.mDescLabel.height) / 2.f + fixTop;
    
    [self.mPriceButton setTitle:[NSString stringWithFormat:@"￥%@", self.data.price] forState:UIControlStateNormal];
    self.mPriceButton.top = self.mContainerView.height - self.mPriceButton.height - 10.f;
    self.mPriceButton.centerX = self.mContainerView.width / 2.f;
    
    self.mDetailLabel.text = [NSString stringSafeChecking:self.data.detail];
    
    self.mDetailLabel.left = 5.f;
    self.mDetailLabel.width = self.mContainerView.width - self.mDetailLabel.left * 2;
    self.mDetailLabel.height = [self.mDetailLabel sizeThatFits:CGSizeMake(self.mDetailLabel.width, CGFLOAT_MAX)].height;
    self.mDetailLabel.top = (self.mPriceButton.top - self.mTopImageView.bottom - self.mDetailLabel.height) / 2.f + self.mTopImageView.bottom;
}

- (void)mPriceButtonAction:(UIButton *)button {
    
    if(self.didPriceButtonSelectedHandle) {
        
        self.didPriceButtonSelectedHandle(self.data);
    }
}

#pragma mark - Getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 20.f;
        _mContainerView.backgroundColor = UIColorFromRGB_ALPHA(0x2DDAA3, 0.1f);
        _mContainerView.layer.borderColor = [UIColorFromRGB(0x2BDC9D) CGColor];
        _mContainerView.layer.borderWidth = 1.f;
        _mContainerView.clipsToBounds = YES;
    }
    
    return _mContainerView;
}

- (UIView *)mTopImageView {
    
    if(!_mTopImageView) {
        
        _mTopImageView = [UIView new];
        _mTopImageView.userInteractionEnabled = YES;
    }
    
    return _mTopImageView;
}

- (UILabel *)mDetailLabel {
    
    if(!_mDetailLabel) {
        
        _mDetailLabel = [UILabel new];
        _mDetailLabel.font = [UIFont font14];
        _mDetailLabel.textColor = [UIColor whiteColor];
        _mDetailLabel.textAlignment = NSTextAlignmentCenter;
        _mDetailLabel.numberOfLines = 3;
    }
    
    return _mDetailLabel;
}

- (UILabel *)mDescLabel {
    
    if(!_mDescLabel) {
        
        _mDescLabel = [UILabel new];
        _mDescLabel.font = [UIFont font14];
        _mDescLabel.textAlignment = NSTextAlignmentCenter;
        _mDescLabel.numberOfLines = 2;
    }
    
    return _mDescLabel;
}

- (UILabel *)mTitleLabel {
    
    if(!_mTitleLabel) {
        
        _mTitleLabel = [UILabel new];
        _mTitleLabel.font = [UIFont font22Bold];
    }
    
    return _mTitleLabel;
}

- (UIButton *)mPriceButton {
    
    if(!_mPriceButton) {
        
        _mPriceButton = [UIButton new];
        _mPriceButton.size = CGSizeMake(115.f, 35.f);
        _mPriceButton.layer.cornerRadius = _mPriceButton.size.height / 2.f;
        _mPriceButton.clipsToBounds = YES;
        
        [_mPriceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mPriceButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [_mPriceButton.titleLabel setFont:[UIFont font18Bold]];
        
        [_mPriceButton addTarget:self action:@selector(mPriceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mPriceButton;
}

@end
