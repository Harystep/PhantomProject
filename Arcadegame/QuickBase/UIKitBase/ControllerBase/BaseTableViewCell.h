//
//  BaseTableViewCell.h
//  Abner
//
//  Created by Abner on 15/5/31.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UIImageView *darkTopLineView;
@property (nonatomic, strong) UIImageView *darkBottomLineView;

- (void)tableViewCellForIndexPath:(NSIndexPath *)indexPath withCellCount:(NSInteger)cellCount;
- (void)hideTopOrBottomLineView;

/**
 *  cell高度怎么科学计算？？？
 */
- (CGFloat)tableViewCellHeightForIndexPath:(NSIndexPath *)indexPath;

@end
