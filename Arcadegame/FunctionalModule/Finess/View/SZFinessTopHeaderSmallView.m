//
//  SZFinessTopHeaderSmallView.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessTopHeaderSmallView.h"
#import "SDCycleScrollView.h"

@interface SZFinessTopHeaderSmallView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerView;

@end


@implementation SZFinessTopHeaderSmallView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
 
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.clipsToBounds = YES;
    self.bannerView.autoScrollTimeInterval = 5.0;
    [self addSubview:self.bannerView];
    self.bannerView.backgroundColor = [UIColor lightTextColor];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_offset(200);
    }];
    self.bannerView.pageControlBottomOffset = 5;
    self.bannerView.imageURLStringsGroup = @[
        @"https://lmg.jj20.com/up/allimg/4k/s/01/21092412041V644-0-lp.jpg",
        @"https://img0.baidu.com/it/u=1517208297,311802284&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500",
        @"https://img2.baidu.com/it/u=2911823515,4254432769&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
    ];
}

@end
