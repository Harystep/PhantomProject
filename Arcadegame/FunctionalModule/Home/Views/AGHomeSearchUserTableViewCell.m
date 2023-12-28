//
//  AGHomeSearchUserTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGHomeSearchUserTableViewCell.h"

@interface AGHomeSearchUserTableViewCell ()

@property (strong, nonatomic) UIView *mSContainerView;

@property (strong, nonatomic) CarouselImageView *mSUserIconImageView;
@property (strong, nonatomic) UILabel *mSUserNameLabel;

@end

@implementation AGHomeSearchUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mSContainerView];
        
        [self.mSContainerView addSubview:self.mSUserIconImageView];
        [self.mSContainerView addSubview:self.mSUserNameLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mSContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height - 10.f);
    
    self.mSUserIconImageView.size = CGSizeMake(self.mSContainerView.height - 10.f, self.mSContainerView.height - 10.f);
    self.mSUserIconImageView.left = 10.f;
    [self.mSUserIconImageView setImageWithObject:[NSString stringSafeChecking:@"https://img.ssjww100.com/1675936289203.jpg"] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    if(self.mSUserIconImageView.layer.cornerRadius == 0.f) {
        
        self.mSUserIconImageView.layer.cornerRadius = self.mSUserIconImageView.height / 2.f;
    }
    
    self.mSUserNameLabel.left = self.mSUserIconImageView.right + 10.f;
    self.mSUserNameLabel.width = self.mSContainerView.width - (self.mSUserIconImageView.right + 10.f) - 10.f;
    self.mSUserNameLabel.text = [NSString stringSafeChecking:@"少数大石街道"];
    
    self.mSUserNameLabel.centerY = self.mSUserIconImageView.centerY = self.mSContainerView.height / 2.f;
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

- (CarouselImageView *)mSUserIconImageView {
    
    if(!_mSUserIconImageView) {
        
        _mSUserIconImageView = [CarouselImageView new];
        _mSUserIconImageView.userInteractionEnabled = YES;
        _mSUserIconImageView.clipsToBounds = YES;
        _mSUserIconImageView.ignoreCache = YES;
    }
    
    return _mSUserIconImageView;
}

- (UILabel *)mSUserNameLabel {
    
    if(!_mSUserNameLabel) {
        
        _mSUserNameLabel = [UILabel new];
        _mSUserNameLabel.font = [UIFont font14];
        _mSUserNameLabel.textColor = [UIColor whiteColor];
        
        _mSUserNameLabel.height = _mSUserNameLabel.font.lineHeight;
    }
    
    return _mSUserNameLabel;
}

@end
