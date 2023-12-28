//
//  AGCircleCategoryTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import "AGCircleCategoryTableViewCell.h"

static const CGFloat kCCTCUserIconHeight = 52.f;
static const CGFloat kCCTCBottomButtonHeight = 38.f;
static const CGFloat kCCTCContentSingleImageHeight = 164.f;
static const NSInteger kCCTCContentImageBaseTag = 100;
NSInteger kTestContengtImageCount = 3;

@interface AGCircleCategoryTableViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIView *mContentImageContainerView;
@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UIImageView *mUserVIPIcon;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UILabel *mContentLabel;
@property (strong, nonatomic) UILabel *mTimeLabel;

@property (strong, nonatomic) UIButton *mCommentButton;
@property (strong, nonatomic) UIButton *mLikeButton;
@property (strong, nonatomic) UIButton *mSeeButton;

@end

@implementation AGCircleCategoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mContentImageContainerView];
        [self.mContainerView addSubview:self.mUserIconImageView];
        [self.mContainerView addSubview:self.mUserNameLabel];
        [self.mContainerView addSubview:self.mUserVIPIcon];
        [self.mContainerView addSubview:self.mTimeLabel];
        [self.mContainerView addSubview:self.mContentLabel];
        
        [self.mContainerView addSubview:self.mCommentButton];
        [self.mContainerView addSubview:self.mLikeButton];
        [self.mContainerView addSubview:self.mSeeButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 6.f, self.width - 12.f * 2, self.height - 6.f * 2);
    
    self.mUserIconImageView.origin = CGPointMake(12.f, 12.f);
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mUserNameLabel.text = @"娃娃机";
    [self.mUserNameLabel sizeToFit];
    
    CGFloat originFixedY = (self.mUserIconImageView.height - (self.mUserNameLabel.height + self.mTimeLabel.height + 3.f)) / 2;
    self.mUserNameLabel.origin = CGPointMake(self.mUserIconImageView.right + 5.f, self.mUserIconImageView.top + originFixedY);
    
    self.mTimeLabel.origin = CGPointMake(self.mUserNameLabel.left, self.mUserNameLabel.bottom + 3.f);
    self.mTimeLabel.width = self.mContainerView.width - self.mUserIconImageView.right - 12.f - 5.f;
    self.mTimeLabel.text = @"12312-123123-1231231";
    
    self.mUserNameLabel.width = self.mUserNameLabel.width > (self.mTimeLabel.width - self.mUserVIPIcon.width - 3.f) ? (self.mTimeLabel.width - self.mUserVIPIcon.width - 3.f) : self.mUserNameLabel.width;
    self.mUserVIPIcon.left = self.mUserNameLabel.right + 3.f;
    self.mUserVIPIcon.centerY = self.mUserNameLabel.centerY;
    
    NSString *level = @"1";
    if([NSString isNotEmptyAndValid:level] &&
       [level integerValue] > 0) {
        self.mUserVIPIcon.hidden = NO;
        self.mUserVIPIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", level]];
    }
    else {
        self.mUserVIPIcon.hidden = YES;
    }
    
    NSString *content = [NSString stringSafeChecking:self.data.Description];
    //@"阿斯利康大家阿喀琉斯打撒老大捡垃圾手打老大说啊山莨菪碱阿拉基收到啦受打击了a阿斯达红色打卡红烧鸡块登记好卡合计啊苏卡达花洒";
    self.mContentLabel.origin = CGPointMake(8.f, self.mUserIconImageView.bottom + 12.f);
    self.mContentLabel.width = self.mContainerView.width - 8.f * 2;
    self.mContentLabel.height = [HelpTools sizeWithString:content withShowSize:CGSizeMake(self.mContentLabel.width, MAXFLOAT) withFont:self.mContentLabel.font].height;
    self.mContentLabel.text = content;
    
    CGFloat originY = self.mContentLabel.bottom;
    NSInteger imageCount = self.indexPath.row > kTestContengtImageCount ? kTestContengtImageCount : self.indexPath.row;
    [self.mContentImageContainerView removeAllSubview];
    if(imageCount == 1) {
        
        CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCCTCContentImageBaseTag + 0)];
        if(!contentImage) {
            
            contentImage = [CarouselImageView new];
            contentImage.userInteractionEnabled = YES;
            contentImage.clipsToBounds = YES;
            contentImage.ignoreCache = YES;
            [self.mContentImageContainerView addSubview:contentImage];
            contentImage.tag = kCCTCContentImageBaseTag + 0;
        }
        contentImage.size = CGSizeMake(self.mContainerView.width - 8.f * 2, kCCTCContentSingleImageHeight);
        contentImage.origin = CGPointMake(8.f, 0.f);
        [contentImage setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:contentImage];
        
        self.mContentImageContainerView.frame = CGRectMake(0.f, originY + 12.f, self.mContainerView.width, kCCTCContentSingleImageHeight);
        originY = self.mContentImageContainerView.bottom;
    }
    else if(imageCount == 2) {
        
        CGFloat subOriginX = 8.f;
        CGFloat contentImageWidth = (self.mContainerView.width - 8.f - 8.f * 2) / 2;
        for (int i = 0; i < imageCount; ++i) {
            
            CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCCTCContentImageBaseTag + i)];
            if(!contentImage) {
                
                contentImage = [CarouselImageView new];
                contentImage.userInteractionEnabled = YES;
                contentImage.clipsToBounds = YES;
                contentImage.ignoreCache = YES;
                [self.mContentImageContainerView addSubview:contentImage];
                contentImage.tag = kCCTCContentImageBaseTag + i;
            }
            contentImage.size = CGSizeMake(contentImageWidth, contentImageWidth);
            contentImage.origin = CGPointMake(subOriginX, 0.f);
            [contentImage setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
            subOriginX = contentImage.right + 8.f;
            
            UIRectCorner rectCorner;
            if(i == 0) {
                
                rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            }
            else {
                rectCorner = UIRectCornerTopRight | UIRectCornerBottomRight;
            }
            [HelpTools addRoundedCorners:rectCorner withRadii:CGSizeMake(10.f, 10.f) forView:contentImage];
        }
        
        self.mContentImageContainerView.frame = CGRectMake(0.f, originY + 12.f, self.mContainerView.width, contentImageWidth);
        originY = self.mContentImageContainerView.bottom;
    }
    else if(imageCount == 3) {
        
        CGFloat subOriginX = 8.f;
        CGFloat subOriginY = 0.f;
        CGFloat contentImageWidth = (self.mContainerView.width - 8.f * 2 - 3.f - 6.f) / 3.f * 2.f + 3.f;
        CGFloat littleContentImageWidth = (self.mContainerView.width - 8.f * 2 - contentImageWidth - 6.f);
        
        for (int i = 0; i < imageCount; ++i) {
            
            CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCCTCContentImageBaseTag + i)];
            if(!contentImage) {
                
                contentImage = [CarouselImageView new];
                contentImage.userInteractionEnabled = YES;
                contentImage.clipsToBounds = YES;
                contentImage.ignoreCache = YES;
                [self.mContentImageContainerView addSubview:contentImage];
                contentImage.tag = kCCTCContentImageBaseTag + i;
            }
            
            contentImage.size = CGSizeMake((i == 0 ? contentImageWidth : littleContentImageWidth), (i == 0 ? contentImageWidth : littleContentImageWidth));
            contentImage.origin = CGPointMake(subOriginX, subOriginY);
            [contentImage setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
            
            subOriginX = (i % 3 == 0) ? (contentImage.right + 6.f) : subOriginX;
            subOriginY = (i % 3 == 0) ? subOriginY : (contentImage.bottom + 3.f);
            
            UIRectCorner rectCorner;
            if(i == 0) {
                
                rectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            }
            else if(i == 1){
                rectCorner = UIRectCornerTopRight;
            }
            else {
                rectCorner = UIRectCornerBottomRight;
            }
            [HelpTools addRoundedCorners:rectCorner withRadii:CGSizeMake(10.f, 10.f) forView:contentImage];
            
            if(i == (imageCount - 1)) {
                
                subOriginY = contentImage.bottom;
            }
        }
        self.mContentImageContainerView.frame = CGRectMake(0.f, originY + 12.f, self.mContainerView.width, contentImageWidth);
        originY = self.mContentImageContainerView.bottom;
    }
    
    self.mCommentButton.origin = CGPointMake(8.f, originY + 12.f);
    self.mLikeButton.centerX = self.mContainerView.width / 2.f;
    self.mSeeButton.left = self.mContainerView.width - self.mSeeButton.width - 8.f;
    self.mLikeButton.centerY = self.mSeeButton.centerY = self.mCommentButton.centerY;
}

- (void)setData:(AGCircleHotData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark -
+ (CGFloat)getAGCircleCategoryTableViewCellHeight:(AGCircleHotData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index{
    
    CGFloat cellHeight = 6.f * 2 + 12.f + kCCTCUserIconHeight + 12.f + kCCTCBottomButtonHeight + 12.f;
    
    NSString *content = data.Description;
    //@"阿斯利康大家阿喀琉斯打撒老大捡垃圾手打老大说啊山莨菪碱阿拉基收到啦受打击了a阿斯达红色打卡红烧鸡块登记好卡合计啊苏卡达花洒";
    CGFloat contentHeight = [HelpTools sizeWithString:content withShowSize:CGSizeMake((containerWidth - 20.f * 2), MAXFLOAT) withFont:[UIFont font14]].height;
    cellHeight += (12.f + contentHeight);
    
    NSInteger imageCount = index.row > kTestContengtImageCount ? kTestContengtImageCount : index.row;
    if(imageCount == 1) {
        
        cellHeight += (12.f + kCCTCContentSingleImageHeight);
    }
    else if(imageCount == 2) {
        
        CGFloat contentImageHeight = (containerWidth - 20.f * 2 - 8.f) / 2;
        cellHeight += (12.f + contentImageHeight);
    }
    else if(imageCount == 3) {
        
        CGFloat contentImageHeight = (containerWidth - 20.f * 2 - 3.f - 6.f) / 3.f * 2.f + 3.f;
        cellHeight += (12.f + contentImageHeight);
    }
    
    return cellHeight;
}

#pragma mark - getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 20.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x1D2332);
        //#1B2233
        //#121621
    }
    
    return _mContainerView;
}

- (UIView *)mContentImageContainerView {
    
    if(!_mContentImageContainerView) {
        
        _mContentImageContainerView = [UIView new];
        _mContentImageContainerView.backgroundColor = [UIColor clearColor];
    }
    
    return _mContentImageContainerView;
}

- (CarouselImageView *)mUserIconImageView {
    
    if(!_mUserIconImageView) {
        
        _mUserIconImageView = [CarouselImageView new];
        _mUserIconImageView.size = CGSizeMake(kCCTCUserIconHeight, kCCTCUserIconHeight);
        _mUserIconImageView.layer.cornerRadius = _mUserIconImageView.height / 2.f;
        _mUserIconImageView.userInteractionEnabled = YES;
        _mUserIconImageView.clipsToBounds = YES;
        _mUserIconImageView.ignoreCache = YES;
        
        _mUserIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mUserIconImageView.layer.borderWidth = 2.f;
    }
    
    return _mUserIconImageView;
}

- (UILabel *)mUserNameLabel {
    
    if(!_mUserNameLabel) {
        
        _mUserNameLabel = [UILabel new];
        _mUserNameLabel.font = [UIFont font15Bold];
        _mUserNameLabel.textColor = [UIColor whiteColor];
        
        _mUserNameLabel.height = _mUserNameLabel.font.lineHeight;
    }
    
    return _mUserNameLabel;
}

- (UILabel *)mTimeLabel {
    
    if(!_mTimeLabel) {
        
        _mTimeLabel = [UILabel new];
        _mTimeLabel.font = [UIFont font14];
        _mTimeLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mTimeLabel.height = _mTimeLabel.font.lineHeight;
    }
    
    return _mTimeLabel;
}

- (UIImageView *)mUserVIPIcon {
    
    if(!_mUserVIPIcon) {
        
        _mUserVIPIcon = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"user_level_1")];
    }
    
    return _mUserVIPIcon;
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

- (UIButton *)mCommentButton {
    
    if(!_mCommentButton) {
        
        _mCommentButton = [self getCustomButtonWithImage:@"circle_category_comment_icon"];
    }
    
    return _mCommentButton;
}

- (UIButton *)mLikeButton {
    
    if(!_mLikeButton) {
        
        _mLikeButton = [self getCustomButtonWithImage:@"circle_category_like_icon"];
    }
    
    return _mLikeButton;
}

- (UIButton *)mSeeButton {
    
    if(!_mSeeButton) {
        
        _mSeeButton = [self getCustomButtonWithImage:@"circle_category_comment_icon"];
    }
    
    return _mSeeButton;
}

- (UIButton *)getCustomButtonWithImage:(NSString *)image {
     
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x3C4663);
    button.size = CGSizeMake(105.f, kCCTCBottomButtonHeight);
    button.layer.cornerRadius = 10.f;
    
    [button setImage:IMAGE_NAMED(image) forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [button setTitle:@"9999" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont font14];
    
    return button;
}

@end
