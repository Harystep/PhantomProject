//
//  AGSettingTableViewCell.m
//  Arcadegame
//
//  Created by Sean on 2023/6/22.
//

#import "AGSettingTableViewCell.h"
#import "Masonry.h"

@implementation AGSettingItem

- (instancetype)initWithType:(NSString *)type name:(NSString *)title icon:(NSString *)icon {
    if (self = [super init]) {
        _settingIcon = icon;
        _settingName = type;
        _settingTitle = title;
    }
    
    return self;
}

@end

@interface AGSettingTableViewCell ()

@property (strong, nonatomic) UIImageView *settingIcon;
@property (strong, nonatomic) UILabel *settingTitle;

@end

@implementation AGSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIView *container = [UIView new];
        container.backgroundColor = [UIColor getColor:@"1d2332"];
        container.layer.cornerRadius = 10;
        container.layer.masksToBounds =YES;
        UIImageView *icon = [UIImageView new];
        _settingIcon = icon;
        UILabel *settingTitle = [UILabel new];
        settingTitle.font = [UIFont systemFontOfSize:15];
        settingTitle.textColor = [UIColor whiteColor];
        _settingTitle = settingTitle;
        UIImageView *forwadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-arrow"]];
        
        [self.contentView addSubview:container];
        [container addSubview:icon];
        [container addSubview:settingTitle];
        [container addSubview:forwadIcon];
        
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(52);
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(container);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        [settingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.centerY.equalTo(container);
        }];
        
        [forwadIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(container);
        }];
    }
    
    return self;
}

- (void)setSetting:(AGSettingItem *)setting {
    _setting = setting;
    
    self.settingIcon.image = [UIImage imageNamed:setting.settingIcon];
    self.settingTitle.text = setting.settingTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
