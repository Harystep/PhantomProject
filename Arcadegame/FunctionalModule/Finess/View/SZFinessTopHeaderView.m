//
//  SZFinessTopHeaderView.m
//  Arcadegame
//
//  Created by oneStep on 2023/11/10.
//

#import "SZFinessTopHeaderView.h"
#import "SDCycleScrollView.h"

@interface SZFinessTopHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerView;

@end


@implementation SZFinessTopHeaderView

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
        make.height.mas_offset(SCREENWIDTH);
    }];
    self.bannerView.pageControlBottomOffset = 5;
    self.bannerView.imageURLStringsGroup = @[
        @"https://lmg.jj20.com/up/allimg/1011/02211G41J1/1F221141J1-23-1200.jpg",
        @"https://img0.baidu.com/it/u=4008206842,2238014399&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
        @"https://img0.baidu.com/it/u=2418337147,41966402&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
        @"https://img0.baidu.com/it/u=2115075941,3919187756&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
    ];
}

@end
