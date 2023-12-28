//
//  AGHotRecommend.m
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import "AGHotRecommend.h"
#import "Masonry.h"
#import "AGGradientView.h"

static const NSInteger kHotRecommendStaticHeadTag = 10086;
static const NSInteger kHotRecommendBaseTag = 1001;

@interface AGHotRecommend ()

@property (strong, nonatomic) UIStackView *stackView;

@end

@implementation AGHotRecommend

- (instancetype)init {
    if (self = [super init]) {
        AGGradientView *gradientView = [[AGGradientView alloc] init];
        gradientView.colors = @[[UIColor getColor:@"30e69b"], [UIColor getColor:@"2dc7c3"]];
        gradientView.startPoint = CGPointMake(0.5, 0);
        gradientView.endPoint = CGPointMake(0.5, 1);
        gradientView.locations = @[@0, @1];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        self.stackView = stackView;
        
        [self addSubview:gradientView];
        [self addSubview:stackView];
        
        [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *hotTitleView = [[UIView alloc] init];
        hotTitleView.bounds = CGRectMake(0, 0, 0, 30);
        hotTitleView.tag = kHotRecommendStaticHeadTag;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"热门圈子";
        titleLabel.numberOfLines = 1;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [hotTitleView addSubview:titleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-arrow"]];
        [hotTitleView addSubview:arrowImageView];
        
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = [UIColor whiteColor];
        [hotTitleView addSubview:separateLine];
        
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = kHotRecommendStaticHeadTag;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [hotTitleView addSubview:button];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(hotTitleView);
            make.left.equalTo(hotTitleView).offset(6);
            make.right.lessThanOrEqualTo(arrowImageView.mas_left).offset(-2);
        }];
        
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.bottom.equalTo(hotTitleView);
        }];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(hotTitleView);
        }];
        
        [stackView addArrangedSubview:hotTitleView];
        /*
        [stackView addArrangedSubview:[self generateHotItem:@"疯狂魔鬼城"]];
        [stackView addArrangedSubview:[self generateHotItem:@"爱玩圈官方粉丝"]];
        [stackView addArrangedSubview:[self generateHotItem:@"全民推币机"]];
        [stackView addArrangedSubview:[self generateHotItem:@"魔兽世界论坛"]];
         */
    }
    
    return self;
}

- (UIView *)generateHotItem:(NSString *)title {
    UIView *hotView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"# %@", title];
    [hotView addSubview:titleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-arrow"]];
    [hotView addSubview:arrowImageView];
    
    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hotView);
        make.left.equalTo(hotView).offset(6);
        make.right.equalTo(arrowImageView.mas_left).offset(-2);
    }];
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.right.lessThanOrEqualTo(hotView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    return hotView;
}

#pragma mark - Selector
- (void)buttonAction:(UIButton *)button {
    
    if(button.tag == kHotRecommendStaticHeadTag) {
        
        if(self.didSelectedHeadHandle) {
            
            self.didSelectedHeadHandle();
        }
    }
    else {
        NSInteger index = button.tag - kHotRecommendBaseTag;
        
        if(self.didSelectedContentHandle) {
            
            self.didSelectedContentHandle([self.data.data objectAtIndexForSafe:index]);
        }
    }
}

#pragma mark -
- (void)setData:(AGCircleHotListData *)data {
    _data = data;
    [self.stackView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tag != 10086) {
            
            [obj removeFromSuperview];
        }
    }];
    
    NSInteger maxCellCont = 4;
    maxCellCont = data.data.count > maxCellCont ? maxCellCont : data.data.count;
    
    for (int i = 0; i < maxCellCont; ++i) {
        
        AGCircleHotData *hotData = data.data[i];
        UIView *hotView = [self generateHotItem:[NSString stringSafeChecking:hotData.name]];
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kHotRecommendBaseTag + i;
        [hotView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(hotView);
        }];
        
        [self.stackView addArrangedSubview:hotView];
    }
}

@end
