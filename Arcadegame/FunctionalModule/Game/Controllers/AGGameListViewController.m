//
//  AGGameListViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGGameListViewController.h"
#import "AGGameMultiBaseView.h"

@interface AGGameListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *mCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *mCollectionViewFlowLayout;

@end

@implementation AGGameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"游戏列表";
    
    [self.view addSubview:self.mCollectionView];
    [self.mCollectionView registerClass:[AGGameCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AGGameCollectionViewCell class])];
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
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.frame)) collectionViewLayout:self.mCollectionViewFlowLayout];
        
        _mCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mCollectionView.backgroundColor = [UIColor clearColor];
        _mCollectionView.showsVerticalScrollIndicator = NO;
        _mCollectionView.scrollsToTop = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){
            _mCollectionView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
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
