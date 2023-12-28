//
//  AGHotGameCollectionViewCell.m
//  Arcadegame
//
//  Created by rrj on 2023/6/26.
//

#import "AGHotGameCollectionViewCell.h"
#import "AGGradientView.h"
#import "AGCicleHomeRecommendData.h"

@interface AGHotGameCollectionViewCell ()

@property (strong, nonatomic) UIImageView *gameImage;
@property (strong, nonatomic) UILabel *gameName;
@property (strong, nonatomic) UILabel *coinCount;
@property (strong, nonatomic) UILabel *hotLabel;
@property (strong, nonatomic) UIView *backColorView;
@property (strong, nonatomic) UIView *hotView;

@end

@implementation AGHotGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *backColorView = [UIView new];
        //backColorView.backgroundColor = [UIColor clearColor];//[UIColor getColor:@"e57a5d"];
        backColorView.layer.cornerRadius = 16;
        backColorView.clipsToBounds = YES;
        self.backColorView = backColorView;
        
        UIImageView *gameImage = [UIImageView new];
        gameImage.layer.cornerRadius = 10;
        gameImage.clipsToBounds = YES;
        _gameImage = gameImage;
        
        //AGGradientView *gradientView = [[AGGradientView alloc] init];
        //gradientView.colors = @[[UIColor getColor:@"3a0c91" alpha:0], [UIColor getColor:@"000000"]];
        //gradientView.startPoint = CGPointMake(0.5, 0);
        //gradientView.endPoint = CGPointMake(0.5, 1);
        //gradientView.locations = @[@0, @1];
        
        UILabel *gameName = [UILabel new];
        gameName.font = [UIFont systemFontOfSize:14];
        gameName.textColor = [UIColor whiteColor];
        gameName.numberOfLines = 1;
        gameName.lineBreakMode = NSLineBreakByTruncatingTail;
        _gameName = gameName;
        
        UIView *coinView = [UIView new];
        coinView.backgroundColor = [UIColor getColor:@"0d322c"];
        coinView.layer.borderColor = ((UIColor *)[UIColor getColor:@"38d4c1"]).CGColor;
        coinView.layer.borderWidth = 1;
        coinView.layer.cornerRadius = 6;
        
        UIImageView *coinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gold"]];
        
        UILabel *coinCount = [UILabel new];
        coinCount.font = [UIFont systemFontOfSize:14];
        coinCount.textColor = [UIColor whiteColor];
        _coinCount = coinCount;
        
        UIView *hotView = [UIView new];
        hotView.backgroundColor = [UIColor getColor:@"f4746d"];
        hotView.layer.cornerRadius = 6;
        hotView.size = CGSizeMake(78.f, 28.f);
        self.hotView = hotView;
        
        UILabel *hotLabel = [UILabel new];
        hotLabel.font = [UIFont systemFontOfSize:14];
        hotLabel.textColor = [UIColor whiteColor];
        hotLabel.text = @"热玩中";
        hotLabel.hidden = YES;
        self.hotLabel = hotLabel;
        
        [self.contentView addSubview:backColorView];
        [backColorView addSubview:gameImage];
        //[gameImage addSubview:gradientView];
        [backColorView addSubview:gameName];
        [backColorView addSubview:coinView];
        [coinView addSubview:coinIcon];
        [coinView addSubview:coinCount];
        [self.contentView addSubview:hotView];
        [hotView addSubview:hotLabel];
        
        [backColorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        [gameImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
        
        /*
        [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gameImage.mas_centerY);
            make.left.right.bottom.equalTo(gameImage);
        }];
         */
        
        [gameName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.right.lessThanOrEqualTo(gameImage);
            //make.bottom.equalTo(coinView.mas_top).offset(-6);
            make.bottom.equalTo(gameImage).offset(-6);
        }];
        
        coinView.hidden = YES;
        [coinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.bottom.equalTo(gameImage).offset(-6);
            make.height.mas_equalTo(32);
        }];
        
        [coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(4);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.centerY.equalTo(coinView);
        }];
        
        [coinCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coinIcon.mas_right).offset(2);
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(coinView);
        }];
        
        [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(28);
            make.top.mas_equalTo(-10);
            make.width.mas_equalTo(78);
        }];
        
        [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(hotView);
        }];
    }
    
    return self;
}

- (void)setModel:(AGCicleHomeRSegaData *)model {
    _model = model;
    
    [self.gameImage sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];
    self.gameName.text = model.roomName;
    self.coinCount.text = [NSString stringWithFormat:@"%@币", model.cost];
    
    CGSize backColorViewSize = CGSizeMake(self.width, self.height - 14.f);
    NSArray *greeColors = @[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)];
    NSArray *redColors = @[UIColorFromRGB(0xD6814C), UIColorFromRGB(0xF5736E)];
    
    if([[NSString stringSafeChecking:model.status] isEqualToString:@"0"]) {
        
        self.hotLabel.text = @"空闲中";
        self.hotLabel.hidden = NO;
        
        self.hotView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.hotView.size colors:greeColors gradientType:0]];
        self.backColorView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:backColorViewSize colors:greeColors gradientType:0]];
        
    }
    else if([[NSString stringSafeChecking:model.status] isEqualToString:@"1"]){
        
        self.hotLabel.text = @"热玩中";
        self.hotLabel.hidden = NO;
        
        self.hotView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.hotView.size colors:redColors gradientType:0]];
        self.backColorView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:backColorViewSize colors:redColors gradientType:0]];
        
    }
    else if([[NSString stringSafeChecking:model.status] isEqualToString:@"2"]){
        
        self.hotLabel.text = @"维修中";
        self.hotLabel.hidden = NO;
        
        self.hotView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.hotView.size colors:greeColors gradientType:0]];
        self.backColorView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:backColorViewSize colors:greeColors gradientType:0]];
    }
    else {
        self.hotLabel.text = @"";
        self.hotLabel.hidden = YES;
        
        self.hotView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.hotView.size colors:greeColors gradientType:0]];
        self.backColorView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:backColorViewSize colors:greeColors gradientType:0]];
    }
    
    self.hotLabel.hidden = YES;
    self.hotView.hidden = YES;
}


@end
