//
//  AGHomeSearchCircleTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGHomeSearchCircleTableViewCell.h"

@interface AGHomeSearchCircleTableViewCell ()

@property (strong, nonatomic) UIView *mSContainerView;
@property (strong, nonatomic) CarouselImageView *mSCircleImageView;

@property (strong, nonatomic) UILabel *mSCircleNameLabel;
@property (strong, nonatomic) UILabel *mSCircleInfoLabel;

@property (strong, nonatomic) UILabel *mSCircleContentInfoLabel;
@property (strong, nonatomic) UILabel *mSCirclePersonInfoLabel;

@end

@implementation AGHomeSearchCircleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mSContainerView];
        
        [self.mSContainerView addSubview:self.mSCircleContentInfoLabel];
        [self.mSContainerView addSubview:self.mSCirclePersonInfoLabel];
        [self.mSContainerView addSubview:self.mSCircleImageView];
        [self.mSContainerView addSubview:self.mSCircleNameLabel];
        [self.mSContainerView addSubview:self.mSCircleInfoLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mSContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height - 10.f);
    
    self.mSCircleImageView.size = CGSizeMake(self.mSContainerView.height - 10.f, self.mSContainerView.height - 10.f);
    self.mSCircleImageView.left = 10.f;
    self.mSCircleImageView.centerY = self.mSContainerView.height / 2.f;
    [self.mSCircleImageView setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    CGFloat oringinY = (self.mSContainerView.height - (self.mSCircleNameLabel.height + 10.f + self.mSCircleInfoLabel.height + 10.f + self.mSCirclePersonInfoLabel.height)) / 2.f;
    
    self.mSCircleNameLabel.top = oringinY;
    self.mSCircleNameLabel.left = self.mSCircleImageView.right + 10.f;
    self.mSCircleNameLabel.width = self.mSContainerView.width - self.mSCircleImageView.right - 10.f * 2;
    self.mSCircleNameLabel.text = @"阿卡卡卡技术";
    
    self.mSCircleInfoLabel.top = self.mSCircleNameLabel.bottom + 10.f;
    self.mSCircleInfoLabel.left = self.mSCircleNameLabel.left;
    self.mSCircleInfoLabel.width = self.mSCircleNameLabel.width;
    self.mSCircleInfoLabel.text = @"啊哈交换空间卡建卡户";
    
    self.mSCirclePersonInfoLabel.text = [NSString stringWithFormat:@"%@人已加入", @(4)];
    [self.mSCirclePersonInfoLabel sizeToFit];
    
    self.mSCirclePersonInfoLabel.top = self.mSCircleInfoLabel.bottom + 10.f;
    self.mSCirclePersonInfoLabel.left = self.mSCircleInfoLabel.left;
    
    self.mSCircleContentInfoLabel.text = [NSString stringWithFormat:@"%@篇内容", @(4)];
    [self.mSCircleContentInfoLabel sizeToFit];
    
    self.mSCircleContentInfoLabel.left = self.mSCirclePersonInfoLabel.right + 10.f;
    self.mSCircleContentInfoLabel.centerY = self.mSCirclePersonInfoLabel.centerY;
}

#pragma mark - Getter
- (UIView *)mSContainerView {
    
    if(!_mSContainerView) {
        
        _mSContainerView = [UIView new];
        _mSContainerView.layer.cornerRadius = 10.f;
        _mSContainerView.backgroundColor = UIColorFromRGB(0x1D2332);
    }
    
    return _mSContainerView;
}

- (CarouselImageView *)mSCircleImageView {
    
    if(!_mSCircleImageView) {
        
        _mSCircleImageView = [CarouselImageView new];
        _mSCircleImageView.layer.cornerRadius = 10.f;
        _mSCircleImageView.userInteractionEnabled = YES;
        _mSCircleImageView.clipsToBounds = YES;
        _mSCircleImageView.ignoreCache = YES;
    }
    
    return _mSCircleImageView;
}

- (UILabel *)mSCircleNameLabel {
    
    if(!_mSCircleNameLabel) {
        
        _mSCircleNameLabel = [UILabel new];
        _mSCircleNameLabel.font = [UIFont font15Bold];
        _mSCircleNameLabel.textColor = [UIColor whiteColor];
        
        _mSCircleNameLabel.height = _mSCircleNameLabel.font.lineHeight;
    }
    
    return _mSCircleNameLabel;
}

- (UILabel *)mSCircleInfoLabel {
    
    if(!_mSCircleInfoLabel) {
        
        _mSCircleInfoLabel = [UILabel new];
        _mSCircleInfoLabel.font = [UIFont font14];
        _mSCircleInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mSCircleInfoLabel.height = _mSCircleInfoLabel.font.lineHeight;
    }
    
    return _mSCircleInfoLabel;
}

- (UILabel *)mSCircleContentInfoLabel {
    
    if(!_mSCircleContentInfoLabel) {
        
        _mSCircleContentInfoLabel = [UILabel new];
        _mSCircleContentInfoLabel.font = [UIFont font12];
        _mSCircleContentInfoLabel.textColor = [UIColor whiteColor];
        
        _mSCircleContentInfoLabel.height = _mSCircleContentInfoLabel.font.lineHeight;
    }
    
    return _mSCircleContentInfoLabel;
}

- (UILabel *)mSCirclePersonInfoLabel {
    
    if(!_mSCirclePersonInfoLabel) {
        
        _mSCirclePersonInfoLabel = [UILabel new];
        _mSCirclePersonInfoLabel.font = [UIFont font12];
        _mSCirclePersonInfoLabel.textColor = [UIColor whiteColor];
        
        _mSCirclePersonInfoLabel.height = _mSCirclePersonInfoLabel.font.lineHeight;
    }
    
    return _mSCirclePersonInfoLabel;
}

@end
