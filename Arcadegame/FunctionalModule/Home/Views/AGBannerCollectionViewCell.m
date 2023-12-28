//
//  AGBannerCollectionViewCell.m
//  Arcadegame
//
//  Created by rrj on 2023/6/25.
//

#import "AGBannerCollectionViewCell.h"
#import "AGCicleHomeRecommendData.h"
#import "AGGradientView.h"

@interface AGBannerCollectionViewCell ()

@property (strong, nonatomic) CarouselImageView *imageView;

@end

@implementation AGBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CarouselImageView *mainImage = [CarouselImageView new];
        //mainImage.contentMode = UIViewContentModeScaleAspectFill;
        mainImage.ignoreCache = YES;
        mainImage.layer.cornerRadius = 10;
        mainImage.clipsToBounds = YES;
        _imageView = mainImage;
        
        UIImage *bgStretchImage = [UIImage imageNamed:@"picture-mask"];
        CGFloat strechHor = bgStretchImage.size.width * 0.5;
        CGFloat strechVel = bgStretchImage.size.height * 0.5;
        UIImageView *maskView = [[UIImageView alloc] initWithImage:[bgStretchImage resizableImageWithCapInsets:UIEdgeInsetsMake(strechVel, strechHor, strechVel, strechHor) resizingMode:UIImageResizingModeStretch]];
        
        AGGradientView *gradientView = [[AGGradientView alloc] init];
        gradientView.colors = @[[UIColor getColor:@"29df92"], [UIColor getColor:@"36cad2"]];
        gradientView.startPoint = CGPointMake(0.09, 0);
        gradientView.endPoint = CGPointMake(0.89, 1.22);
        gradientView.locations = @[@0, @1];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 99, 33) byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        gradientView.layer.mask = shape;
        
        UILabel *liveLabel = [UILabel new];
        liveLabel.font = [UIFont systemFontOfSize:14];
        liveLabel.textColor = [UIColor whiteColor];
        liveLabel.text = @"";
        
        //UIView *liveIcon = [self liveViewIcon];
        
        [self.contentView addSubview:mainImage];
        //[mainImage addSubview:gradientView];
        //[gradientView addSubview:liveLabel];
        //[gradientView addSubview:liveIcon];
        [mainImage addSubview:maskView];
        
        [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        /*
        [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(mainImage);
            make.size.mas_equalTo(CGSizeMake(99, 33));
        }];
        
        [liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.equalTo(gradientView);
        }];
        
        [liveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(liveLabel.mas_right).offset(3);
            make.centerY.equalTo(gradientView);
        }];
         */
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(120);
            make.left.right.bottom.equalTo(mainImage);
        }];
    }
    
    return self;
}

- (UIView *)liveViewIcon {
    UIView *liveContainer = [UIView new];
    
    UIView *liveLine1 = [UIView new];
    liveLine1.backgroundColor = [UIColor whiteColor];
    liveLine1.layer.cornerRadius = 1;
    UIView *liveLine2 = [UIView new];
    liveLine2.backgroundColor = [UIColor whiteColor];
    liveLine2.layer.cornerRadius = 1;
    UIView *liveLine3 = [UIView new];
    liveLine3.backgroundColor = [UIColor whiteColor];
    liveLine3.layer.cornerRadius = 1;
    
    [liveContainer addSubview:liveLine1];
    [liveContainer addSubview:liveLine2];
    [liveContainer addSubview:liveLine3];
    
    [liveLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1.5, 8.36));
        make.left.equalTo(liveContainer);
        make.centerY.equalTo(liveContainer);
    }];
    
    [liveLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1.5, 10.36));
        make.left.equalTo(liveLine1.mas_right).offset(1);
        make.centerY.equalTo(liveContainer);
    }];
    
    [liveLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1.5, 10.36));
        make.left.equalTo(liveLine2.mas_right).offset(1);
        make.centerY.equalTo(liveContainer);
        make.right.equalTo(liveContainer);
        make.top.bottom.equalTo(liveContainer);
    }];
    
    return liveContainer;
}

- (void)setModel:(AGCicleHomeRArcadeData *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];//homeImg
}

- (void)setBannerData:(AGCicleHomeRBannerData *)bannerData {
    _bannerData = bannerData;
    
    [self.contentView layoutIfNeeded];
    [self.imageView setImageWithObject:[NSString stringSafeChecking:bannerData.imgUrl] withPlaceholderImage:[UIImage imageNamed:@"default_square_image"] interceptImageModel:INTERCEPT_CENTER correctRect:nil];
}

@end
