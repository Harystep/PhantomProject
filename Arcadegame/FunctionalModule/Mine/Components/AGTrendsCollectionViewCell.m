//
//  AGTrendsCollectionViewCell.m
//  Arcadegame
//
//  Created by Sean on 2023/6/11.
//

#import "AGTrendsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface AGTrendsCollectionViewCell ()

@property (strong, nonatomic) UIImageView *bgView;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *commentButton;

@end

@implementation AGTrendsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        
        UIImageView *bgView = [UIImageView new];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        [bgView sd_setImageWithURL:[NSURL URLWithString:@"https://img1.baidu.com/it/u=3080601774,1895389877&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"]];
        self.bgView = bgView;
        
        UIImageView *maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picture-mask"]];
        
        UILabel *detail = [UILabel new];
        detail.font = [UIFont systemFontOfSize:14];
        detail.textColor = [UIColor whiteColor];
        detail.text = @"网页网易有道是中国领先的智能学习公司，致力于提供100%以用户为导向的学习产品和服务。，致力于提供100%以用户为导向的学习产品和服务";
        detail.numberOfLines = 2;
        self.detailLabel = detail;
        
        UIButton *praiseButton = [[UIButton alloc] init];
        praiseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [praiseButton setImage:[UIImage imageNamed:@"circle-praise"] forState:UIControlStateNormal];
        [praiseButton setTitle:@"152" forState:UIControlStateNormal];
        [praiseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.praiseButton = praiseButton;
        
        UIButton *commentButton = [[UIButton alloc] init];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentButton setImage:[UIImage imageNamed:@"circle-comment"] forState:UIControlStateNormal];
        [commentButton setTitle:@"254" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commentButton = commentButton;
        
        [self.contentView addSubview:bgView];
        [self.contentView addSubview:maskView];
        [self.contentView addSubview:detail];
        [self.contentView addSubview:praiseButton];
        [self.contentView addSubview:commentButton];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(119);
        }];
        
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-33);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }];
        
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(detail);
            make.bottom.mas_equalTo(-9);
        }];
        
        [praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentButton.mas_right).offset(10);
            make.centerY.equalTo(commentButton);
        }];
    }
    
    return self;
}

@end
