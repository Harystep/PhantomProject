//
//  BaseTableViewCell.m
//  Abner
//
//  Created by Abner on 15/5/31.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        
        _lineImageView = [UIImageView new];
        _lineImageView.backgroundColor = [UIColor cellLineColor];
        [self addSubview:_lineImageView];
        
        _darkTopLineView = [UIImageView new];
        _darkTopLineView.backgroundColor = [UIColor cellLineColor];
        [self addSubview:_darkTopLineView];
        
        _darkBottomLineView = [UIImageView new];
        _darkBottomLineView.backgroundColor = [UIColor cellLineColor];
        [self addSubview:_darkBottomLineView];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _lineImageView.frame = CGRectMake(kPadding, self.height - 1, self.width - kPadding * 2, 1);
}

- (void)hideTopOrBottomLineView{
    _darkTopLineView.hidden = YES;
    _darkBottomLineView.hidden = YES;
}

- (void)tableViewCellForIndexPath:(NSIndexPath *)indexPath withCellCount:(NSInteger)cellCount{
    if(cellCount == 1){
        
        [self setTopLineView:YES bottomLineView:YES];
    }
    else if(indexPath.row == 0){
        
        [self setTopLineView:YES bottomLineView:NO];
    }
    else if(indexPath.row == (cellCount - 1)){
        
        [self setTopLineView:NO bottomLineView:YES];
    }
    else {
        
        [self setTopLineView:NO bottomLineView:NO];
    }
}

- (void)setTopLineView:(BOOL)isTopLineView bottomLineView:(BOOL)isBottomLineView{
    if(isTopLineView){
        _darkTopLineView.frame = CGRectMake(0, 0, self.width, 1);
    }
    else {
        _darkTopLineView.frame = CGRectZero;
    }
    
    if(isBottomLineView){
        self.lineImageView.frame = CGRectZero;
        _darkBottomLineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
    }
    else {
        _darkBottomLineView.frame = CGRectZero;
    }
}

#pragma mark -
- (CGFloat)tableViewCellHeightForIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

@end
