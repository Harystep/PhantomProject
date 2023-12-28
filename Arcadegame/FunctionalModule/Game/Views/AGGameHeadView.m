//
//  AGGameHeadView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/18.
//

#import "AGGameHeadView.h"
#import "CarouselPictureView.h"

static const CGFloat kAGGameHeadViewBackHeight = 292.f;
static const CGFloat kAGGameHeadViewChargeHeight = 40.f;
static const CGFloat kAGGameHeadViewFunctionHeight = 264.f;

static const NSInteger kAGGameHeadButtonBaseTag = 100;
static const NSInteger kAGGameHeadFuncBackBaseTag = 1000;

@interface AGGameHeadView () <CarouselPictureDelegate>

@property (strong, nonatomic) CarouselPictureView *mBackCarouselPictureView;
@property (strong, nonatomic) UIImageView *mFunctionContainerView;

@property (strong, nonatomic) NSArray *mFunctionButtonLeftImages;
@property (strong, nonatomic) NSArray *mFunctionBackImages;
@property (strong, nonatomic) NSArray *mFunctionSubTitles;
@property (strong, nonatomic) NSArray *mFunctionTitles;

@end

@implementation AGGameHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.height = kAGGameHeadViewBackHeight + 12.f + kAGGameHeadViewChargeHeight + 12.f + kAGGameHeadViewFunctionHeight;
        
        [self addSubview:self.mBackCarouselPictureView];
        [self addSubview:self.mFunctionContainerView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mBackCarouselPictureView.frame = (CGRect){CGPointZero, CGSizeMake(self.width, kAGGameHeadViewBackHeight)};
    [self.mBackCarouselPictureView setPictureData:@[IMAGE_NAMED(@"game_head_back")]];
    
    CGFloat buttonWidth = (self.width - 23.f * 2 - 10.f * (3 - 1)) / 3;
    CGFloat originY = self.mBackCarouselPictureView.bottom + 12.f;
    CGFloat originX = 23.f;
    
    for (int i = 0; i < self.mFunctionButtonLeftImages.count; ++i) {
        
        AGGameHeadButton *headButton = [self viewWithTag:kAGGameHeadButtonBaseTag + i];
        if(!headButton) {
            headButton = [AGGameHeadButton new];
            headButton.tag = kAGGameHeadButtonBaseTag + i;
            [self addSubview:headButton];
        }
        
        headButton.frame = CGRectMake(originX, originY, buttonWidth, 40.f);
        headButton.headImageName = self.mFunctionButtonLeftImages[i];
        headButton.headvalueString = @"250W";
        
        originX = headButton.right + 10.f;
        
        if(i == (self.mFunctionButtonLeftImages.count - 1)) {
            
            originY = headButton.bottom;
        }
    }
    
    self.mFunctionContainerView.frame = (CGRect){CGPointMake(8.f, originY + 8.f), CGSizeMake(self.width - 8.f * 2, kAGGameHeadViewFunctionHeight)};
    self.mFunctionContainerView.image = IMAGE_NAMED(@"game_head_func_back");
    
    CGFloat firstOriginX = 15.f;
    originX = firstOriginX;
    originY = 44.f;
    CGFloat funcViewWidth = (self.mFunctionContainerView.width - firstOriginX * 2 - 11.f) / 2;
    for (int i = 0; i < self.mFunctionBackImages.count; ++i) {

        AGGameHeadFuncView *funcView = [self.mFunctionContainerView viewWithTag:kAGGameHeadFuncBackBaseTag + i];
        if(!funcView) {
            funcView = [AGGameHeadFuncView new];
            funcView.tag = kAGGameHeadFuncBackBaseTag + i;
            [self.mFunctionContainerView addSubview:funcView];
        }
        
        funcView.frame = CGRectMake(originX, originY, funcViewWidth, 96.f);
        funcView.subTitleString = self.mFunctionSubTitles[i];
        funcView.imageName = self.mFunctionBackImages[i];
        funcView.titleString = self.mFunctionTitles[i];

        originX = (i % 2 == 0) ? (funcView.right + 11.f) : firstOriginX;
        originY = (i % 2 == 1) ? (funcView.bottom + 11.f) : originY;
    }
}

- (void)setData:(NSData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

#pragma mark - CarouselPictureDelegate
- (void)shortTapPicture:(id)unitObject index:(NSInteger)index{
    
    DLOG(@"******shortTapPicture:%@", unitObject);
}

- (void)showDetailLargeImageWithIndex:(NSInteger)index{
    
    DLOG(@"******showDetailLargeImageWithIndex:%@", @(index));
}

- (UIView *)carouselPictureForSingleOverLayerView:(id)unitObject index:(NSInteger)index{
    
    return nil;
}

#pragma mark - Getter
- (CarouselPictureView *)mBackCarouselPictureView {
    
    if(!_mBackCarouselPictureView) {
        
        _mBackCarouselPictureView = [[CarouselPictureView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, kAGGameHeadViewBackHeight) picturesData:nil];
        _mBackCarouselPictureView.pageControlStyle = PAGECONTROL_STYLE_NOD;
        _mBackCarouselPictureView.isAutoCarousel = NO;
        _mBackCarouselPictureView.delegate = self;
        _mBackCarouselPictureView.cacheKey = @"mBackCarouselPictureView";
        
        _mBackCarouselPictureView.pageIndicatorTintColor = [UIColor whiteColorffffffAlpha:0.6];
        _mBackCarouselPictureView.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        _mBackCarouselPictureView.defaultImage = IMAGE_NAMED(@"default_goodsDetail_top_image");
    }
    
    return _mBackCarouselPictureView;
}

- (NSArray *)mFunctionButtonLeftImages {
    
    if(!_mFunctionButtonLeftImages) {
        
        _mFunctionButtonLeftImages = @[@"game_head_btn_gem", @"game_head_btn_gold", @"game_head_btn_glory"];
    }
    
    return _mFunctionButtonLeftImages;
}

- (UIImageView *)mFunctionContainerView {
    
    if(!_mFunctionContainerView) {
        
        _mFunctionContainerView = [UIImageView new];
        _mFunctionContainerView.backgroundColor = [UIColor clearColor];
        _mFunctionContainerView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_head_func_back")];
        _mFunctionContainerView.userInteractionEnabled = YES;
    }
    
    return _mFunctionContainerView;
}

- (NSArray *)mFunctionBackImages {
    
    if(!_mFunctionBackImages) {
        
        _mFunctionBackImages = @[@"game_head_func_charge", @"game_head_func_charts", @"game_head_func_signin", @"game_head_func_service"];
    }
    
    return _mFunctionBackImages;
}

- (NSArray *)mFunctionSubTitles {
    
    if(!_mFunctionSubTitles) {
        
        _mFunctionSubTitles = @[@"参加好礼相送", @"榜单赢好礼哇", @"积分送不停", @"解答您的问题"];
    }
    
    return _mFunctionSubTitles;
}

- (NSArray *)mFunctionTitles {
    
    if(!_mFunctionTitles) {
        
        _mFunctionTitles = @[@"充值", @"排行榜", @"签到", @"客服"];
    }
    
    return _mFunctionTitles;
}

@end

/**
 * AGGameHeadButton
 */
@interface AGGameHeadButton ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UILabel *textLabel;

@end

@implementation AGGameHeadButton

- (instancetype)init{
    
    if(self = [super init]){
        
        [self setBackgroundImage:IMAGE_NAMED(@"game_head_btn_back") forState:UIControlStateNormal];
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.textLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setHeadImageName:(NSString *)headImageName {
    _headImageName = headImageName;
    
    self.leftImageView.image = IMAGE_NAMED(headImageName);
    [self.leftImageView sizeToFit];
    
    self.leftImageView.left = 5.f;
    self.rightImageView.left = self.width - self.rightImageView.width - 5.f;
    
    self.textLabel.width = self.rightImageView.left - self.leftImageView.right - 3.f * 2;
    self.textLabel.left = self.leftImageView.right + 3.f;
    self.textLabel.text = @"555W";
    
    self.leftImageView.centerY = self.textLabel.centerY = self.rightImageView.centerY = self.height / 2.f;
}

- (void)setHeadvalueString:(NSString *)headvalueString {
    _headvalueString = headvalueString;
    
    self.textLabel.text = headvalueString;
}

#pragma mark - Getter
- (UIImageView *)leftImageView {
    
    if(!_leftImageView) {
        
        _leftImageView = [UIImageView new];
        _leftImageView.userInteractionEnabled = YES;
    }
    
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    
    if(!_rightImageView) {
        
        _rightImageView = [UIImageView new];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.image = IMAGE_NAMED(@"game_head_btn_add");
        [_rightImageView sizeToFit];
    }
    
    return _rightImageView;
}

- (UILabel *)textLabel {
    
    if(!_textLabel) {
        
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont fontWithName:@"Alfa Slab One" size:16];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.height = _textLabel.font.lineHeight;
    }
    
    return _textLabel;
}

@end

/**
 * AGGameHeadFuncView
 */
@interface AGGameHeadFuncView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *backImageView;

@end

@implementation AGGameHeadFuncView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
//        self.contentMode = UIViewContentModeScaleToFill;
//        self.clipsToBounds = YES;
        
        [self addSubview:self.backImageView];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backImageView.frame = self.bounds;
    self.backImageView.image = IMAGE_NAMED(self.imageName);
    
    self.titleLabel.left = 12.f;
    self.titleLabel.width = self.width - self.titleLabel.left * 2;
    self.titleLabel.text = self.titleString;
    
    self.subTitleLabel.left = self.titleLabel.left;
    self.subTitleLabel.width = self.width - self.subTitleLabel.left * 2;
    self.subTitleLabel.text = self.subTitleString;
    
    CGFloat referY = (self.height - self.titleLabel.height - self.subTitleLabel.height - 3.f) / 2.f;
    self.titleLabel.top = referY;
    self.subTitleLabel.top = self.titleLabel.bottom + 3.f;
    
    DLOG(@"AGGameHeadFuncView layoutSubviews bound:%@", NSStringFromCGRect(self.frame));
}

#pragma mark - Selector
- (void)tapGestureAction:(id)sender {
    
    if(self.didSelecedHandle) {
        
        self.didSelecedHandle(self.tag - kAGGameHeadFuncBackBaseTag);
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.height = _titleLabel.font.lineHeight;
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    
    if(!_subTitleLabel) {
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont font14];
        _subTitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _subTitleLabel.height = _subTitleLabel.font.lineHeight;
    }
    
    return _subTitleLabel;
}

- (UIImageView *)backImageView {
    
    if(!_backImageView) {
        
        _backImageView = [UIImageView new];
        
//        _backImageView.clipsToBounds = NO;
        _backImageView.userInteractionEnabled = YES;
//        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _backImageView;
}

@end
