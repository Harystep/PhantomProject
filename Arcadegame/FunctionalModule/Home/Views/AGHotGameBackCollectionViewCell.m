//
//  AGHotGameBackCollectionViewCell.m
//  Arcadegame
//
//  Created by rrj on 2023/6/26.
//

#import "AGHotGameBackCollectionViewCell.h"
#import "AGCicleHomeRecommendData.h"

@interface AGHotGameBackCollectionViewCell ()

@property (strong, nonatomic) CarouselImageView *backImageView;

@end

@implementation AGHotGameBackCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CarouselImageView *backImageView = [CarouselImageView new];
        backImageView.layer.cornerRadius = 20.f;
        backImageView.clipsToBounds = YES;
        backImageView.ignoreCache = YES;
        self.backImageView = backImageView;
        
        [self.contentView addSubview:backImageView];
//
//        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self.contentView);
//            make.left.mas_equalTo(12);
//            make.right.mas_equalTo(-12);
//        }];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backImageView.frame = CGRectMake(12.f, 0.f, self.contentView.width - 12.f * 2, self.contentView.height);
    [self.backImageView setImageWithObject:[NSString stringSafeChecking:self.bannerModel.imgUrl] withPlaceholderImage:[UIImage imageNamed:@"default_square_image"] interceptImageModel:INTERCEPT_CENTER correctRect:nil];
}

- (void)setModel:(AGCicleHomeRSegaData *)model {
    _model = model;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.roomImg]];
}

@end
