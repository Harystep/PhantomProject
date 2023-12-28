//
//  QBTableStyleCollectionLayout.h
//  QuickBase
//
//  Created by Abner on 2019/12/3.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QBTableStyleCollectionLayoutDelegate <NSObject>

@required
- (CGSize)sizeForCellOfCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)lineSpacingForCellOfCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)lineSpacingForSectionOfCollectionView:(UICollectionView *)collectionView inSection:(NSInteger)section;
- (CGFloat)columnSpacingForCellOfCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

/*
 *  UITableView样式结合瀑布流风格
 */
@interface QBTableStyleCollectionLayout : UICollectionViewLayout

@property (nonatomic, assign) id<QBTableStyleCollectionLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat columnSpacing; // 列
@property (nonatomic, assign) UIEdgeInsets contentInset; // 内边距

@end

NS_ASSUME_NONNULL_END
