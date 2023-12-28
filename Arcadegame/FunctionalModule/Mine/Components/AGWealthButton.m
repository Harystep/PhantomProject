//
//  AGWealthButton.m
//  Arcadegame
//
//  Created by rrj on 2023/6/9.
//

#import "AGWealthButton.h"
#import "Masonry.h"

static const NSArray <NSString *> *wealthIcons;

@interface AGWealthButton ()

@property (strong, nonatomic) UILabel *amountLabel;

@end

@implementation AGWealthButton

+ (void)initialize {
    wealthIcons = @[@"icon-point", @"icon-gold", @"icon-diamond"];
}

- (instancetype)initWithWealthType:(AGWealthButtonType)wealthType {
    if (self = [super init]) {
        UIImage *bgStretchImage = [UIImage imageNamed:@"wealth-button-bg"];
        CGFloat strechHor = bgStretchImage.size.width * 0.5;
        CGFloat strechVel = bgStretchImage.size.height * 0.5;
        UIImageView *background = [[UIImageView alloc] initWithImage:[bgStretchImage resizableImageWithCapInsets:UIEdgeInsetsMake(strechVel, strechHor, strechVel, strechHor) resizingMode:UIImageResizingModeStretch]];
        UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:wealthIcons[wealthType]]];
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        UILabel *amountLabel = [[UILabel alloc] init];
        amountLabel.font = [UIFont fontWithName:@"Alfa Slab One" size:16];
        amountLabel.text = @"0";
        amountLabel.textColor = [UIColor whiteColor];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        self.amountLabel = amountLabel;
        UIImageView *extraImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-plus"]];
        
        [self addSubview:background];
        [self addSubview:iconImage];
        [self addSubview:amountLabel];
        [self addSubview:extraImage];
        
        amountLabel.text = @"7.777K";
        [amountLabel sizeToFit];
        CGFloat minOX = amountLabel.width;
        amountLabel.text = @"0";
        
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_lessThanOrEqualTo(minOX);
        }];
        
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(amountLabel.mas_left).offset(- 22 - 2);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(self);
        }];
        
        [extraImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.centerY.equalTo(self);
            make.right.mas_equalTo(-5);
        }];
    }
    
    return self;
}

- (void)setAmount:(NSString *)amount {
    
    self.amountLabel.text = [HelpTools checkNumberInfo:amount];
}

@end
