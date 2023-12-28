//
//  AGRechargeCollectionViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/7/19.
//

#import "AGRechargeCollectionViewCell.h"

@interface AGRechargeCollectionViewCell ()

@property (strong, nonatomic) UIImageView *mArrowImageView;
@property (strong, nonatomic) UIImageView *mIconImageView;
@property (strong, nonatomic) UILabel *mStaticBuyLabel;
@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UILabel *mNoticeLabel;
@property (strong, nonatomic) UILabel *mDetailLabel;
@property (strong, nonatomic) UILabel *mValueLabel;
@property (strong, nonatomic) UILabel *mPriceLabel;
@property (strong, nonatomic) UIView *mBottomView;

@end

@implementation AGRechargeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.contentView addSubview:self.mNoticeLabel];
        
        [self.mContainerView addSubview:self.mBottomView];
        [self.mContainerView addSubview:self.mIconImageView];
        [self.mContainerView addSubview:self.mValueLabel];
        [self.mBottomView addSubview:self.mPriceLabel];
        [self.mBottomView addSubview:self.mStaticBuyLabel];
        [self.mBottomView addSubview:self.mArrowImageView];
        [self.mContainerView addSubview:self.mDetailLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*
    NSString *noticeString = self.data.desc;
    self.mNoticeLabel.text = [NSString stringSafeChecking:noticeString];
    [self.mNoticeLabel sizeToFit];
    self.mNoticeLabel.height = self.mNoticeLabel.height + 6.f;
    
    if([NSString isNotEmptyAndValid:noticeString]) {
        
        self.mNoticeLabel.hidden = NO;
        self.mNoticeLabel.size = CGSizeMake(self.mNoticeLabel.width + 10.f, self.mNoticeLabel.height);
        self.mNoticeLabel.width = MIN(self.width, self.mNoticeLabel.width);
        
        self.mNoticeLabel.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mNoticeLabel.size colors:@[UIColorFromRGB(0xF5736E), UIColorFromRGB(0xDA7F51)] gradientType:1]];
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mNoticeLabel];
        
        self.mNoticeLabel.left = self.width - self.mNoticeLabel.width;
    }
    else {
        self.mNoticeLabel.hidden = YES;
    }
    */
    self.mNoticeLabel.hidden = YES;
    
    self.mContainerView.frame = CGRectMake(0.f, self.mNoticeLabel.height / 2.f, self.width, self.height - self.mNoticeLabel.height / 2.f);
    
    self.mBottomView.height = 34.f;
    self.mBottomView.frame = CGRectMake(0.f, self.mContainerView.height - self.mBottomView.height, self.mContainerView.width, self.mBottomView.height);
    self.mBottomView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mBottomView.size colors:@[UIColorFromRGB(0x36CAD2), UIColorFromRGB(0x29DF92)] gradientType:1]];
    
    self.mPriceLabel.text = [NSString stringWithFormat:@"￥%@", [NSString stringSafeChecking:self.data.price]];
    [self.mPriceLabel sizeToFit];
    self.mPriceLabel.left = (self.mBottomView.width / 2.f - self.mPriceLabel.width) / 2.f;
    
    CGFloat leftFixed = (self.mBottomView.width / 2.f - self.mStaticBuyLabel.width - self.mArrowImageView.width - 5.f) / 2.f;
    self.mStaticBuyLabel.left = self.mBottomView.width / 2.f + leftFixed;
    self.mArrowImageView.left = self.mStaticBuyLabel.right + 5.f;
    
    self.mPriceLabel.centerY = self.mStaticBuyLabel.centerY = self.mArrowImageView.centerY = self.mBottomView.height / 2.f;
    
    if(self.type == kChargeOrderListType_Diamond) {
        self.mIconImageView.image = IMAGE_NAMED(@"game_head_btn_gem");
        self.mValueLabel.text = [NSString stringWithFormat:@"%@钻石", [NSString stringSafeChecking:self.data.money]];
    }
    else {
        self.mIconImageView.image = IMAGE_NAMED(@"game_head_btn_gold");
        self.mValueLabel.text = [NSString stringWithFormat:@"%@金币", [NSString stringSafeChecking:self.data.money]];
    }
    [self.mValueLabel sizeToFit];
    
    CGFloat valueLeftFixed = (self.mBottomView.width - self.mValueLabel.width - self.mIconImageView.width - 5.f) / 2.f;
    self.mIconImageView.left = valueLeftFixed;
    self.mValueLabel.left = self.mIconImageView.right + 5.f;
    
    self.mDetailLabel.hidden = YES;
    if(self.type == kChargeOrderListType_Gold &&
       [NSString isNotEmptyAndValid:self.data.detail]) {
        
        self.mDetailLabel.hidden = NO;
        self.mDetailLabel.text = self.data.detail;
        [self.mDetailLabel sizeToFit];
        
        self.mDetailLabel.width = self.mContainerView.width - 3.f * 2;
        self.mDetailLabel.left = 3.f;
    }
    
    CGFloat valueOriginY = (self.mContainerView.height - self.mBottomView.height) / 2.f + 3.f;
    if(!self.mDetailLabel.hidden) {
        
        valueOriginY = (self.mContainerView.height - self.mBottomView.height - self.mDetailLabel.height - 8.f) / 2.f + 3.f;
    }
    
    self.mIconImageView.centerY = self.mValueLabel.centerY = valueOriginY;
    self.mDetailLabel.top = self.mValueLabel.bottom + 8.f;
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

- (UIImageView *)mIconImageView {
    
    if(!_mIconImageView) {
        
        _mIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_head_btn_gem")];
    }
    
    return _mIconImageView;
}

- (UILabel *)mValueLabel {
    
    if(!_mValueLabel) {
        
        _mValueLabel = [UILabel new];
        _mValueLabel.font = [UIFont font18];
        _mValueLabel.textColor = [UIColor whiteColor];
        _mValueLabel.height = _mValueLabel.font.lineHeight;
    }
    
    return _mValueLabel;
}

- (UILabel *)mPriceLabel {
    
    if(!_mPriceLabel) {
        
        _mPriceLabel = [UILabel new];
        _mPriceLabel.font = [UIFont font16];
        _mPriceLabel.textColor = [UIColor whiteColor];
        _mPriceLabel.height = _mPriceLabel.font.lineHeight;
    }
    
    return _mPriceLabel;
}

- (UILabel *)mStaticBuyLabel {
    
    if(!_mStaticBuyLabel) {
        
        _mStaticBuyLabel = [UILabel new];
        _mStaticBuyLabel.font = [UIFont font16];
        _mStaticBuyLabel.textColor = [UIColor whiteColor];
        _mStaticBuyLabel.text = @"去购买";
        [_mStaticBuyLabel sizeToFit];
    }
    
    return _mStaticBuyLabel;
}

- (UIImageView *)mArrowImageView {
    
    if(!_mArrowImageView) {
        
        _mArrowImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"ag_right_arrow_icon")];
    }
    
    return _mArrowImageView;
}

- (UILabel *)mNoticeLabel {
    
    if(!_mNoticeLabel) {
        
        _mNoticeLabel = [UILabel new];
        _mNoticeLabel.font = [UIFont font14];
        _mNoticeLabel.textColor = [UIColor whiteColor];
        _mNoticeLabel.textAlignment = NSTextAlignmentCenter;
        
        //#F5736E
        //#DA7F51
    }
    
    return _mNoticeLabel;
}

- (UILabel *)mDetailLabel {
    
    if(!_mDetailLabel) {
        
        _mDetailLabel = [UILabel new];
        _mDetailLabel.font = [UIFont font14];
        _mDetailLabel.textColor = [UIColor whiteColor];
        _mDetailLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _mDetailLabel;
}

- (UIView *)mBottomView {
    
    if(!_mBottomView) {
        
        _mBottomView = [UIView new];
    }
    
    return _mBottomView;
}

@end
