//
//  AGCircleTableViewCellNew.m
//  Arcadegame
//
//  Created by Abner on 2023/9/25.
//

#import "AGCircleTableViewCellNew.h"

static const CGFloat kCTCUserIconHeight = 52.f;
static const CGFloat kCTCBottomButtonHeight = 26.f;
static const CGFloat kCTCContentSingleImageHeight = 164.f;
static const NSInteger kCTCContentImageBaseTag = 100;
static const CGFloat kCTCMarkMinHeight = 26.f;
static const CGFloat kCTCMarkMinWidth = 74.f;
NSInteger kCTCTestContengtImageCount11 = 3;

@interface AGCircleTableViewCellNew ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIView *mContentImageContainerView;
@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UIImageView *mUserVIPIcon;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UILabel *mContentLabel;
@property (strong, nonatomic) UILabel *mTimeLabel;
@property (strong, nonatomic) UILabel *mSeeLabel;

@property (strong, nonatomic) UIButton *mFuncButton;
@property (strong, nonatomic) UIButton *mCommentButton;
@property (strong, nonatomic) UIButton *mLikeButton;
@property (strong, nonatomic) UILabel *mMarkLabel;


@end

@implementation AGCircleTableViewCellNew

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
        [self.mContainerView addSubview:self.mSeeLabel];
        [self.mContainerView addSubview:self.mContentLabel];
        
        [self.mContainerView addSubview:self.mFuncButton];
        [self.mContainerView addSubview:self.mCommentButton];
        [self.mContainerView addSubview:self.mLikeButton];
        [self.mContainerView addSubview:self.mMarkLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidSelectedAction:)];
        [self.mUserIconImageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, self.indexPath.row == 0 ? 12.f : 6.f, self.width - 12.f * 2, self.height - 6.f * 2 - (self.indexPath.row == 0 ? 6.f : 0.f));
    if(self.indexPath.row == 0) {
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(20.f, 20.f) forView:self];
    }
    else {
        self.layer.mask = nil;
    }
    
    self.mUserIconImageView.origin = CGPointMake(12.f, 12.f);
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:self.mCFLData.memberBaseDto.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mUserNameLabel.text = [NSString stringSafeChecking:self.mCFLData.memberBaseDto.nickname];
    [self.mUserNameLabel sizeToFit];
    
    CGFloat originFixedY = (self.mUserIconImageView.height - (self.mUserNameLabel.height + self.mTimeLabel.height + 3.f)) / 2;
    self.mUserNameLabel.origin = CGPointMake(self.mUserIconImageView.right + 5.f, self.mUserIconImageView.top + originFixedY);
    
    self.mTimeLabel.origin = CGPointMake(self.mUserNameLabel.left, self.mUserNameLabel.bottom + 3.f);
    self.mTimeLabel.text = [NSString stringSafeChecking:self.mCFLData.dateStr];
    [self.mTimeLabel sizeToFit];
    
    self.mSeeLabel.text = [NSString stringWithFormat:@"%@浏览", [HelpTools checkNumberInfo:self.mCFLData.seeNum]];
    [self.mSeeLabel sizeToFit];
    self.mSeeLabel.left = self.mTimeLabel.right + 5.f;
    self.mSeeLabel.centerY = self.mTimeLabel.centerY;
    
    self.mUserNameLabel.width = self.mUserNameLabel.width > (self.mTimeLabel.width - self.mUserVIPIcon.width - 3.f) ? (self.mTimeLabel.width - self.mUserVIPIcon.width - 3.f) : self.mUserNameLabel.width;
    self.mUserVIPIcon.left = self.mUserNameLabel.right + 3.f;
    self.mUserVIPIcon.centerY = self.mUserNameLabel.centerY;
    
    NSString *level = self.mCFLData.memberBaseDto.level;
    if([NSString isNotEmptyAndValid:level] &&
       [level integerValue] > 0) {
        self.mUserVIPIcon.hidden = NO;
        self.mUserVIPIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", level]];
    }
    else {
        self.mUserVIPIcon.hidden = YES;
    }
    
    self.mFuncButton.origin = CGPointMake(self.mContainerView.width - self.mFuncButton.width - 8.f, self.mUserIconImageView.top);
    
    //NSString *content = self.data.content;
    NSAttributedString *content = [AGCircleTableViewCellNew checkContentString:self.mCFLData.content];
    self.mContentLabel.origin = CGPointMake(8.f, self.mUserIconImageView.bottom + 12.f);
    self.mContentLabel.width = self.mContainerView.width - 8.f * 2;
    //self.mContentLabel.height = [HelpTools sizeWithString:content withShowSize:CGSizeMake(self.mContentLabel.width, MAXFLOAT) withFont:self.mContentLabel.font].height;
    self.mContentLabel.height = [HelpTools sizeWithAttributeString:content withShowSize:CGSizeMake(self.mContentLabel.width, MAXFLOAT)].height;
    //self.mContentLabel.text = content;
    self.mContentLabel.attributedText = content;
    
    CGFloat originY = self.mContentLabel.bottom;
    NSArray *mediaArray = [[NSString stringSafeChecking:self.mCFLData.media] componentsSeparatedByString:@";"];
    if(!mediaArray || !mediaArray.count) {
        
        if([NSString isNotEmptyAndValid:self.mCFLData.media]) {
            
            mediaArray = @[self.mCFLData.media];
        }
    }
    mediaArray = [NSArray filterEmptyStringFromArray:mediaArray];
    
    NSInteger imageCount = mediaArray.count;
    //self.indexPath.row > kCTCTestContengtImageCount11 ? kCTCTestContengtImageCount11 : self.indexPath.row;
    [self.mContentImageContainerView removeAllSubview];
    if(imageCount == 1) {
        
        CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCTCContentImageBaseTag + 0)];
        if(!contentImage) {
            
            contentImage = [CarouselImageView new];
            contentImage.userInteractionEnabled = YES;
            contentImage.clipsToBounds = YES;
            contentImage.ignoreCache = YES;
            [self.mContentImageContainerView addSubview:contentImage];
            contentImage.tag = kCTCContentImageBaseTag + 0;
        }
        contentImage.size = CGSizeMake(self.mContainerView.width - 8.f * 2, kCTCContentSingleImageHeight);
        contentImage.origin = CGPointMake(8.f, 0.f);
        [contentImage setImageWithObject:[NSString stringSafeChecking:mediaArray.firstObject] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:contentImage];
        
        self.mContentImageContainerView.frame = CGRectMake(0.f, originY + 12.f, self.mContainerView.width, kCTCContentSingleImageHeight);
        originY = self.mContentImageContainerView.bottom;
    }
    else if(imageCount == 2) {
        
        CGFloat subOriginX = 8.f;
        CGFloat contentImageWidth = (self.mContainerView.width - 8.f - 8.f * 2) / 2;
        for (int i = 0; i < imageCount; ++i) {
            
            CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCTCContentImageBaseTag + i)];
            if(!contentImage) {
                
                contentImage = [CarouselImageView new];
                contentImage.userInteractionEnabled = YES;
                contentImage.clipsToBounds = YES;
                contentImage.ignoreCache = YES;
                [self.mContentImageContainerView addSubview:contentImage];
                contentImage.tag = kCTCContentImageBaseTag + i;
            }
            contentImage.size = CGSizeMake(contentImageWidth, contentImageWidth);
            contentImage.origin = CGPointMake(subOriginX, 0.f);
            [contentImage setImageWithObject:[NSString stringSafeChecking:mediaArray[i]] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
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
            
            CarouselImageView *contentImage = (CarouselImageView *)[self.mContainerView viewWithTag:(kCTCContentImageBaseTag + i)];
            if(!contentImage) {
                
                contentImage = [CarouselImageView new];
                contentImage.userInteractionEnabled = YES;
                contentImage.clipsToBounds = YES;
                contentImage.ignoreCache = YES;
                [self.mContentImageContainerView addSubview:contentImage];
                contentImage.tag = kCTCContentImageBaseTag + i;
            }
            
            contentImage.size = CGSizeMake((i == 0 ? contentImageWidth : littleContentImageWidth), (i == 0 ? contentImageWidth : littleContentImageWidth));
            contentImage.origin = CGPointMake(subOriginX, subOriginY);
            [contentImage setImageWithObject:[NSString stringSafeChecking:mediaArray[i]] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
            
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
    self.mLikeButton.left = self.mCommentButton.right + 5.f;
    
    [self.mCommentButton setTitle:[HelpTools checkNumberInfo:self.mCFLData.commentNum] forState:UIControlStateNormal];
    [self.mLikeButton setTitle:[HelpTools checkNumberInfo:self.mCFLData.likeNum] forState:UIControlStateNormal];
    
    if([NSString isNotEmptyAndValid:self.mCFLData.discussList]) {
        
        self.mMarkLabel.text = [NSString stringWithFormat:@"#%@", self.mCFLData.discussList];
        [self.mMarkLabel sizeToFit];
        self.mMarkLabel.width = self.mMarkLabel.width < kCTCMarkMinWidth ? kCTCMarkMinWidth : self.mMarkLabel.width + 6.f;
        self.mMarkLabel.height = kCTCMarkMinHeight;
        self.mMarkLabel.left = self.mContainerView.width - self.mMarkLabel.width - 12.f;
        self.mMarkLabel.hidden = NO;
    }
    else {
        self.mMarkLabel.hidden = YES;
    }
    
    self.mLikeButton.centerY = self.mMarkLabel.centerY = self.mCommentButton.centerY;
}

- (void)setMCFLData:(AGCircleFollowLastData *)mCFLData {
    _mCFLData = mCFLData;
    
    [self setNeedsLayout];
}

#pragma mark -
+ (NSMutableAttributedString*)checkContentString:(NSString*)string {
    if(![NSString isNotEmptyAndValid:string]) {
        
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setLineSpacing:6.5];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont font15]}];
    
    return attributedString;
}

+ (CGFloat)getAGCircleSingleCategoryTableViewCellHeight:(AGCircleFollowLastData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index{
    
    CGFloat cellHeight = 6.f * 2 + 12.f + kCTCUserIconHeight + 12.f + kCTCBottomButtonHeight + 12.f + (index.row == 0 ? 6.f : 0.f);
    
    //NSString *content = data.content;
    NSAttributedString *content = [self checkContentString:data.content];
    //CGFloat contentHeight = [HelpTools sizeWithString:content withShowSize:CGSizeMake((containerWidth - 20.f * 2), MAXFLOAT) withFont:[UIFont font14]].height;
    CGFloat contentHeight = [HelpTools sizeWithAttributeString:content withShowSize:CGSizeMake((containerWidth - 20.f * 2), MAXFLOAT)].height;
    cellHeight += (12.f + contentHeight);
    
    NSArray *mediaArray = [[NSString stringSafeChecking:data.media] componentsSeparatedByString:@";"];
    if(!mediaArray || !mediaArray.count) {
        
        if([NSString isNotEmptyAndValid:data.media]) {
            
            mediaArray = @[data.media];
        }
    }
    mediaArray = [NSArray filterEmptyStringFromArray:mediaArray];
    NSInteger imageCount = mediaArray.count;
    //index.row > kCTCTestContengtImageCount11 ? kCTCTestContengtImageCount11 : index.row;
    
    if(imageCount == 1) {
        
        cellHeight += (12.f + kCTCContentSingleImageHeight);
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

#pragma mark - Selector
- (void)tapDidSelectedAction:(id)sender {
    
    if(self.didHeadIconSelectedHandle) {
        
        self.didHeadIconSelectedHandle(self.mCFLData);
    }
}

- (void)mFuncButtonAction:(UIButton *)button {
    
    if(self.moreDidSelectedHandle) {
        
        self.moreDidSelectedHandle(self.mCFLData);
    }
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
        _mUserIconImageView.size = CGSizeMake(kCTCUserIconHeight, kCTCUserIconHeight);
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

- (UILabel *)mSeeLabel {
    
    if(!_mSeeLabel) {
        
        _mSeeLabel = [UILabel new];
        _mSeeLabel.font = [UIFont font14];
        _mSeeLabel.textColor = UIColorFromRGB(0xB5B7C1);
    }
    
    return _mSeeLabel;
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

- (UILabel *)mMarkLabel {
    
    if(!_mMarkLabel) {
        
        _mMarkLabel = [UILabel new];
        _mMarkLabel.font = [UIFont font14];
        _mMarkLabel.textColor = UIColorFromRGB(0xF2FEFF);
        _mMarkLabel.textAlignment = NSTextAlignmentCenter;
        
        _mMarkLabel.clipsToBounds = YES;
        _mMarkLabel.layer.cornerRadius = 5.f;
        _mMarkLabel.layer.borderWidth = 1.f;
        _mMarkLabel.layer.borderColor = UIColorFromRGB(0x3CE2CE).CGColor;
        _mMarkLabel.backgroundColor = UIColorFromRGB_ALPHA(0x3CE3C9, 0.22f);
    }
    
    return _mMarkLabel;
}

- (UIButton *)mFuncButton {
    
    if(!_mFuncButton) {
        
        _mFuncButton = [UIButton new];
        _mFuncButton.size = CGSizeMake(32.f, 32.f);
        //[_mFuncButton setImage:IMAGE_NAMED(@"ag_list_dot_func_icon") forState:UIControlStateNormal];
        [_mFuncButton setImage:IMAGE_NAMED(@"post_detail_more") forState:UIControlStateNormal];
        
        [_mFuncButton addTarget:self action:@selector(mFuncButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mFuncButton;
}

- (UIButton *)getCustomButtonWithImage:(NSString *)image {
     
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    
    [button setImage:IMAGE_NAMED(image) forState:UIControlStateNormal];
    
    [button setTitleColor:UIColorFromRGB(0xF2FEFF) forState:UIControlStateNormal];
    [button setTitleColor:[UIColorFromRGB(0xF2FEFF) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [button setTitle:@"9999" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont font14];
    [button sizeToFit];
    
    return button;
}

@end
