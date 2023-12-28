//
//  AGIndicatorView.m
//  Arcadegame
//
//  Created by rrj on 2023/6/25.
//

#import "AGIndicatorView.h"

@interface AGIndicatorView ()


@property (strong, nonatomic) NSArray<UIView *> *indicators;

@end

@implementation AGIndicatorView

- (instancetype)initWithCount:(NSUInteger)count {
    if (self = [super init]) {
        _totalCount = count;
        [self initialIndicator];
    }
    
    return self;
}

- (void)initialIndicator {
    [self removeAllSubview];
    NSUInteger indexs = self.totalCount;
    
    if (indexs < 1) return;
    
    NSMutableArray<UIView *> *mArray = [NSMutableArray arrayWithCapacity:indexs];
    
    for (NSInteger i = 0; i < indexs; i++) {
        UIView *dot = [UIView new];
        dot.backgroundColor = [UIColor getColor:@"ffffff" alpha:0.33];
        dot.layer.cornerRadius = 1.5;
        dot.layer.masksToBounds = YES;
        [self addSubview:dot];
        [mArray addObject:dot];
    }
    
    _indicators = [mArray copy];
    
    [_indicators mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
    }];
    
    if(_indicators.count > 1) {
        [_indicators mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:19 leadSpacing:0 tailSpacing:0];
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(indexs * 19 + (indexs - 1) * 4);
    }];
}

- (void)setTotalCount:(NSUInteger)totalCount {
    _totalCount = totalCount;
    [self initialIndicator];
    self.currentIndex = 0;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.indicators makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:[UIColor getColor:@"ffffff" alpha:0.33]];
    
    if (self.indicators.count > 0) {
        [self.indicators objectAtIndex:MAX(MIN(self.indicators.count, currentIndex), 0)].backgroundColor = [UIColor getColor:@"3fe3d6"];
    }
}

@end
