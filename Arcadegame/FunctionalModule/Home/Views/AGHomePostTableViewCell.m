//
//  AGHomePostTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/16.
//

#import "AGHomePostTableViewCell.h"

@interface AGHomePostTableViewCell ()

@property (strong, nonatomic) UIView *mBackGroundView;
@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIView *mImageContainerView;
@property (strong, nonatomic) CarouselImageView *mImageView;
@property (strong, nonatomic) UILabel *mInfoLabel;
@property (strong, nonatomic) UIImageView *mMsgIconImageView;
@property (strong, nonatomic) UILabel *mMsgNumLabel;
@property (strong, nonatomic) UIImageView *mLikeIconImageView;
@property (strong, nonatomic) UILabel *mLikeNumLabel;
@property (strong, nonatomic) UILabel *mMarkLabel;

@end

@implementation AGHomePostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mBackGroundView];
        [self.mBackGroundView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mInfoLabel];
        [self.mContainerView addSubview:self.mMsgIconImageView];
        [self.mContainerView addSubview:self.mMsgNumLabel];
        [self.mContainerView addSubview:self.mLikeIconImageView];
        [self.mContainerView addSubview:self.mLikeNumLabel];
        [self.mContainerView addSubview:self.mMarkLabel];
        
        [self.mBackGroundView addSubview:self.mImageContainerView];
        [self.mImageContainerView addSubview:self.mImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mBackGroundView.frame = self.bounds;
    self.mBackGroundView.left = 12.f;
    self.mBackGroundView.width -= self.mBackGroundView.left * 2;
    
    if(self.corner == KHomePostTableViewCorner_top) {
        
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else if(self.corner == KHomePostTableViewCorner_Bottom){
        
        [HelpTools addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else if(self.corner == KHomePostTableViewCorner_All) {
        
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else {
        self.mBackGroundView.layer.mask = nil;
    }
    
    NSArray *mediaArray = [self.mData.media componentsSeparatedByString:@";"];
    
    self.mImageContainerView.frame = CGRectMake(12.f, 12.f, self.mBackGroundView.height - 12.f * 2, self.mBackGroundView.height - 12.f - 18.f);
    self.mImageView.frame = CGRectMake(5.f, 5.f, self.mImageContainerView.width - 5.f * 2, self.mImageContainerView.height - 5.f * 2);
    [self.mImageView setImageWithObject:[NSString stringSafeChecking:(mediaArray ? mediaArray.firstObject : @"")] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mContainerView.left = self.mImageContainerView.left + 25.f;
    self.mContainerView.width = self.mBackGroundView.width - self.mContainerView.left - 8.f;
    self.mContainerView.top = 39.f;
    self.mContainerView.height = self.mBackGroundView.height - self.mContainerView.top - 8.f;
    
    CGFloat referOrignX = self.mImageContainerView.width - 25.f;
    CGFloat referOrignY = (self.mContainerView.height - self.mInfoLabel.height - self.mMsgIconImageView.height - self.mLikeNumLabel.height - (6.f + 8.f)) / 2.f;
    
    self.mInfoLabel.text = [NSString stringSafeChecking:self.mData.title];
    self.mInfoLabel.left = referOrignX + 7.f;
    self.mInfoLabel.width = self.mContainerView.width - self.mInfoLabel.left - 7.f;
    self.mInfoLabel.top = referOrignY;
    
    self.mMsgIconImageView.origin = CGPointMake(self.mInfoLabel.left, self.mInfoLabel.bottom + 6.f);
    self.mMsgNumLabel.left = self.mMsgIconImageView.right + 2.f;
    self.mLikeIconImageView.left = self.mMsgNumLabel.right + 18.f;
    self.mLikeNumLabel.left = self.mLikeIconImageView.right + 2.f;
    
    self.mMsgNumLabel.text = [NSString stringSafeChecking:self.mData.commentNum];
    self.mLikeNumLabel.text = [NSString stringSafeChecking:self.mData.likeNum];
    
    self.mMsgNumLabel.centerY =  self.mLikeNumLabel.centerY = self.mLikeIconImageView.centerY = self.mMsgIconImageView.centerY;
    
    self.mMarkLabel.origin = CGPointMake(self.mInfoLabel.left, self.mMsgIconImageView.bottom + 8.f);
    if([NSString isNotEmptyAndValid:self.mData.discussList]) {
        
        self.mMarkLabel.hidden = NO;
        self.mMarkLabel.text = [NSString stringWithFormat:@"#%@", self.mData.discussList];
    }
    else {
        self.mMarkLabel.hidden = YES;
    }
}

#pragma mark - Getter
- (UIView *)mBackGroundView {
    
    if(!_mBackGroundView) {
        
        _mBackGroundView = [UIView new];
        _mBackGroundView.backgroundColor = UIColorFromRGB(0x2D354E);
    }
    
    return _mBackGroundView;
}

- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 10.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x1D2332);
    }
    
    return _mContainerView;
}

- (UIView *)mImageContainerView {
    
    if(!_mImageContainerView) {
        
        _mImageContainerView = [UIView new];
        _mImageContainerView.layer.cornerRadius = 10.f;
        _mImageContainerView.backgroundColor = UIColorFromRGB(0x486675);
    }
    
    return _mImageContainerView;
}

- (CarouselImageView *)mImageView {
    
    if(!_mImageView) {
        
        _mImageView = [CarouselImageView new];
        _mImageView.layer.cornerRadius = 10.f;
        _mImageView.userInteractionEnabled = YES;
        _mImageView.clipsToBounds = YES;
        _mImageView.ignoreCache = YES;
    }
    
    return _mImageView;
}

- (UILabel *)mInfoLabel {
    
    if(!_mInfoLabel) {
        
        _mInfoLabel = [UILabel new];
        _mInfoLabel.font = [UIFont font15];
        _mInfoLabel.textColor = [UIColor whiteColor];
        _mInfoLabel.numberOfLines = 2;
        
        _mInfoLabel.height = _mInfoLabel.font.lineHeight * 2 + _mInfoLabel.font.leading;
    }
    
    return _mInfoLabel;
}

- (UIImageView *)mMsgIconImageView {
    
    if(!_mMsgIconImageView) {
        
        _mMsgIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"home_com")];
    }
    
    return _mMsgIconImageView;
}

- (UILabel *)mMsgNumLabel {
    
    if(!_mMsgNumLabel) {
        
        _mMsgNumLabel = [UILabel new];
        _mMsgNumLabel.font = [UIFont font14];
        _mMsgNumLabel.textColor = [UIColor whiteColor];
        _mMsgNumLabel.text = @"999";
        [_mMsgNumLabel sizeToFit];
    }
    
    return _mMsgNumLabel;
}

- (UIImageView *)mLikeIconImageView {
    
    if(!_mLikeIconImageView) {
        
        _mLikeIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"home_like")];
    }
    
    return _mLikeIconImageView;
}

- (UILabel *)mLikeNumLabel {
    
    if(!_mLikeNumLabel) {
        
        _mLikeNumLabel = [UILabel new];
        _mLikeNumLabel.font = [UIFont font14];
        _mLikeNumLabel.textColor = [UIColor whiteColor];
        _mLikeNumLabel.text = @"999";
        [_mLikeNumLabel sizeToFit];
    }
    
    return _mLikeNumLabel;
}

- (UILabel *)mMarkLabel {
    
    if(!_mMarkLabel) {
        
        _mMarkLabel = [UILabel new];
        _mMarkLabel.font = [UIFont font14];
        _mMarkLabel.textColor = [UIColor whiteColor];
        _mMarkLabel.textAlignment = NSTextAlignmentCenter;
        
        _mMarkLabel.clipsToBounds = YES;
        _mMarkLabel.size = CGSizeMake(74.f, 26.f);
        _mMarkLabel.layer.cornerRadius = 5.f;
        _mMarkLabel.layer.borderWidth = 1.f;
        _mMarkLabel.layer.borderColor = UIColorFromRGB(0x3CE2CE).CGColor;
        _mMarkLabel.backgroundColor = UIColorFromRGB_ALPHA(0x3CE3C9, 0.22f);
    }
    
    return _mMarkLabel;
}

@end
