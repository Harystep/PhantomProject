//
//  SZFinessPlayedItemCell.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessPlayedItemCell.h"
#import "SZFinessLastPlayedCell.h"

@interface SZFinessPlayedItemCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation SZFinessPlayedItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)finessPlayedItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SZFinessPlayedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZFinessPlayedItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = UIColorFromRGB(0x1D2332);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.contentView).inset(10);
        make.top.mas_equalTo(self.contentView);
    }];
    self.bgView.layer.cornerRadius = 10;
    
    [self.bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).inset(10);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZFinessLastPlayedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SZFinessLastPlayedCell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.itemSize = CGSizeMake(80, 100);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[SZFinessLastPlayedCell class] forCellWithReuseIdentifier:@"SZFinessLastPlayedCell"];
    }
    return _collectionView;
}

@end
