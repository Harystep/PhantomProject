//
//  SZFinessItemCell.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessItemCell.h"

@interface SZFinessItemCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *subL;

@property (nonatomic,strong) UIButton *jumpBtn;

@property (nonatomic,strong) UIView *bgView;

@end

@implementation SZFinessItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)finessItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    SZFinessItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SZFinessItemCell" forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = UIColorFromRGB(0x1D2332);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.mas_equalTo(self.contentView).inset(10);
        make.top.mas_equalTo(self.contentView);
    }];
    self.bgView.layer.cornerRadius = 10;
    
    self.iconIv = [[UIImageView alloc] init];
    [self.bgView addSubview:self.iconIv];
    self.iconIv.image = IMAGE_NAMED(@"home_arcade_banner_default");
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bgView.mas_leading).offset(15);
        make.height.width.mas_equalTo(80);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
    }];
    self.iconIv.contentMode = UIViewContentModeScaleAspectFill;
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.layer.cornerRadius = 10;
    
    self.titleL = [[UILabel alloc] init];
    [self.bgView addSubview:self.titleL];
    self.titleL.text = @"守望先锋-A";
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
        make.top.mas_equalTo(self.iconIv.mas_top).offset(5);
    }];
    self.titleL.font = FONT_BOLD_SYSTEM(14);
    self.titleL.textColor = UIColor.whiteColor;
    
    self.subL = [[UILabel alloc] init];
    [self.bgView addSubview:self.subL];
    self.subL.text = @"10万人下载 9.8万人玩过";
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIv.mas_trailing).offset(10);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(8);
    }];
    self.subL.font = FONT_SYSTEM(13);
    self.subL.textColor = UIColor.whiteColor;
    
    self.jumpBtn = [[UIButton alloc] init];
    [self.bgView addSubview:self.jumpBtn];
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.trailing.mas_equalTo(self.bgView.mas_trailing).inset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(26);
    }];
    [self.jumpBtn setTitle:@"进入" forState:UIControlStateNormal];
    [self.jumpBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.jumpBtn.titleLabel.font = FONT_SYSTEM(15);
    self.jumpBtn.backgroundColor = UIColorFromRGB(0x2BDD9A);
    self.jumpBtn.layer.cornerRadius = 5;
    self.jumpBtn.layer.masksToBounds = YES;
    
}


@end
