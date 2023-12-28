//
//  AGCircleALLCategoryRightTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCircleALLCategoryRightTableViewCell.h"

static const CGFloat kCACRCircleIconHeight = 49.f;

@interface AGCircleALLCategoryRightTableViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) CarouselImageView *mCircleIconImageView;

@property (strong, nonatomic) UILabel *mCircleNameLabel;
@property (strong, nonatomic) UILabel *mCircleInfoLabel;

@property (strong, nonatomic) UILabel *mCircleContentInfoLabel;
@property (strong, nonatomic) UILabel *mCirclePersonInfoLabel;


@end

@implementation AGCircleALLCategoryRightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        
        [self.mContainerView addSubview:self.mCircleContentInfoLabel];
        [self.mContainerView addSubview:self.mCirclePersonInfoLabel];
        [self.mContainerView addSubview:self.mCircleIconImageView];
        [self.mContainerView addSubview:self.mCircleNameLabel];
        [self.mContainerView addSubview:self.mCircleInfoLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height - 10.f);
    
    self.mCircleIconImageView.left = 10.f;
    self.mCircleIconImageView.centerY = self.mContainerView.height / 2.f;
    [self.mCircleIconImageView setImageWithObject:[NSString stringSafeChecking:self.data.coverImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    CGFloat oringinY = (self.height - (self.mCircleNameLabel.height + 10.f + self.mCircleInfoLabel.height + 10.f + self.mCirclePersonInfoLabel.height)) / 2.f;
    
    self.mCircleNameLabel.top = oringinY;
    self.mCircleNameLabel.left = self.mCircleIconImageView.right + 10.f;
    self.mCircleNameLabel.width = self.mContainerView.width - self.mCircleIconImageView.right - 10.f * 2;
    self.mCircleNameLabel.text = [NSString stringSafeChecking:self.data.name];
    
    self.mCircleInfoLabel.top = self.mCircleNameLabel.bottom + 10.f;
    self.mCircleInfoLabel.left = self.mCircleNameLabel.left;
    self.mCircleInfoLabel.width = self.mCircleNameLabel.width;
    self.mCircleInfoLabel.text = [NSString stringSafeChecking:self.data.Description];
    
    self.mCirclePersonInfoLabel.attributedText = [self getAttributeStringWithValue:self.data.userNum defaultS:@"人已加入"];
    [self.mCirclePersonInfoLabel sizeToFit];
    
    self.mCirclePersonInfoLabel.top = self.mCircleInfoLabel.bottom + 10.f;
    self.mCirclePersonInfoLabel.left = self.mCircleInfoLabel.left;
    
    self.mCircleContentInfoLabel.attributedText = [self getAttributeStringWithValue:self.data.postNum defaultS:@"篇内容"];
    [self.mCircleContentInfoLabel sizeToFit];
    
    self.mCircleContentInfoLabel.left = self.mCirclePersonInfoLabel.right + 10.f;
    self.mCircleContentInfoLabel.centerY = self.mCirclePersonInfoLabel.centerY;
}

- (NSMutableAttributedString *)getAttributeStringWithValue:(NSString *)value defaultS:(NSString *)defaultString {
    
    NSMutableAttributedString *attriString = [NSMutableAttributedString new];
    [attriString appendString:[NSString stringSafeChecking:value] font:self.mCirclePersonInfoLabel.font fontColor:UIColorFromRGB(0x32E7A2)];
    [attriString appendString:[NSString stringSafeChecking:defaultString] font:self.mCirclePersonInfoLabel.font fontColor:self.mCirclePersonInfoLabel.textColor];
    
    return attriString;
}

#pragma mark - Getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.layer.cornerRadius = 10.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (CarouselImageView *)mCircleIconImageView {
    
    if(!_mCircleIconImageView) {
        
        _mCircleIconImageView = [CarouselImageView new];
        _mCircleIconImageView.size = CGSizeMake(kCACRCircleIconHeight, kCACRCircleIconHeight);
        _mCircleIconImageView.layer.cornerRadius = _mCircleIconImageView.height / 2.f;
        _mCircleIconImageView.userInteractionEnabled = YES;
        _mCircleIconImageView.clipsToBounds = YES;
        _mCircleIconImageView.ignoreCache = YES;
    }
    
    return _mCircleIconImageView;
}

- (UILabel *)mCircleNameLabel {
    
    if(!_mCircleNameLabel) {
        
        _mCircleNameLabel = [UILabel new];
        _mCircleNameLabel.font = [UIFont font15Bold];
        _mCircleNameLabel.textColor = [UIColor whiteColor];
        
        _mCircleNameLabel.height = _mCircleNameLabel.font.lineHeight;
    }
    
    return _mCircleNameLabel;
}

- (UILabel *)mCircleInfoLabel {
    
    if(!_mCircleInfoLabel) {
        
        _mCircleInfoLabel = [UILabel new];
        _mCircleInfoLabel.font = [UIFont font14];
        _mCircleInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mCircleInfoLabel.height = _mCircleInfoLabel.font.lineHeight;
    }
    
    return _mCircleInfoLabel;
}

- (UILabel *)mCircleContentInfoLabel {
    
    if(!_mCircleContentInfoLabel) {
        
        _mCircleContentInfoLabel = [UILabel new];
        _mCircleContentInfoLabel.font = [UIFont font14];
        _mCircleContentInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mCircleContentInfoLabel.height = _mCircleContentInfoLabel.font.lineHeight;
    }
    
    return _mCircleContentInfoLabel;
}

- (UILabel *)mCirclePersonInfoLabel {
    
    if(!_mCirclePersonInfoLabel) {
        
        _mCirclePersonInfoLabel = [UILabel new];
        _mCirclePersonInfoLabel.font = [UIFont font14];
        _mCirclePersonInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        
        _mCirclePersonInfoLabel.height = _mCirclePersonInfoLabel.font.lineHeight;
    }
    
    return _mCirclePersonInfoLabel;
}

@end
