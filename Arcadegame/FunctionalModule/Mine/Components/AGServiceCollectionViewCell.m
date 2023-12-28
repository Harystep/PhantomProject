//
//  AGServiceCollectionViewCell.m
//  Arcadegame
//
//  Created by Sean on 2023/6/11.
//

#import "AGServiceCollectionViewCell.h"
#import "UIColor+THColor.h"
#import "Masonry.h"

@implementation AGServiceItem

- (instancetype)initWithType:(NSString *)type name:(NSString *)name icon:(NSString *)icon {
    if (self = [super init]) {
        _serviceType = type;
        _serviceName = name;
        _serviceIcon = icon;
    }
    
    return self;
}

@end

@interface AGServiceCollectionViewCell ()

@property (strong, nonatomic) UILabel *serviceName;
@property (strong, nonatomic) UIImageView *iconView;

@end

@implementation AGServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor getColor:@"262e42"];
        self.contentView.layer.cornerRadius = 15;
        
        UILabel *serviceName = [UILabel new];
        serviceName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        serviceName.textColor = [UIColor whiteColor];
        _serviceName = serviceName;
        
        UIImageView *iconView = [UIImageView new];
        _iconView = iconView;
        
        [self.contentView addSubview:serviceName];
        [self.contentView addSubview:iconView];
        
        [serviceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([UIScreen mainScreen].bounds.size.width/375 * 35);
            make.centerY.equalTo(iconView);
        }];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-12);
        }];
    }
    
    return self;
}

- (void)setServiceItem:(AGServiceItem *)serviceItem {
    _serviceItem = serviceItem;
    
    self.serviceName.text = serviceItem.serviceName;
    self.iconView.image = [UIImage imageNamed:serviceItem.serviceIcon];
}

@end
