//
//  AGGameMultiBaseView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/18.
//

#import "AGGameMultiBaseView.h"
#import "AGGameData.h"

@interface AGGameMultiBaseView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *mCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *mCollectionViewFlowLayout;

@end

@implementation AGGameMultiBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.scrollView = self.mCollectionView;
        self.scrollView.scrollEnabled = NO;
        
        [self addSubview:self.mCollectionView];
        [self.mCollectionView registerClass:[AGGameCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AGGameCollectionViewCell class])];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    DLOG(@"scrollViewDidScroll:%@", @(scrollView.contentOffset.y));
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //158 * 202
    CGFloat cellWidth = (collectionView.width - 12.f * 3) / 2.f;
    CGFloat cellHeight = cellWidth * 202.f / 158.f;
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 13;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AGGameCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AGGameCollectionViewCell class]) forIndexPath:indexPath];
    
    collectionCell.data = [NSData data];
    
    return collectionCell;
}

#pragma mark - Getter
- (UICollectionView *)mCollectionView{
    
    if(!_mCollectionView){
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height) collectionViewLayout:self.mCollectionViewFlowLayout];
        
        _mCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mCollectionView.backgroundColor = [UIColor clearColor];
        _mCollectionView.showsVerticalScrollIndicator = NO;
        _mCollectionView.scrollsToTop = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
    }
    
    return _mCollectionView;
}

- (UICollectionViewFlowLayout *)mCollectionViewFlowLayout{
    
    if(!_mCollectionViewFlowLayout){
        
        _mCollectionViewFlowLayout = [UICollectionViewFlowLayout new];
        _mCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mCollectionViewFlowLayout.minimumInteritemSpacing = 12.f;
        _mCollectionViewFlowLayout.minimumLineSpacing = 12.f;
    }
    
    return _mCollectionViewFlowLayout;
}

@end

/**
 * AGGameCollectionViewCell
 */
@interface AGGameCollectionViewCell ()

@property (strong, nonatomic) UILabel *mInfoLabel;
@property (strong, nonatomic) UILabel *mNoticeLabel;
@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIImageView *mImageView;
@property (strong, nonatomic) UIImageView *mBottomImageView;
@property (strong, nonatomic) AGGameCollectionViewInfoView *mInfoView;

@end

@implementation AGGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 8.f;
        
        [self addSubview:self.mContainerView];
        [self addSubview:self.mNoticeLabel];
        
        [self.mContainerView addSubview:self.mImageView];
        [self.mContainerView addSubview:self.mBottomImageView];
        [self.mBottomImageView addSubview:self.mInfoLabel];
        [self.mBottomImageView addSubview:self.mInfoView];
    }
    
    return self;
}

- (void)setData:(NSData *)data {
    _data = data;
    
    self.mNoticeLabel.centerX = self.width / 2;
    [self resetNoticeLabelBackImage:YES];
    
    self.mContainerView.frame = CGRectMake(0.f, self.mNoticeLabel.height / 2.f, self.width, self.height - self.mNoticeLabel.height / 2.f);
    [self resetContainerBackImage:YES];
    
    self.mBottomImageView.left = 6.f;
    self.mBottomImageView.width = self.mContainerView.width - self.mBottomImageView.left * 2;
    self.mBottomImageView.height = 64.f / 146.f * self.mBottomImageView.width;
    self.mBottomImageView.top = self.mContainerView.height - self.mBottomImageView.height - 6.f;
    [self resetBottomImage:YES];
    //game_cell_bottom_hot
    
    self.mImageView.frame = CGRectMake(6.f, 6.f, self.mContainerView.width - 6.f * 2, self.mContainerView.height - 6.f * 2);
    self.mImageView.backgroundColor = [UIColor orangeColor];
    
    self.mInfoLabel.left = 6.f;
    self.mInfoLabel.width = self.mBottomImageView.width;
    self.mInfoLabel.text = @"决战万圣夜W88";
    
    self.mInfoView.left = self.mInfoLabel.left;
    self.mInfoView.info = @"1000币";
    
    self.mInfoLabel.top = (self.mBottomImageView.height - (self.mInfoLabel.height + self.mInfoView.height + 6.f)) / 2.f;
    self.mInfoView.top = self.mInfoLabel.bottom + 6.f;
}

- (void)resetNoticeLabelBackImage:(BOOL)isHot {
    
    if(isHot) {
        self.mNoticeLabel.text = @"热玩中";
        self.mNoticeLabel.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mNoticeLabel.size colors:@[UIColorFromRGB(0xF5736E), UIColorFromRGB(0xD6814C)] gradientType:1]];
    }
    else {
        self.mNoticeLabel.text = @"空闲";
        self.mNoticeLabel.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mNoticeLabel.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:1]];
    }
}

- (void)resetContainerBackImage:(BOOL)isHot {
    
    if(isHot) {
        self.mContainerView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mContainerView.size colors:@[UIColorFromRGB(0xF5736E), UIColorFromRGB(0xD6814C)] gradientType:1]];
    }
    else {
        self.mContainerView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mContainerView.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:1]];
    }
}

- (void)resetBottomImage:(BOOL)isHot {
    
    if(isHot) {
        
        self.mBottomImageView.image = IMAGE_NAMED(@"game_cell_bottom_hot");
    }
    else {
        
        self.mBottomImageView.image = IMAGE_NAMED(@"game_cell_bottom");
    }
}

#pragma mark - Getter
- (UILabel *)mInfoLabel {
    
    if(!_mInfoLabel) {
        
        _mInfoLabel = [UILabel new];
        _mInfoLabel.font = [UIFont font15];
        _mInfoLabel.textColor = [UIColor whiteColor];
        _mInfoLabel.height = _mInfoLabel.font.lineHeight;
    }
    
    return _mInfoLabel;
}

- (UILabel *)mNoticeLabel {
    
    if(!_mNoticeLabel) {
        
        _mNoticeLabel = [UILabel new];
        _mNoticeLabel.font = [UIFont font15];
        _mNoticeLabel.textColor = [UIColor whiteColor];
        _mNoticeLabel.textAlignment = NSTextAlignmentCenter;
        _mNoticeLabel.size = CGSizeMake(81.f, 28.f);
        
        _mNoticeLabel.clipsToBounds = YES;
        _mNoticeLabel.layer.cornerRadius = 5.f;
    }
    
    return _mNoticeLabel;
}

- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 10.f;
        _mContainerView.clipsToBounds = YES;
        
        //_mContainerView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:_mNoticeLabel.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:1]];
    }
    
    return _mContainerView;
}

- (UIImageView *)mImageView {
    
    if(!_mImageView) {
        
        _mImageView = [UIImageView new];
        _mImageView.userInteractionEnabled = YES;
        _mImageView.layer.cornerRadius = 10.f;
    }
    
    return _mImageView;
}

- (UIImageView *)mBottomImageView {
    
    if(!_mBottomImageView) {
        
        _mBottomImageView = [UIImageView new];
        _mBottomImageView.userInteractionEnabled = YES;
    }
    
    return _mBottomImageView;
}

- (AGGameCollectionViewInfoView *)mInfoView {
    
    if(!_mInfoView) {
        
        _mInfoView = [AGGameCollectionViewInfoView new];
    }
    
    return _mInfoView;
}

@end

/**
 * AGGameCollectionViewInfoView
 */
@interface AGGameCollectionViewInfoView ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation AGGameCollectionViewInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5.f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.infoLabel];
    }
    
    return self;
}

- (void)setInfo:(NSString *)info {
    _info = info;
    
    self.iconImageView.left = 4.f;
    
    self.infoLabel.text = info;
    [self.infoLabel sizeToFit];
    
    self.infoLabel.width = (self.infoLabel.width > 103.f) ? 103.f : self.infoLabel.width;
    self.infoLabel.left = self.iconImageView.right + 4.f;
    
    self.height = 27.f;
    self.width = self.infoLabel.right + 4.f;
    
    self.iconImageView.centerY = self.infoLabel.centerY = self.height / 2.f;
}

#pragma mark - Getter
- (UIImageView *)iconImageView {
    
    if(!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_head_btn_gold")];
        _iconImageView.userInteractionEnabled = YES;
    }
    
    return _iconImageView;
}

- (UILabel *)infoLabel {
    
    if(!_infoLabel) {
        
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont font15];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.height = _infoLabel.font.lineHeight;
    }
    
    return _infoLabel;
}

@end
