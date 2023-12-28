//
//  AGLiveCollectionViewCell.m
//  Arcadegame
//
//  Created by rrj on 2023/6/25.
//

#import "AGLiveCollectionViewCell.h"
#import "AGCicleHomeRecommendData.h"
#import "AGGradientView.h"

@interface AGLiveCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *roomName;
@property (strong, nonatomic) UILabel *liveLabel;
@property (strong, nonatomic) AGGradientView *gradientView;

@end

@implementation AGLiveCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath* roundedImage = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 147, 78) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer* roundedImageShape = [[CAShapeLayer alloc] init];
        [roundedImageShape setPath:roundedImage.CGPath];
        
        UIImageView *mainImage = [UIImageView new];
        mainImage.contentMode = UIViewContentModeScaleAspectFill;
        mainImage.clipsToBounds = YES;
        mainImage.layer.mask = roundedImageShape;
        _imageView = mainImage;
        
        AGGradientView *maskView = [[AGGradientView alloc] init];
        maskView.colors = @[[UIColor getColor:@"45665b" alpha:0], [UIColor getColor:@"171d1b"]];
        maskView.startPoint = CGPointMake(0.5, 0);
        maskView.endPoint = CGPointMake(0.5, 1);
        maskView.locations = @[@0, @1];
        
        AGGradientView *gradientView = [[AGGradientView alloc] init];
        //gradientView.colors = @[[UIColor getColor:@"29df92"], [UIColor getColor:@"36cad2"]];
        gradientView.startPoint = CGPointMake(0.09, 0);
        gradientView.endPoint = CGPointMake(0.89, 1.22);
        gradientView.locations = @[@0, @1];
        gradientView.hidden = YES;
        self.gradientView = gradientView;
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 67, 26) byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        gradientView.layer.mask = shape;
        
        UILabel *liveLabel = [UILabel new];
        liveLabel.textAlignment = NSTextAlignmentCenter;
        liveLabel.font = [UIFont systemFontOfSize:14];
        liveLabel.textColor = [UIColor whiteColor];
        liveLabel.text = @"";
        self.liveLabel = liveLabel;
        
        UIView *liveIcon = [UIView new];
        liveIcon.layer.cornerRadius = 3;
        liveIcon.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _roomName = titleLabel;
        
        [self.contentView addSubview:mainImage];
        [mainImage addSubview:maskView];
        [mainImage addSubview:gradientView];
        [gradientView addSubview:liveLabel];
        //[gradientView addSubview:liveIcon];
        [self.contentView addSubview:titleLabel];
        
        [mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(mainImage);
            make.size.mas_equalTo(CGSizeMake(67, 26));
        }];
        
        /*
        [liveIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.centerY.equalTo(gradientView);
            make.size.mas_equalTo(CGSizeMake(6, 6));
        }];
        */
        
        [liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(gradientView);
            make.centerY.equalTo(gradientView);
        }];
        
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(mainImage);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
        }];
    }
    
    return self;
}

- (void)setModel:(AGCicleHomeRArcadeData *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];
    self.roomName.text = model.roomName;
    
    NSArray *greeColors = @[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)];
    NSArray *redColors = @[UIColorFromRGB(0xD6814C), UIColorFromRGB(0xF5736E)];
    
    if([[NSString stringSafeChecking:model.status] isEqualToString:@"0"]) {
        
        self.liveLabel.text = @"空闲中";
        self.gradientView.hidden = NO;
        
        self.gradientView.colors = greeColors;
    }
    else if([[NSString stringSafeChecking:model.status] isEqualToString:@"1"]){
        
        self.liveLabel.text = @"热玩中";
        self.gradientView.hidden = NO;
        
        self.gradientView.colors = redColors;
    }
    else if([[NSString stringSafeChecking:model.status] isEqualToString:@"2"]){
        
        self.liveLabel.text = @"维修中";
        self.gradientView.hidden = NO;
        
        self.gradientView.colors = greeColors;
    }
    else {
        self.liveLabel.text = @"";
        self.gradientView.hidden = YES;
    }
    
    self.gradientView.hidden = YES;
}

@end
