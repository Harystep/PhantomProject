//
//  AGHomePostDetailTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGHomePostDetailTableViewCell.h"

static const CGFloat kHPDTHUserIconHeight = 52.f;
static const CGFloat kHPDTHMarkMinHeight = 26.f;
static const CGFloat kHPDTHMarkMinWidth = 74.f;

@implementation AGHomePostDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

@end

/**
 * AGHomePostDetailTableHeadViewCell
 */
@interface AGHomePostDetailTableHeadViewCell ()

@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UIImageView *mUserVIPIcon;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UIButton *mFollowButton;

@end

@implementation AGHomePostDetailTableHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mUserIconImageView];
        [self.contentView addSubview:self.mUserNameLabel];
        [self.contentView addSubview:self.mFollowButton];
        [self.contentView addSubview:self.mUserVIPIcon];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidSelectedAction:)];
        [self.mUserIconImageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(20.f, 20.f) forView:self];
    
    self.mUserIconImageView.origin = CGPointMake(15.f, 0.f);
    self.mUserIconImageView.centerY = self.height / 2.f;
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.memberBaseDto.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mUserNameLabel.text = [NSString stringSafeChecking:self.data.memberBaseDto.nickname];
    [self.mUserNameLabel sizeToFit];
    
    CGFloat originFixedY = (self.mUserIconImageView.height - (self.mUserNameLabel.height + self.mUserVIPIcon.height + 3.f)) / 2;
    self.mUserNameLabel.origin = CGPointMake(self.mUserIconImageView.right + 5.f, self.mUserIconImageView.top + originFixedY);
    
    self.mUserVIPIcon.hidden = YES;
    self.mUserVIPIcon.origin = CGPointMake(self.mUserNameLabel.left, self.mUserNameLabel.bottom + 3.f);
    if(self.data.memberBaseDto.level && self.data.memberBaseDto.level.length && [self.data.memberBaseDto.level integerValue] > 0) {
        
        self.mUserVIPIcon.hidden = NO;
        self.mUserVIPIcon.hidden = NO;
        self.mUserVIPIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", self.data.memberBaseDto.level]];
    }
    
    self.mFollowButton.left = self.width - self.mFollowButton.width - 15.f;
    self.mFollowButton.centerY = self.height / 2.f;
    
    //[self.mFollowButton setTitle:(self.data.hasFocus ? @"取消关注" : @"关注") forState:UIControlStateNormal];
}

- (void)setData:(AGCircleDetailData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark - Selector
- (void)followButtonAction:(UIButton *)button {
    
    if(self.didFollowSelectedHandle) {
        
        self.didFollowSelectedHandle(self.data.hasFocus ? YES : NO);
    }
}

- (void)tapDidSelectedAction:(id)sender {
    
    if(self.didHeadIconSelectedHandle) {
        
        self.didHeadIconSelectedHandle();
    }
}

#pragma mark - Getter
- (CarouselImageView *)mUserIconImageView {
    
    if(!_mUserIconImageView) {
        
        _mUserIconImageView = [CarouselImageView new];
        _mUserIconImageView.size = CGSizeMake(kHPDTHUserIconHeight, kHPDTHUserIconHeight);
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
        _mUserNameLabel.font = [UIFont font16Bold];
        _mUserNameLabel.textColor = [UIColor whiteColor];
        
        _mUserNameLabel.height = _mUserNameLabel.font.lineHeight;
    }
    
    return _mUserNameLabel;
}

- (UIImageView *)mUserVIPIcon {
    
    if(!_mUserVIPIcon) {
        
        _mUserVIPIcon = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"user_level_1")];
    }
    
    return _mUserVIPIcon;
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

/**
 * AGHomePostDetailTableContentViewCell
 */
@interface AGHomePostDetailTableContentViewCell ()

@property (strong, nonatomic) UILabel *mContentLabel;

@end

@implementation AGHomePostDetailTableContentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContentLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSAttributedString *content = [AGHomePostDetailTableContentViewCell checkContentString:self.data];
    
    self.mContentLabel.left = 15.f;
    
    self.mContentLabel.size = [HelpTools sizeWithAttributeString:content withShowSize:CGSizeMake((self.width - 15.f * 2), MAXFLOAT)];
    //[HelpTools sizeWithString:content withShowSize:CGSizeMake((self.width - 15.f * 2), MAXFLOAT) withFont:self.mContentLabel.font];
    self.mContentLabel.attributedText = content;
}

- (void)setData:(NSString *)data {
    _data = data;
    
    [self setNeedsLayout];
}

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

+ (CGFloat)getAGCircleCategoryTableViewCellHeight:(NSString *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index {
    
    NSAttributedString *content = [self checkContentString:data];
    //NSString *content = [NSString stringSafeChecking:data];
    //CGFloat contentHeight = [HelpTools sizeWithString:content withShowSize:CGSizeMake((containerWidth - 15.f * 2), MAXFLOAT) withFont:[UIFont font14]].height;
    CGFloat contentHeight = [HelpTools sizeWithAttributeString:content withShowSize:CGSizeMake((containerWidth - 15.f * 2), MAXFLOAT)].height;
    
    return contentHeight;
}

#pragma mark - Getter
- (UILabel *)mContentLabel {
    
    if(!_mContentLabel) {
        
        _mContentLabel = [UILabel new];
        _mContentLabel.font = [UIFont font14];
        _mContentLabel.textColor = [UIColor whiteColor];
        _mContentLabel.numberOfLines = 0;
    }
    
    return _mContentLabel;
}

@end

/**
 * AGHomePostDetailTableRewardViewCell
 */
@interface AGHomePostDetailTableRewardViewCell ()

@property (strong, nonatomic) UIButton *mRewardButton;

@end

@implementation AGHomePostDetailTableRewardViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mRewardButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mRewardButton.centerX = self.width / 2.f;
    self.mRewardButton.top = self.height - self.mRewardButton.height - 2.f;
}

#pragma mark - Selector
- (void)mRewardButtonAction:(UIButton *)button {
    
    if(self.didSelectedRewardHandle) {
        
        self.didSelectedRewardHandle();
    }
}

#pragma mark - Getter
- (UIButton *)mRewardButton {
    
    if(!_mRewardButton) {
        
        _mRewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mRewardButton.size = CGSizeMake(100.f, 38.f);
        
        UIImage *backgroundImage = [HelpTools createImageWithColor:[UIColor whiteColorffffffAlpha08] withRect:((CGRect){CGPointZero, _mRewardButton.size}) radius:_mRewardButton.height / 2.f];
        [_mRewardButton setBackgroundImage:backgroundImage forState:UIControlStateHighlighted];
        [_mRewardButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [_mRewardButton setTitleColor:UIColorFromRGB(0xEE607C) forState:UIControlStateNormal];
        [_mRewardButton setTitleColor:[UIColorFromRGB(0xEE607C) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        
        [_mRewardButton setTitle:@"赞赏" forState:UIControlStateNormal];
        _mRewardButton.titleLabel.font = [UIFont font16];
        
        [_mRewardButton addTarget:self action:@selector(mRewardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mRewardButton;
}

@end

/**
 * AGHomePostDetailTableFunctionViewCell
 */
@interface AGHomePostDetailTableFunctionViewCell ()

@property (strong, nonatomic) AGHomePostDetailTableCircleView *mCircleView;
@property (strong, nonatomic) UIButton *mCommentButton;
@property (strong, nonatomic) UIButton *mMoreButton;
@property (strong, nonatomic) UIButton *mLikeButton;
@property (strong, nonatomic) UILabel *mMarkLabel;
@property (strong, nonatomic) UILabel *mTimeLabel;
@property (strong, nonatomic) UILabel *mSeeLabel;
@property (strong, nonatomic) UIView *mLineView;

@end

@implementation AGHomePostDetailTableFunctionViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mCircleView];
        
        [self.contentView addSubview:self.mCommentButton];
        [self.contentView addSubview:self.mLikeButton];
        [self.contentView addSubview:self.mMoreButton];
        [self.contentView addSubview:self.mMarkLabel];
        
        [self.contentView addSubview:self.mTimeLabel];
        [self.contentView addSubview:self.mSeeLabel];
        [self.contentView addSubview:self.mLineView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mTimeLabel.text = [NSString stringSafeChecking:self.data.dateStr];//@"12312分钟前";
    [self.mTimeLabel sizeToFit];
    self.mTimeLabel.origin = CGPointMake(15.f, 20.f);
    
    self.mSeeLabel.text = [NSString stringWithFormat:@"%@浏览", [NSString stringSafeChecking:self.data.seeNum]];
    [self.mSeeLabel sizeToFit];
    self.mSeeLabel.left = self.mTimeLabel.right + 10.f;
    
    if([NSString isNotEmptyAndValid:self.data.discussList]) {
        
        self.mMarkLabel.text = [NSString stringWithFormat:@"#%@", self.data.discussList];
        [self.mMarkLabel sizeToFit];
        self.mMarkLabel.hidden = NO;
        self.mMarkLabel.width = self.mMarkLabel.width < kHPDTHMarkMinWidth ? kHPDTHMarkMinWidth : self.mMarkLabel.width + 6.f;
        self.mMarkLabel.height = kHPDTHMarkMinHeight;
    }
    else {
        self.mMarkLabel.hidden = YES;
    }
    self.mMarkLabel.left = self.width - self.mMarkLabel.width - 15.f;
    
    self.mSeeLabel.centerY = self.mMarkLabel.centerY = self.mTimeLabel.centerY;
    
    self.mCircleView.left = 15.f;
    self.mCircleView.top = self.mTimeLabel.bottom + 15.f;
    self.mCircleView.size = CGSizeMake(self.width - self.mCircleView.left * 2, 53.f);
    self.mCircleView.data = self.data.group;
    
    [self.mCommentButton setTitle:[NSString stringSafeChecking:self.data.commentNum] forState:UIControlStateNormal];
    self.mCommentButton.top = self.mCircleView.bottom + 12.f;
    self.mCommentButton.left = 15.f;
    
    [self.mLikeButton setTitle:[NSString stringSafeChecking:self.data.likeNum] forState:UIControlStateNormal];
    self.mLikeButton.left = self.mCommentButton.right + 15.f;
    self.mLikeButton.centerY = self.mCommentButton.centerY;
    
    if(self.data.hasLike) {
        
        [self.mLikeButton setImage:IMAGE_NAMED(@"home_like_selected") forState:UIControlStateNormal];
    }
    else {
        
        [self.mLikeButton setImage:IMAGE_NAMED(@"circle_category_like_icon") forState:UIControlStateNormal];
    }
    
    self.mMoreButton.origin = CGPointMake(self.width - self.mMoreButton.width - 15.f, 0.f);
    self.mMoreButton.centerY = self.mCommentButton.centerY;
    
    self.mLineView.origin = CGPointMake(15.f, self.mLikeButton.bottom + 16.f);
    self.mLineView.width = self.width - self.mLineView.left * 2;
}

- (void)setData:(AGCircleDetailData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark - Selector
- (void)likeButtonAction:(UIButton *)button {
    
    if(self.didLikeSelectedHandle) {
        
        self.didLikeSelectedHandle(self.data.hasLike ? YES : NO);
    }
}

- (void)moreButtonAction:(UIButton *)button {
    
    if(self.didMoreSelectedHandle) {
        
        self.didMoreSelectedHandle();
    }
}

#pragma mark - Getter
- (AGHomePostDetailTableCircleView *)mCircleView {
    
    if(!_mCircleView) {
        
        _mCircleView = [AGHomePostDetailTableCircleView new];
    }
    
    return _mCircleView;
}

- (UIButton *)mCommentButton {
    
    if(!_mCommentButton) {
        
        _mCommentButton = [self getButtonWithImage:@"circle_category_comment_icon"];
    }
    
    return _mCommentButton;
}

- (UIButton *)mLikeButton {
    
    if(!_mLikeButton) {
        
        _mLikeButton = [self getButtonWithImage:@"circle_category_like_icon"];
        [_mLikeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mLikeButton;
}

- (UIButton *)mMoreButton {
    
    if(!_mMoreButton) {
        
        _mMoreButton = [self getButtonWithImage:@"post_detail_more"];
        [_mMoreButton setTitle:@"举报" forState:UIControlStateNormal];
        _mMoreButton.titleLabel.font = [UIFont font12];
        [_mMoreButton sizeToFit];
        
        [_mMoreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mMoreButton;
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

- (UIView *)mLineView {
    
    if(!_mLineView) {
        
        _mLineView = [UIView new];
        _mLineView.backgroundColor = UIColorFromRGB(0x1E2537);
        _mLineView.height = 1.f;
    }
    
    return _mLineView;
}

- (UIButton *)getButtonWithImage:(NSString *)image {
     
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

/**
 * AGHomePostDetailTableCircleView
 */
@interface AGHomePostDetailTableCircleView ()

@property (strong, nonatomic) CarouselImageView *mCircleIconImageView;
@property (strong, nonatomic) UILabel *mCircleUserNumLabel;
@property (strong, nonatomic) UILabel *mCirclePostNumLabel;
@property (strong, nonatomic) UILabel *mCircleNameLabel;
@property (strong, nonatomic) UIView *mContainerView;

@property (strong, nonatomic) UIButton *downBtn;

@end

@implementation AGHomePostDetailTableCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mCircleIconImageView];
        [self.mContainerView addSubview:self.mCircleUserNumLabel];
        [self.mContainerView addSubview:self.mCirclePostNumLabel];
        [self.mContainerView addSubview:self.mCircleNameLabel];
        [self.mContainerView addSubview:self.downBtn];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = self.bounds;
    
    self.mCircleIconImageView.origin = CGPointMake(5.f, 5.f);
    self.mCircleIconImageView.size = CGSizeMake(self.height - 5.f * 2, self.height - 5.f * 2);
    [self.mCircleIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.coverImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mCircleNameLabel.left = self.mCircleIconImageView.right + 5.f;
    self.mCircleNameLabel.top = self.mCircleIconImageView.top;
    self.mCircleNameLabel.width = self.width - self.mCircleIconImageView.right - 5.f * 2;
    self.mCircleNameLabel.text = [NSString stringSafeChecking:self.data.name];
    
//    self.mCircleUserNumLabel.text = [NSString stringWithFormat:@"%@加入圈子", [HelpTools checkNumberInfo:self.data.userNum]];
    self.mCircleUserNumLabel.text = [NSString stringWithFormat:@"%@人下载", [HelpTools checkNumberInfo:self.data.userNum]];
    [self.mCircleUserNumLabel sizeToFit];
    
    self.mCircleUserNumLabel.left = self.mCircleNameLabel.left;
    self.mCircleUserNumLabel.top = self.mCircleIconImageView.bottom - self.mCircleUserNumLabel.height;
    
//    self.mCirclePostNumLabel.text = [NSString stringWithFormat:@"%@篇内容", [HelpTools checkNumberInfo:self.data.postNum]];
    self.mCirclePostNumLabel.text = [NSString stringWithFormat:@"%@人玩过", [HelpTools checkNumberInfo:self.data.postNum]];
    [self.mCirclePostNumLabel sizeToFit];
    
    self.mCirclePostNumLabel.left = self.mCircleUserNumLabel.right + 5.f;
    self.mCirclePostNumLabel.centerY = self.mCircleUserNumLabel.centerY;
    
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mContainerView.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(26);
        make.trailing.mas_equalTo(self.mContainerView.mas_trailing).inset(10);
    }];
    
}

- (void)downBtnOperate {
    
}

- (void)setData:(AGCircleDetailGroupData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark - Getter
- (CarouselImageView *)mCircleIconImageView {
    
    if(!_mCircleIconImageView) {
        
        _mCircleIconImageView = [CarouselImageView new];
        _mCircleIconImageView.layer.cornerRadius = 5.f;
        _mCircleIconImageView.userInteractionEnabled = YES;
        _mCircleIconImageView.clipsToBounds = YES;
        _mCircleIconImageView.ignoreCache = YES;
    }
    
    return _mCircleIconImageView;
}


- (UIButton *)downBtn {
    
    if(!_downBtn) {
        _downBtn = [[UIButton alloc] init];
        [_downBtn setTitle:@"下载" forState:UIControlStateNormal];
        _downBtn.backgroundColor = UIColor.whiteColor;
        [_downBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _downBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_downBtn addTarget:self action:@selector(downBtnOperate) forControlEvents:UIControlEventTouchUpInside];
        _downBtn.layer.cornerRadius = 13;
        _downBtn.layer.masksToBounds = YES;
        _downBtn.hidden = YES;
    }
    
    return _downBtn;
}

- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 5.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (UILabel *)mCircleNameLabel {
    
    if(!_mCircleNameLabel) {
        
        _mCircleNameLabel = [UILabel new];
        _mCircleNameLabel.font = [UIFont font14];
        _mCircleNameLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _mCircleNameLabel.height = _mCircleNameLabel.font.lineHeight;
    }
    
    return _mCircleNameLabel;
}

- (UILabel *)mCircleUserNumLabel {
    
    if(!_mCircleUserNumLabel) {
        
        _mCircleUserNumLabel = [UILabel new];
        _mCircleUserNumLabel.font = [UIFont font14];
        _mCircleUserNumLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _mCircleUserNumLabel.height = _mCircleUserNumLabel.font.lineHeight;
    }
    
    return _mCircleUserNumLabel;
}

- (UILabel *)mCirclePostNumLabel {
    
    if(!_mCirclePostNumLabel) {
        
        _mCirclePostNumLabel = [UILabel new];
        _mCirclePostNumLabel.font = [UIFont font14];
        _mCirclePostNumLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _mCirclePostNumLabel.height = _mCirclePostNumLabel.font.lineHeight;
    }
    
    return _mCirclePostNumLabel;
}

@end

/**
 * AGHomePostDetailTableCommentHeadViewCell
 */
@interface AGHomePostDetailTableCommentHeadViewCell ()

@property (strong, nonatomic) UILabel *mCommentHeadLabel;

@end

@implementation AGHomePostDetailTableCommentHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mCommentHeadLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mCommentHeadLabel.left = 15.f;
    self.mCommentHeadLabel.width = self.width - self.mCommentHeadLabel.left * 2;
    self.mCommentHeadLabel.centerY = self.height / 2.f;
    
    self.mCommentHeadLabel.text = [NSString stringWithFormat:@"评论（%@）", [HelpTools checkNumberInfo:self.data]];
}

#pragma mark - Getter
- (UILabel *)mCommentHeadLabel {
    
    if(!_mCommentHeadLabel) {
        
        _mCommentHeadLabel = [UILabel new];
        _mCommentHeadLabel.backgroundColor = [UIColor clearColor];
        _mCommentHeadLabel.font = [UIFont font15];
        _mCommentHeadLabel.textColor = UIColorFromRGB(0xF2FEFF);
        _mCommentHeadLabel.height = _mCommentHeadLabel.font.lineHeight;
    }
    
    return _mCommentHeadLabel;
}

@end

/**
 * AGHomePostDetailTableCommentViewCell
 */
@interface AGHomePostDetailTableCommentViewCell ()

@property (strong, nonatomic) CarouselImageView *mUserIconImageView;
@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UILabel *mUserNameLabel;
@property (strong, nonatomic) UILabel *mContentLabel;
@property (strong, nonatomic) UILabel *mTimeLabel;
@property (strong, nonatomic) UIButton *mComplainButton;

@end

@implementation AGHomePostDetailTableCommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mUserIconImageView];
        [self.mContainerView addSubview:self.mComplainButton];
        [self.mContainerView addSubview:self.mUserNameLabel];
        [self.mContainerView addSubview:self.mContentLabel];
        [self.mContainerView addSubview:self.mTimeLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidSelectedAction:)];
        [self.mUserIconImageView addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(15.f, 5.f, self.width - 15.f * 2, self.height - 5.f * 2);
    
    self.mUserIconImageView.origin = CGPointMake(5.f, 5.f);
    [self.mUserIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.memberBaseDto.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mComplainButton.left = self.mContainerView.width - self.mComplainButton.width;
    self.mComplainButton.top = self.mUserIconImageView.top - 2.f;
    
    NSTimeInterval timeInterval = [HelpTools getTimeIntervalForDateString:self.data.createTime];
    self.mTimeLabel.text = [HelpTools getFormatterDateFromMsecTimestampStyle3:[NSString stringWithFormat:@"%@", @(timeInterval * 1000)]];
    [self.mTimeLabel sizeToFit];
    
    self.mTimeLabel.left = self.mComplainButton.left - self.mTimeLabel.width - 5.f;
    self.mTimeLabel.top = self.mUserIconImageView.top;
    
    self.mUserNameLabel.top = self.mUserIconImageView.top;
    self.mUserNameLabel.left = self.mUserIconImageView.right + 5.f;
    self.mUserNameLabel.width = self.mTimeLabel.left - self.mUserNameLabel.left - 5.f;
    self.mUserNameLabel.text = [NSString stringSafeChecking:self.data.memberBaseDto.nickname];
    
    NSString *content = [NSString stringSafeChecking:self.data.content];
    
    self.mContentLabel.numberOfLines = 0;
    self.mContentLabel.left = self.mUserNameLabel.left;
    self.mContentLabel.top = self.mUserNameLabel.bottom + 10.f;
    self.mContentLabel.width = self.mContainerView.width - self.mContentLabel.left - 5.f * 2;
    self.mContentLabel.height = [HelpTools sizeForString:content withFont:self.mContentLabel.font viewWidth:self.mContentLabel.width].height;
    self.mContentLabel.text = content;
}

+ (CGFloat)getAGHomePostDetailTableCommentCellHeight:(AGCircleCommentData *)data withContainerWidth:(CGFloat)containerWidth withIndex:(NSIndexPath *)index {
    
    NSString *content = [NSString stringSafeChecking:data.content];
    
    CGFloat contentMaxWidth = containerWidth - 15.f * 2 - 5.f * 2 - 5.f - 50.f - 5.f * 2;
    CGFloat contentHeight = [HelpTools sizeWithString:content withShowSize:CGSizeMake(contentMaxWidth, MAXFLOAT) withFont:[UIFont font14]].height;
    CGFloat fixContentHeight = contentHeight + 5.f * 2 + [UIFont font14].lineHeight  + 20.f;
    
    if(fixContentHeight < 70.f) {
        
        fixContentHeight = 70.f;
    }
    
    return fixContentHeight;
}

#pragma mark - Selector
- (void)tapDidSelectedAction:(id)sender {
    
    if(self.didHeadIconSelectedHandle) {
        
        self.didHeadIconSelectedHandle(self.data);
    }
}

- (void)complainButtonAction:(UIButton *)button {
    
    if(self.didComplainButtonSelectedHandle) {
        
        self.didComplainButtonSelectedHandle(self.data);
    }
}

#pragma mark - Getter
- (CarouselImageView *)mUserIconImageView {
    
    if(!_mUserIconImageView) {
        
        _mUserIconImageView = [CarouselImageView new];
        _mUserIconImageView.size = CGSizeMake(50.f, 50.f);
        _mUserIconImageView.layer.cornerRadius = _mUserIconImageView.height / 2.f;
        _mUserIconImageView.userInteractionEnabled = YES;
        _mUserIconImageView.clipsToBounds = YES;
        _mUserIconImageView.ignoreCache = YES;
    }
    
    return _mUserIconImageView;
}

- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 5.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
        _mContainerView.userInteractionEnabled = YES;
    }
    
    return _mContainerView;
}

- (UILabel *)mUserNameLabel {
    
    if(!_mUserNameLabel) {
        
        _mUserNameLabel = [UILabel new];
        _mUserNameLabel.font = [UIFont font14];
        _mUserNameLabel.textColor = UIColorFromRGB(0xB5B7C1);
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

- (UILabel *)mContentLabel {
    
    if(!_mContentLabel) {
        
        _mContentLabel = [UILabel new];
        _mContentLabel.font = [UIFont font14];
        _mContentLabel.textColor = [UIColor whiteColor];
        _mContentLabel.numberOfLines = 0;
    }
    
    return _mContentLabel;
}

- (UIButton *)mComplainButton {
    
    if(!_mComplainButton) {
        
        _mComplainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mComplainButton.size = CGSizeMake(24.f, 24.f);
        
        //[_mComplainButton setImage:IMAGE_NAMED(@"post_detail_more") forState:UIControlStateNormal];
        [_mComplainButton setImage:IMAGE_NAMED(@"ag_list_dot_func_icon") forState:UIControlStateNormal];
        
        //_mComplainButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        [_mComplainButton setTitleColor:UIColorFromRGB(0xF2FEFF) forState:UIControlStateNormal];
        [_mComplainButton setTitleColor:[UIColorFromRGB(0xF2FEFF) colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [_mComplainButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        //_mComplainButton.titleLabel.font = [UIFont font12];
        //[_mComplainButton setTitle:@"举报" forState:UIControlStateNormal];
        //[_mComplainButton sizeToFit];
        
        [_mComplainButton addTarget:self action:@selector(complainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mComplainButton;
}

@end
