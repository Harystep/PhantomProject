//
//  AGCirclePublishCircleNameTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishCircleNameTableViewCell.h"

@interface AGCirclePublishCircleNameTableViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIImageView *mIconImageView;
@property (strong, nonatomic) UIImageView *mRightImageView;
@property (strong, nonatomic) UILabel *mCircleNameLabel;

@end

@implementation AGCirclePublishCircleNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mIconImageView];
        [self.mContainerView addSubview:self.mRightImageView];
        [self.mContainerView addSubview:self.mCircleNameLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height);
    
    self.mIconImageView.left = 20.f;
    self.mRightImageView.left = self.mContainerView.width - self.mRightImageView.width - 20.f;
    
    self.mCircleNameLabel.left = self.mIconImageView.right + 5.f;
    self.mCircleNameLabel.width = self.mRightImageView.left - self.mIconImageView.right - 5.f * 2;
    
    if(self.mCPCNItem) {
        
        self.mCircleNameLabel.text = self.mCPCNItem.title;
        self.mRightImageView.hidden = YES;
    }
    else {
        
        self.mCircleNameLabel.text = @"请选择圈子";
        self.mRightImageView.hidden = NO;
    }
    
    self.mIconImageView.centerY = self.mRightImageView.centerY = self.mCircleNameLabel.centerY = self.mContainerView.height / 2.f;
}

#pragma mark - getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 10.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (UIImageView *)mIconImageView {
    
    if(!_mIconImageView) {
        
        _mIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"circle_publish_name_icon")];
        //circle_publish_mark_icon
    }
    
    return _mIconImageView;
}

- (UIImageView *)mRightImageView {
    
    if(!_mRightImageView) {
        
        _mRightImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"ag_right_arrow_icon")];
    }
    
    return _mRightImageView;
}

- (UILabel *)mCircleNameLabel {
    
    if(!_mCircleNameLabel) {
        
        _mCircleNameLabel = [UILabel new];
        _mCircleNameLabel.font = [UIFont font14];
        _mCircleNameLabel.textColor = [UIColor whiteColor];
        
        _mCircleNameLabel.height = _mCircleNameLabel.font.lineHeight;
    }
    
    return _mCircleNameLabel;
}

@end

/**
 * AGCirclePublishCircleNameItem
 */
@implementation AGCirclePublishCircleNameItem

+ (AGCirclePublishCircleNameItem *)getCPCNItemWithTitle:(NSString *)title withGroupID:(NSString *)groupID {
    
    AGCirclePublishCircleNameItem *item = [AGCirclePublishCircleNameItem new];
    item.groupID = groupID;
    item.title = title;
    
    return item;
}

@end
