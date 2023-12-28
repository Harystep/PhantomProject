//
//  AGHomeRecommendView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeRecommendView.h"
#import "CarouselPictureView.h"

#import "AGBannerCollectionViewCell.h"
#import "AGLiveCollectionViewCell.h"
#import "AGHotGameCollectionViewCell.h"
#import "AGHotGameBackCollectionViewCell.h"
#import "AGIndicatorView.h"

static const CGFloat kHRHeadArcadeTopHeight = 180.f;//260.f;
static const CGFloat kHRHeadArcadeHeight = 219.f;//299.f;
static const CGFloat kHRHeadSegaHeight = 342.f;
static const CGFloat kHRHeadSegaFrontHeight = 198.f;
static const CGFloat kHRHeadImageHeight = 121.f;

@interface AGHomeRecommendView ()

@property (strong, nonatomic) AGHomeRecommendHeadView *mAGHRecommendHeadView;

@end

@implementation AGHomeRecommendView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        self.mTableView.width = self.width;
    }
    
    return self;
}

- (void)setData:(AGCicleHomeRecommendData *)data {
    _data = data;
    
    self.postArray = data.groupDynamicList;
    
    self.mTableView.tableHeaderView = self.mAGHRecommendHeadView;
    [self.mAGHRecommendHeadView setData:data];
    
    [self.mTableView reloadData];
}

#pragma mark - Getter
- (AGHomeRecommendHeadView *)mAGHRecommendHeadView {
    
    if(!_mAGHRecommendHeadView) {
        
        _mAGHRecommendHeadView = [AGHomeRecommendHeadView new];
        
        __WeakObject(self);
        _mAGHRecommendHeadView.headSegaDidSelectedHandle = ^(AGCicleHomeRSegaData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.headSegaDidSelectedHandle) {
                
                __strongObject.headSegaDidSelectedHandle(data);
            }
        };
        
        _mAGHRecommendHeadView.headArcadeDidSelectedHandle = ^(AGCicleHomeRArcadeData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.headArcadeDidSelectedHandle) {
                
                __strongObject.headArcadeDidSelectedHandle(data);
            }
        };
    }
    
    return _mAGHRecommendHeadView;
}

@end

/**
 * AGHomeRecommendHeadView
 */
@interface AGHomeRecommendHeadView ()

@property (strong, nonatomic) AGHomeRecommendHeadArcadeView *mHRHeadArcadeView;
@property (strong, nonatomic) AGHomeRecommendHeadImageView *mHRHeadImageView;
@property (strong, nonatomic) AGHomeRecommendHeadSegaView *mHRHeadSegaView;

@end

@implementation AGHomeRecommendHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        self.height = 0.f;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeRecommendData *)data {
    _data = data;
    
    CGFloat selfHeight = 0.f;
    [self removeAllSubview];
    
//    data.arcadeList = @[];
    if(data.arcadeList && data.arcadeList.count &&
       ![self.mHRHeadArcadeView isDescendantOfView:self]) {
        
        [self addSubview:self.mHRHeadArcadeView];
        self.mHRHeadArcadeView.size = CGSizeMake(self.width, kHRHeadArcadeHeight);
        self.mHRHeadArcadeView.bannerData = data.bannerDtos2;
        self.mHRHeadArcadeView.dataList = data.arcadeList;
        
        self.mHRHeadArcadeView.origin = CGPointMake(0.f, 12.f);
        selfHeight += self.mHRHeadArcadeView.bottom;
    }
    
//    data.segaList = @[];
    if(data.segaList && data.segaList.count &&
       ![self.mHRHeadSegaView isDescendantOfView:self]) {
        //350 * 342
        CGFloat viewContainterWidth = self.width - 12.f * 2;
        CGFloat viewContainterHeight = viewContainterWidth * kHRHeadSegaHeight / 350.f;

        [self addSubview:self.mHRHeadSegaView];
        self.mHRHeadSegaView.size = CGSizeMake(self.width, viewContainterHeight);
        self.mHRHeadSegaView.dataList = data.segaList;

        self.mHRHeadSegaView.origin = CGPointMake(0.f, (selfHeight > 0.f) ? (selfHeight + 12.f) : 12.f);
        selfHeight += self.mHRHeadSegaView.height + 14.f;
    }
    
    if(data.bannerDtos && data.bannerDtos.count &&
       ![self.mHRHeadImageView isDescendantOfView:self]) {
        
        [self addSubview:self.mHRHeadImageView];
        //351 * 121
        CGFloat viewContainterWidth = self.width - 12.f * 2;
        CGFloat viewContainterHeight = viewContainterWidth * kHRHeadImageHeight / 351.f;
        self.mHRHeadImageView.size = CGSizeMake(self.width, viewContainterHeight);
        self.mHRHeadImageView.dataList = data.bannerDtos;
        
        self.mHRHeadImageView.origin = CGPointMake(0.f, (selfHeight > 0.f) ? (selfHeight + 12.f) : 12.f);
        selfHeight += self.mHRHeadImageView.height + 14.f;
    }
    
    self.height = selfHeight + 10.f;
}

#pragma mark - Getter
- (AGHomeRecommendHeadArcadeView *)mHRHeadArcadeView {
    
    if(!_mHRHeadArcadeView) {
        
        _mHRHeadArcadeView = [[AGHomeRecommendHeadArcadeView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, kHRHeadArcadeHeight)];
        
        __WeakObject(self);
        _mHRHeadArcadeView.headArcadeDidSelectedHandle = ^(AGCicleHomeRArcadeData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.headArcadeDidSelectedHandle) {
                
                __strongObject.headArcadeDidSelectedHandle(data);
            }
        };
    }
    
    return _mHRHeadArcadeView;
}

- (AGHomeRecommendHeadSegaView *)mHRHeadSegaView {
    
    if(!_mHRHeadSegaView) {
        
        _mHRHeadSegaView = [[AGHomeRecommendHeadSegaView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, kHRHeadSegaHeight)];
        
        __WeakObject(self);
        _mHRHeadSegaView.headSegaDidSelectedHandle = ^(AGCicleHomeRSegaData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.headSegaDidSelectedHandle) {
                
                __strongObject.headSegaDidSelectedHandle(data);
            }
        };
    }
    
    return _mHRHeadSegaView;
}

- (AGHomeRecommendHeadImageView *)mHRHeadImageView {
    
    if(!_mHRHeadImageView) {
        
        _mHRHeadImageView = [[AGHomeRecommendHeadImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, kHRHeadImageHeight)];
    }
    
    return _mHRHeadImageView;
}

@end

/**
 * AGHomeRecommendHeadArcadeView
 * 街机房间
 */
static NSString * const kAGBannerCollectionViewIdentifier = @"kAGBannerCollectionViewIdentifier";
static NSString * const kAGLiveCollectionViewIdentifier = @"kAGLiveCollectionViewIdentifier";

@interface AGHomeRecommendHeadArcadeView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) AGIndicatorView *indicator;
@property (strong, nonatomic) UICollectionView *mTopCarouselRoomView;
@property (strong, nonatomic) UICollectionView *mBottomCarouselRoomView;

@end

@implementation AGHomeRecommendHeadArcadeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mTopCarouselRoomView];
        [self addSubview:self.mBottomCarouselRoomView];
        [self addSubview:self.indicator];
        
        [self.mTopCarouselRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            
            CGFloat cellWidth = self.width - 12.f * 2;
            CGFloat cellHeight = cellWidth * kHRHeadArcadeTopHeight / 351.f;
            make.height.mas_equalTo(cellHeight);
        }];
        
        [self.mBottomCarouselRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(78);
        }];
        
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(4);
            make.right.mas_equalTo(-25);
            make.bottom.equalTo(self.mTopCarouselRoomView).offset(-49);
        }];
    }
    
    return self;
}

- (void)setDataList:(NSArray<AGCicleHomeRArcadeData *> *)dataList {
    _dataList = dataList;
    
    [self layoutIfNeeded];
    [self.mBottomCarouselRoomView reloadData];
    
    //[self.mTopCarouselRoomView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50000 * dataList.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    //[self.mBottomCarouselRoomView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:50000 * dataList.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)setBannerData:(NSArray<AGCicleHomeRBannerData *> *)bannerData {
    _bannerData = bannerData;
    
    [self layoutIfNeeded];
    self.indicator.totalCount = (bannerData.count ? bannerData.count : 1);
    [self.mTopCarouselRoomView reloadData];
}

#pragma mark - Getter
- (AGIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [AGIndicatorView new];
    }
    
    return _indicator;
}

- (UICollectionView *)mTopCarouselRoomView {
    if (!_mTopCarouselRoomView) {
        //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        //collectionViewLayout.itemSize = CGSizeMake(screenWidth, 260);
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AGBannerCollectionViewCell class] forCellWithReuseIdentifier:kAGBannerCollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = false;
        _mTopCarouselRoomView = collectionView;
    }
    return _mTopCarouselRoomView;
}

- (UICollectionView *)mBottomCarouselRoomView {
    if (!_mBottomCarouselRoomView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        //collectionViewLayout.itemSize = CGSizeMake(147, 78);
        collectionViewLayout.minimumLineSpacing = 12;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AGLiveCollectionViewCell class] forCellWithReuseIdentifier:kAGLiveCollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = false;
        _mBottomCarouselRoomView = collectionView;
    }
    return _mBottomCarouselRoomView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.mTopCarouselRoomView) {
        //return self.dataList.count * 100000;
        if(self.bannerData.count) {
            
            return self.bannerData.count;
        }
        
        return 1;
    }
    else {
        //return self.dataList.count * 100000;
        return self.dataList.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.mTopCarouselRoomView) {
        //351 * 260
        //351 * 185
        return CGSizeMake(collectionView.width, collectionView.height);
    }
    else {
        
        return CGSizeMake(147.f, 78.f);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.mTopCarouselRoomView) {
        AGBannerCollectionViewCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGBannerCollectionViewIdentifier forIndexPath:indexPath];
        //bCell.model = self.dataList[(indexPath.row % self.dataList.count)];
        if(self.bannerData.count) {
            
            bCell.bannerData = self.bannerData[indexPath.row];
        }
        else {
            AGCicleHomeRBannerData *bannerData = [AGCicleHomeRBannerData new];
            bannerData.imgUrl = @"home_arcade_banner_default";
            bCell.bannerData = bannerData;
        }
        //bCell.model = self.dataList[indexPath.row];
        return bCell;
    }
    else {
        AGLiveCollectionViewCell *lCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGLiveCollectionViewIdentifier forIndexPath:indexPath];
        //lCell.model = self.dataList[(indexPath.row % self.dataList.count)];
        lCell.model = self.dataList[indexPath.row];
        return lCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView != self.mTopCarouselRoomView) {
        
        AGCicleHomeRArcadeData *data = self.dataList[indexPath.row];
        
        if(self.headArcadeDidSelectedHandle) {
            
            self.headArcadeDidSelectedHandle(data);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(scrollView == self.mTopCarouselRoomView) {
        
        CGFloat cellWidth = scrollView.size.width;
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger index = floor(offsetX/cellWidth + 0.5);
        //NSInteger calIndex = index % self.dataList.count;
        
        self.indicator.currentIndex = index;
    }
}

@end

/**
 * AGHomeRecommendHeadSegaView
 * 推币机房间
 */

static NSString * const kAGHotGameBackCollectionViewIdentifier = @"kAGHotGameBackCollectionViewIdentifier";
static NSString * const kAGHotGameCollectionViewIdentifier = @"kAGHotGameCollectionViewIdentifier";


@interface AGHomeRecommendHeadSegaView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *mBackCarouselPictureView;
@property (strong, nonatomic) UICollectionView *mFrontCarouselPictureView;

@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation AGHomeRecommendHeadSegaView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.mBackCarouselPictureView];
        [self addSubview:self.mFrontCarouselPictureView];
        
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.titleLabel];
        
        [self.mBackCarouselPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.mFrontCarouselPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(210);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(30);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        }];
    }
    
    return self;
}

- (void)setDataList:(NSArray<AGCicleHomeRSegaData *> *)dataList {
    _dataList = dataList;
    [self.mBackCarouselPictureView reloadData];
}

- (UICollectionView *)mFrontCarouselPictureView {
    if (!_mFrontCarouselPictureView) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        //collectionViewLayout.itemSize = CGSizeMake(160, 210);
        collectionViewLayout.minimumLineSpacing = 12;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AGHotGameCollectionViewCell class] forCellWithReuseIdentifier:kAGHotGameCollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = NO;
        collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        collectionView.showsHorizontalScrollIndicator = false;
        _mFrontCarouselPictureView = collectionView;
    }
    return _mFrontCarouselPictureView;
}

- (UICollectionView *)mBackCarouselPictureView {
    if (!_mBackCarouselPictureView) {
        //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        //collectionViewLayout.itemSize = CGSizeMake(screenWidth, 342);
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AGHotGameBackCollectionViewCell class] forCellWithReuseIdentifier:kAGHotGameBackCollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = false;
        _mBackCarouselPictureView = collectionView;
    }
    return _mBackCarouselPictureView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.mFrontCarouselPictureView) {
        
        return self.dataList.count;
    }
    else {
        //return self.dataList.count;
        return 1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(collectionView == self.mBackCarouselPictureView) {
        //350 * 342
        return CGSizeMake(collectionView.width, collectionView.height);
    }
    else {
        
        //return CGSizeMake(160.f, 210.f);
        return CGSizeMake(145.f, 191.f);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.mFrontCarouselPictureView) {
        AGHotGameCollectionViewCell *gCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGHotGameCollectionViewIdentifier forIndexPath:indexPath];
        gCell.model = self.dataList[indexPath.row];
        return gCell;
    }
    else {
        AGHotGameBackCollectionViewCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGHotGameBackCollectionViewIdentifier forIndexPath:indexPath];
        //bCell.model = self.dataList[indexPath.row];
        
        AGCicleHomeRBannerData *data = [AGCicleHomeRBannerData new];
        data.imgUrl = @"home_sega_banner_default";
        bCell.bannerModel = data;
        return bCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.mFrontCarouselPictureView) {
        
        AGCicleHomeRSegaData *data = self.dataList[indexPath.row];
        
        if(self.headSegaDidSelectedHandle) {
            
            self.headSegaDidSelectedHandle(data);
        }
    }
}

- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font24Bold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"热玩中";
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    
    if(!_subTitleLabel) {
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont font18];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.text = @"火热游戏 速速来玩";
        [_subTitleLabel sizeToFit];
    }
    
    return _subTitleLabel;
}

@end

/**
 * AGHomeRecommendHeadImageView
 */
@interface AGHomeRecommendHeadImageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *mCarouselPictureView;

@end

@implementation AGHomeRecommendHeadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.mCarouselPictureView];
        
        [self.mCarouselPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
}

- (void)setDataList:(NSArray<AGCicleHomeRBannerData *> *)dataList {
    _dataList = dataList;
    [self.mCarouselPictureView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AGHotGameBackCollectionViewCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGHotGameBackCollectionViewIdentifier forIndexPath:indexPath];
    bCell.bannerModel = self.dataList[indexPath.row];
    return bCell;
}

#pragma mark - Getter
- (UICollectionView *)mCarouselPictureView {
    if (!_mCarouselPictureView) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.itemSize = CGSizeMake(screenWidth, self.height);
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AGHotGameBackCollectionViewCell class] forCellWithReuseIdentifier:kAGHotGameBackCollectionViewIdentifier];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = false;
        _mCarouselPictureView = collectionView;
    }
    return _mCarouselPictureView;
}

@end


