//
//  AGHomeBoardGameView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBoardGameView.h"

static const CGFloat kHBGHeadContentTopHeight = 241.f;
static const CGFloat kHBGHeadContentBottomHeight = 57.f;
static const NSInteger kHBGContentBaseTag = 100;

@interface AGHomeBoardGameView ()

@property (strong, nonatomic) AGHomeBoardGameHeadView *mHBoardGameHeadView;

@end

@implementation AGHomeBoardGameView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        self.mTableView.width = self.width;
    }
    
    return self;
}

- (void)setData:(AGCicleHomeOtherData *)data {
    _data = data;
    
    self.postArray = data.groupDynamicList;
    
    self.mTableView.tableHeaderView = self.mHBoardGameHeadView;
    [self.mHBoardGameHeadView setData:data];
    
    [self.mTableView reloadData];
}

#pragma mark - Getter
- (AGHomeBoardGameHeadView *)mHBoardGameHeadView {
    
    if(!_mHBoardGameHeadView) {
        
        _mHBoardGameHeadView = [AGHomeBoardGameHeadView new];
        
        __WeakObject(self);
        _mHBoardGameHeadView.headContentDidSelectedHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.headContentDidSelectedHandle) {
                
                __strongObject.headContentDidSelectedHandle(data);
            }
        };
        
        _mHBoardGameHeadView.headBottomDidSelectedHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.headBottomDidSelectedHandle) {
                
                __strongObject.headBottomDidSelectedHandle();
            }
        };
    }
    
    return _mHBoardGameHeadView;
}

@end

/**
 * AGHomeBoardGameHeadView
 */
@interface AGHomeBoardGameHeadView ()

@property (strong, nonatomic) UIScrollView *mContentScrollView;
@property (strong, nonatomic) AGHomeBoardGameHeadContentBottomView *mHBGHBottomView;

@end

@implementation AGHomeBoardGameHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        self.height = 0.f;
        [self addSubview:self.mContentScrollView];
        [self addSubview:self.mHBGHBottomView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeOtherData *)data {
    _data = data;
    
    [self.mContentScrollView removeAllSubview];
    
    if(data.groupDtoList &&
       data.groupDtoList.count) {
        
        self.height = kHBGHeadContentTopHeight + 12.f * 2;
        self.mContentScrollView.frame = CGRectMake(0.f, 0.f, self.width, self.height);
        
        CGFloat contentWidth = (self.width - 12.f * 2) / 2.4f;
        CGFloat originX = 12.f;
        
        for (int i = 0; i < data.groupDtoList.count; ++i) {
            
            AGHomeBoardGameHeadContentView *contentView = [self.mContentScrollView viewWithTag:(kHBGContentBaseTag + i)];
            if(!contentView) {
                
                contentView = [AGHomeBoardGameHeadContentView new];
                contentView.tag = (kHBGContentBaseTag + i);
                
                [self.mContentScrollView addSubview:contentView];
            }
            
            contentView.frame = CGRectMake(originX, 12.f, contentWidth, kHBGHeadContentTopHeight);
            contentView.data = data.groupDtoList[i];
            
            __WeakObject(self);
            contentView.headContentDidSelectedHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                __WeakStrongObject();
                
                if(__strongObject.headContentDidSelectedHandle) {
                    
                    __strongObject.headContentDidSelectedHandle(data);
                }
            };
            
            originX = contentView.right + 12.f;
        }
        
        self.mContentScrollView.contentSize = CGSizeMake(originX, self.mContentScrollView.height);
        
        self.mHBGHBottomView.frame = CGRectMake(12.f, self.mContentScrollView.bottom + 7.f, self.width - 12.f * 2, kHBGHeadContentBottomHeight);
        self.height += kHBGHeadContentBottomHeight + 19.f + 12.f;
    }
    else {
        self.height = 0.f;
    }
}

#pragma mark - Getter
- (UIScrollView *)mContentScrollView {
    
    if(!_mContentScrollView) {
        
        _mContentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mContentScrollView.backgroundColor = [UIColor clearColor];
    }
    
    return _mContentScrollView;
}

#pragma mark -
- (AGHomeBoardGameHeadContentBottomView *)mHBGHBottomView {
    
    if(!_mHBGHBottomView) {
        
        _mHBGHBottomView = [AGHomeBoardGameHeadContentBottomView new];
        
        __WeakObject(self);
        _mHBGHBottomView.headBottomDidSelectedHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.headBottomDidSelectedHandle) {
                
                __strongObject.headBottomDidSelectedHandle();
            }
        };
    }
    
    return _mHBGHBottomView;
}

@end

/**
 * AGHomeBoardGameHeadContentView
 */
@interface AGHomeBoardGameHeadContentView ()

@property (strong, nonatomic) UILabel *headTitleLabel;
@property (strong, nonatomic) UILabel *headInfoLabel;
@property (strong, nonatomic) UIView *containerBackMaskView;
@property (strong, nonatomic) CarouselImageView *containerBackImageView;
@property (strong, nonatomic) CarouselImageView *userHeadImageView1;
@property (strong, nonatomic) CarouselImageView *userHeadImageView2;
@property (strong, nonatomic) UIView *userHeadContainerView;
@property (strong, nonatomic) UIButton *circleConfirmButton;
@property (strong, nonatomic) UILabel *headCircleInfoLabel;

@end

@implementation AGHomeBoardGameHeadContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor defaultBackColor];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        
        [self.containerBackImageView addSubview:self.containerBackMaskView];
        [self addSubview:self.containerBackImageView];
        [self addSubview:self.circleConfirmButton];
        [self addSubview:self.headTitleLabel];
        [self addSubview:self.headInfoLabel];

        [self addSubview:self.userHeadContainerView];
        [self.userHeadContainerView addSubview:self.userHeadImageView1];
        [self.userHeadContainerView addSubview:self.userHeadImageView2];
        [self.userHeadContainerView addSubview:self.headCircleInfoLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeOtherDtoData *)data {
    _data = data;
    
    self.containerBackImageView.frame = self.bounds;
    [self.containerBackImageView setImageWithObject:data.bgImage withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.containerBackMaskView.frame = self.containerBackImageView.bounds;
    
    self.headTitleLabel.origin = CGPointMake(12.f, 12.f);
    self.headTitleLabel.width = self.width - self.headTitleLabel.left * 2;
    self.headTitleLabel.text = [NSString stringWithFormat:@"#%@", [NSString stringSafeChecking:data.name]];
    
    self.headInfoLabel.left = self.headTitleLabel.left;
    self.headInfoLabel.top = self.headTitleLabel.bottom + 12.f;
    self.headInfoLabel.width = self.headTitleLabel.width;
    self.headInfoLabel.text = [NSString stringSafeChecking:data.Description];
    
    self.userHeadImageView1.hidden = self.userHeadImageView2.hidden = YES;
    
    if(data.followImages && data.followImages.count) {
        
        NSString *userImage1 = [data.followImages objectAtIndexForSafe:0];
        NSString *userImage2 = [data.followImages objectAtIndexForSafe:1];
        
        if([NSString isNotEmptyAndValid:userImage1]) {
            
            self.userHeadImageView1.hidden = NO;
            [self.userHeadImageView1 setImageWithObject:userImage1 withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        }
        
        if([NSString isNotEmptyAndValid:userImage2]) {
            
            self.userHeadImageView2.hidden = NO;
            [self.userHeadImageView2 setImageWithObject:userImage1 withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        }
    }
    
    self.userHeadImageView1.left = 3.f;
    self.userHeadImageView2.left = self.userHeadImageView1.right - self.userHeadImageView1.width / 4.f;
    
    CGFloat ciOriginX = self.userHeadImageView2.right + 5.f;
    if(self.userHeadImageView1.hidden) {
        
        ciOriginX = 3.f;
    }
    else if(self.userHeadImageView2.hidden) {
        
        ciOriginX = self.userHeadImageView1.right + 5.f;
    }
    
    self.headCircleInfoLabel.left = ciOriginX;
    self.headCircleInfoLabel.text = [HelpTools checkCircleInfo:data.userNum];
    [self.headCircleInfoLabel sizeToFit];
    
    CGFloat referWidth = self.width - self.userHeadImageView2.right - 12.f - 5.f;
    self.headCircleInfoLabel.width = (self.headCircleInfoLabel.width > referWidth) ? referWidth : self.headCircleInfoLabel.width;
    
    self.userHeadContainerView.frame = CGRectMake(self.headTitleLabel.left, self.headInfoLabel.bottom + 12.f, self.headCircleInfoLabel.right + 5.f, 27.f);
    
    self.userHeadImageView1.centerY = self.userHeadImageView2.centerY = self.headCircleInfoLabel.centerY = self.userHeadContainerView.height / 2.f;
    
    self.circleConfirmButton.left = self.headTitleLabel.left;
    self.circleConfirmButton.top = self.height - self.circleConfirmButton.height - 12.f;
}

#pragma mark -
- (void)circleConfirmButtonAction:(UIButton *)button {
    
    if(self.headContentDidSelectedHandle) {
        
        self.headContentDidSelectedHandle(self.data);
    }
}

#pragma mark - Getter
- (UILabel *)headTitleLabel {
    
    if(!_headTitleLabel) {
        _headTitleLabel = [UILabel new];
        _headTitleLabel.font = [UIFont font16];
        _headTitleLabel.textColor = [UIColor whiteColor];
        _headTitleLabel.height = _headTitleLabel.font.lineHeight;
    }
    
    return _headTitleLabel;
}

- (UILabel *)headCircleInfoLabel {
    
    if(!_headCircleInfoLabel) {
        _headCircleInfoLabel = [UILabel new];
        _headCircleInfoLabel.font = [UIFont font14];
        _headCircleInfoLabel.textColor = UIColorFromRGB(0xF2FEFF);
        _headCircleInfoLabel.height = _headCircleInfoLabel.font.lineHeight;
    }
    
    return _headCircleInfoLabel;
}

- (UILabel *)headInfoLabel {
    
    if(!_headInfoLabel) {
        _headInfoLabel = [UILabel new];
        _headInfoLabel.font = [UIFont font14];
        _headInfoLabel.numberOfLines = 2.f;
        _headInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _headInfoLabel.height = _headInfoLabel.font.lineHeight * 2 + _headInfoLabel.font.leading;
    }
    
    return _headInfoLabel;
}

- (CarouselImageView *)userHeadImageView1 {
    
    if(!_userHeadImageView1) {
        
        _userHeadImageView1 = [CarouselImageView new];
        _userHeadImageView1.size = CGSizeMake(14.f, 14.f);
        _userHeadImageView1.layer.cornerRadius = _userHeadImageView1.height / 2.f;
        _userHeadImageView1.clipsToBounds = YES;
        _userHeadImageView1.ignoreCache = YES;
    }
    
    return _userHeadImageView1;
}

- (CarouselImageView *)userHeadImageView2 {
    
    if(!_userHeadImageView2) {
        
        _userHeadImageView2 = [CarouselImageView new];
        _userHeadImageView2.size = CGSizeMake(14.f, 14.f);
        _userHeadImageView2.layer.cornerRadius = _userHeadImageView2.height / 2.f;
        _userHeadImageView2.clipsToBounds = YES;
        _userHeadImageView2.ignoreCache = YES;
    }
    
    return _userHeadImageView2;
}

- (CarouselImageView *)containerBackImageView {
    
    if(!_containerBackImageView) {
        
        _containerBackImageView = [CarouselImageView new];
        _containerBackImageView.clipsToBounds = YES;
        _containerBackImageView.ignoreCache = YES;
    }
    
    return _containerBackImageView;
}

- (UIView *)containerBackMaskView {
    
    if(!_containerBackMaskView) {
        
        _containerBackMaskView = [UIView new];
        _containerBackMaskView.backgroundColor = [UIColor blackColor000000Alpha:0.5];
    }
    
    return _containerBackMaskView;
}

- (UIView *)userHeadContainerView {
    
    if(!_userHeadContainerView) {
        
        _userHeadContainerView = [UIView new];
        _userHeadContainerView.layer.cornerRadius = 5.f;
        _userHeadContainerView.backgroundColor = UIColorFromRGB_ALPHA(0x3CE3C9, 0.22f);
        _userHeadContainerView.layer.borderColor = UIColorFromRGB(0x3CE2CE).CGColor;
        _userHeadContainerView.layer.borderWidth = 1.f;
    }
    
    return _userHeadContainerView;
}

- (UIButton *)circleConfirmButton {
    
    if(!_circleConfirmButton) {
        
        _circleConfirmButton = [UIButton new];
        [_circleConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_circleConfirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        [_circleConfirmButton setTitle:@"去看看" forState:UIControlStateNormal];
        [_circleConfirmButton setSize:CGSizeMake(76.f, 32.f)];
        _circleConfirmButton.layer.cornerRadius = 5.f;
        _circleConfirmButton.clipsToBounds = YES;
        
        [_circleConfirmButton setBackgroundImage:[HelpTools createGradientImageWithSize:_circleConfirmButton.size colors:@[UIColorFromRGB(0x30E49D), UIColorFromRGB(0x2ECAC0)] gradientType:1] forState:UIControlStateNormal];
        
        [_circleConfirmButton addTarget:self action:@selector(circleConfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _circleConfirmButton;
}

@end

/**
 * AGHomeBoardGameHeadContentBottomView
 */
@interface AGHomeBoardGameHeadContentBottomView ()

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UILabel *leftInfoLabel;
@property (strong, nonatomic) UILabel *rightInfoLabel;
@property (strong, nonatomic) UIImageView *rightIconImageView;

@end

@implementation AGHomeBoardGameHeadContentBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor defaultBackColor];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        
        [self addSubview:self.leftInfoLabel];
        [self addSubview:self.rightInfoLabel];
        [self addSubview:self.rightIconImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headDidSelectedAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.backgroundView) {
        
        self.backgroundView = [HelpTools createHorizontalShadeViewWithSize:self.size withColor:@[UIColorFromRGB(0x30E39E), UIColorFromRGB(0x2DC8C2)]];
        [self addSubview:self.backgroundView];
        [self.backgroundView sendToBack];
    }
    
    self.leftInfoLabel.origin = CGPointMake(15.f, 0.f);
    
    self.rightIconImageView.left = self.width - self.rightIconImageView.width - 8.f;
    self.rightInfoLabel.left = self.rightIconImageView.left - self.rightInfoLabel.width - 4.f;
    
    self.leftInfoLabel.centerY = self.rightInfoLabel.centerY = self.rightIconImageView.centerY = self.height / 2.f;
}

#pragma mark - Selector
- (void)headDidSelectedAction:(id)sender {
    
    if(self.headBottomDidSelectedHandle) {
        
        self.headBottomDidSelectedHandle();
    }
}

#pragma mark - Getter
- (UILabel *)leftInfoLabel {
    
    if(!_leftInfoLabel) {
        _leftInfoLabel = [UILabel new];
        _leftInfoLabel.font = [UIFont font15];
        _leftInfoLabel.textColor = [UIColor whiteColor];
        _leftInfoLabel.text = @"#话题贡献榜，下一个就是你";
        [_leftInfoLabel sizeToFit];
    }
    
    return _leftInfoLabel;
}

- (UILabel *)rightInfoLabel {
    
    if(!_rightInfoLabel) {
        _rightInfoLabel = [UILabel new];
        _rightInfoLabel.font = [UIFont font15];
        _rightInfoLabel.textColor = [UIColor whiteColor];
        _rightInfoLabel.text = @"看看圈子";
        [_rightInfoLabel sizeToFit];
    }
    
    return _rightInfoLabel;
}

- (UIImageView *)rightIconImageView {
    
    if(!_rightIconImageView) {
        
        _rightIconImageView =  [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"list_right_icon")];
    }
    
    return _rightIconImageView;
}

@end
