//
//  AGCoinButton.m
//  Arcadegame
//
//  Created by Abner on 2023/8/12.
//

#import "AGCoinButton.h"

@interface AGCoinButton ()

@property (strong, nonatomic) UIImageView *containerImageView;
@property (strong, nonatomic) UIImageView *leftIconImageView;
@property (strong, nonatomic) UIImageView *rightIconImageView;
@property (strong, nonatomic) UILabel *valueLabel;

@property (assign, nonatomic) CGFloat initailWitdh;

@end

@implementation AGCoinButton

- (instancetype)initWithWealthType:(kAGCoinButtonType)wealthType {
    
    if(self = [super init]) {
        
        [self addSubview:self.containerImageView];
        [self.containerImageView addSubview:self.leftIconImageView];
        [self.containerImageView addSubview:self.rightIconImageView];
        [self.containerImageView addSubview:self.valueLabel];
        
        switch (wealthType) {
            case AGCoinButtonTypePoint:{
                [self.leftIconImageView setImage:IMAGE_NAMED(@"icon-point")];
                break;
            }
            case AGCoinButtonTypeGold:{
                [self.leftIconImageView setImage:IMAGE_NAMED(@"icon-gold")];
                break;
            }
            case AGCoinButtonTypeDiamond:{
                [self.leftIconImageView setImage:IMAGE_NAMED(@"icon-diamond")];
                break;
            }
            default:
                break;
        }
        
        self.size = self.containerImageView.size;
        self.initailWitdh = self.size.width;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftIconImageView.left = 2.f;
    self.rightIconImageView.left = self.width - self.rightIconImageView.width - 4.f;
    
    self.valueLabel.centerY = self.leftIconImageView.centerY = self.rightIconImageView.centerY = self.containerImageView.height / 2.f - 2.f;
    self.valueLabel.centerX = self.containerImageView.width / 2.f;
}

- (void)setValue:(NSString *)value {
    _value = value;
    
    self.valueLabel.text = [NSString stringSafeChecking:value];
    [self.valueLabel sizeToFit];
    
    CGFloat contentWidth = (self.containerImageView.width - self.rightIconImageView.width - self.leftIconImageView.width - 4.f * 4);
    
    if(self.valueLabel.width >= contentWidth) {
        
        self.containerImageView.width += (self.valueLabel.width - contentWidth);
        self.size = self.containerImageView.size;
    }
    else {
        self.containerImageView.width = self.containerImageView.width;
        self.size = self.containerImageView.size;
    }
    
    [self setNeedsLayout];
}

#pragma mark - Getter
- (UIImageView *)leftIconImageView {
    
    if(!_leftIconImageView) {
        
        _leftIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"icon-point")];
    }
    
    return _leftIconImageView;
}

- (UIImageView *)rightIconImageView {
    
    if(!_rightIconImageView) {
        
        _rightIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"icon-plus")];
    }
    
    return _rightIconImageView;
}
    
- (UIImageView *)containerImageView {
    
    if(!_containerImageView) {
        
        UIImage *image = IMAGE_NAMED(@"wealth-button-bg");
        CGFloat strechHor = image.size.width * 0.5;
        CGFloat strechVel = image.size.height * 0.5;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(strechVel, strechHor, strechVel, strechHor) resizingMode:UIImageResizingModeStretch];
        _containerImageView = [[UIImageView alloc] initWithImage:image];
    }
    
    return _containerImageView;
}

- (UILabel *)valueLabel {
    
    if(!_valueLabel) {
        _valueLabel = [UILabel new];
        _valueLabel.font = [UIFont fontWithName:@"Alfa Slab One" size:16.f];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = [UIColor whiteColor];
    }
    
    return _valueLabel;
}

@end
