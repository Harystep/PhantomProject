//
//  AGCircleALLCategoryLeftTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCircleALLCategoryLeftTableViewCell.h"

@interface AGCircleALLCategoryLeftTableViewCell ()

@property (strong, nonatomic) UILabel *mContentLabel;

@end

@implementation AGCircleALLCategoryLeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContentLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContentLabel.frame = CGRectMake(12.f, 12.f, self.width - 12.f * 2, self.height - 12.f * 2);
    if(self.isSelected) {
        
        self.mContentLabel.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mContentLabel.size colors:@[UIColorFromRGB(0x2BDD9A), UIColorFromRGB(0x36CBD1)] gradientType:1]];
    }
    else {
        self.mContentLabel.backgroundColor = [UIColor clearColor];
    }
    
    self.mContentLabel.text = [NSString stringSafeChecking:self.data.name];
}

#pragma mark - Getter
- (UILabel *)mContentLabel {
    
    if(!_mContentLabel) {
        
        _mContentLabel = [UILabel new];
        _mContentLabel.font = [UIFont font15];
        _mContentLabel.textColor = [UIColor whiteColor];
        _mContentLabel.textAlignment = NSTextAlignmentCenter;
        
        _mContentLabel.layer.cornerRadius = 7.f;
        _mContentLabel.clipsToBounds = YES;
    }
    
    return _mContentLabel;
}

@end
