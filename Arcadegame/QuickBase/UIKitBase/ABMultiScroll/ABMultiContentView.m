//
//  ABMultiContentView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/5/31.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABMultiContentView.h"

@interface ABMultiContentView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger willScrollIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowLayout;

@end

@implementation ABMultiContentView{
    
    BOOL _shouldWillAppear;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.willScrollIndex = -1;
        self.currentIndex = -1;
        
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
}

- (void)reloadData{
    
    [self setNeedsLayout];
}

- (void)scrollToIndex:(NSInteger)index{
    
    if(self.currentIndex < 0){
        
        self.currentIndex = index;
    }
    
    if(index < [self collectionView:self.collectionView numberOfItemsInSection:0]){
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(numberOfItemsInContentView:)]){
        
        return [self.dataSource numberOfItemsInContentView:self];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(contentView:pageIndex:)]){
        
        UIView *contentView = [self.dataSource contentView:self pageIndex:indexPath.row];
        contentView.frame = collectionViewCell.bounds;
        [collectionViewCell addSubview:contentView];
    }
    
    return collectionViewCell;
     */
    
    NSString *index = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:index];
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:index forIndexPath:indexPath];
    
    if(self.dataSource &&
       [self.dataSource respondsToSelector:@selector(contentView:pageIndex:)]){
        
        UIView *contentView = [self.dataSource contentView:self pageIndex:indexPath.row];
        contentView.frame = collectionViewCell.bounds;
        [collectionViewCell addSubview:contentView];
    }
    
    return collectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.frame.size;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.currentIndex = round(scrollView.contentOffset.x / CGRectGetWidth(self.frame));
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(contentView:didScrollToIndex:)]){
        
        [self.delegate contentView:self didScrollToIndex:self.currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _shouldWillAppear = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat currentPageOffsetX = scrollView.contentOffset.x - CGRectGetWidth(scrollView.frame) * self.willScrollIndex;
    
    if(scrollView.contentOffset.x > 0 &&
       scrollView.contentOffset.x <= scrollView.contentSize.width &&
       _shouldWillAppear &&
       fabs(currentPageOffsetX) > 80.f){
        
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(contentView:willScrollToIndex:)]){
            
            self.willScrollIndex = (currentPageOffsetX > 0) ? (self.willScrollIndex + 1) : (self.willScrollIndex - 1);
            
            [self.delegate contentView:self willScrollToIndex:self.willScrollIndex];
        }
        
        _shouldWillAppear = NO;
    }
}

#pragma mark -

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    if(self.willScrollIndex != currentIndex &&
       self.willScrollIndex > 0){
        
        if(self.delegate &&
           [self.delegate respondsToSelector:@selector(contentView:willScrollToIndex:)]){
            
            [self.delegate contentView:self willScrollToIndex:currentIndex];
        }
    }
    self.willScrollIndex = currentIndex;
}

#pragma mark - Getter

- (UICollectionView *)collectionView{
    
    if(!_collectionView){
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionFlowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionFlowLayout{
    
    if(!_collectionFlowLayout){
        
        _collectionFlowLayout = [UICollectionViewFlowLayout new];
        _collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionFlowLayout.minimumInteritemSpacing = 0;
        _collectionFlowLayout.minimumLineSpacing = 0;
    }
    
    return _collectionFlowLayout;
}

@end
