//
//  SZFinessLastPlayedCell.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessLastPlayedCell.h"

@interface SZFinessLastPlayedCell ()

@property (nonatomic,strong) UIImageView *iconIv;

@property (nonatomic,strong) UILabel *titleL;

@end

@implementation SZFinessLastPlayedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
   
    self.iconIv = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconIv];
    self.iconIv.layer.cornerRadius = 5;
    self.iconIv.layer.masksToBounds = YES;
    self.iconIv.image = IMAGE_NAMED(@"home_arcade_banner_default");
    [self.iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.width.mas_equalTo(60);
    }];
    
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    self.titleL.text = @"守望先锋-A";
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconIv);
        make.top.mas_equalTo(self.iconIv.mas_bottom).offset(5);
        make.width.mas_equalTo(80);
    }];
    self.titleL.font = FONT_SYSTEM(12);
    self.titleL.textColor = UIColor.whiteColor;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
}

@end
