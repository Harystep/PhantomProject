//
//  AGSegmentControl.m
//  Arcadegame
//
//  Created by rrj on 2023/6/6.
//

#import "AGSegmentControl.h"
#import "UIColor+THColor.h"
#import "Masonry.h"

@implementation AGSegmentItem

- (instancetype)initWithTitle:(NSString *)title callback:(AGSegmentCallback)callback {
    if (self = [super init]) {
        _title = title;
        _callback = callback;
    }
    
    return self;
}

@end

@interface AGSegmentControl()

@property (assign, nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) NSArray<UIButton *> *segmentButtons;
@property (strong, nonatomic) NSArray<AGSegmentItem *> *segments;
@property (strong, nonatomic) UIView *indicator;
@property (assign, nonatomic) AGSegmentControlStyle mStyle;

@end

@implementation AGSegmentControl

- (instancetype)initWithSegments:(NSArray<AGSegmentItem *> *)segments style:(AGSegmentControlStyle)style {
    if (self = [super init]) {
        _currentIndex = 0;
        _segments = [segments copy];
        self.mStyle = style;
        NSUInteger segmentCount = segments.count;
        NSMutableArray<UIView *> *segmentButtons = [NSMutableArray arrayWithCapacity:segmentCount];
        
        UIView *lastView;
        
        UIView *indicator = [[UIView alloc] init];
        indicator.size = CGSizeMake(26, 3);
        if(style == AGSegmentControlStyleLight) {
            
            indicator.backgroundColor = [UIColor whiteColor];
        }
        else {
            indicator.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:indicator.size colors:@[UIColorFromRGB(0x30E79A), UIColorFromRGB(0x43E1EA)] gradientType:1]];
        }
        
        indicator.layer.cornerRadius = 3.f / 2.f;
        indicator.layer.masksToBounds = YES;
        [self addSubview:indicator];
        _indicator = indicator;
        
        for (NSInteger i = 0; i < segmentCount; i++) {
            AGSegmentItem *segment = segments[i];
            UIView *tabContainer = [[UIView alloc] init];
            UIButton *tabButton = [[UIButton alloc] init];
            [tabButton setTitle:segment.title forState:UIControlStateNormal];
            tabButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
            [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tabButton addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
            [tabContainer addSubview:tabButton];
            [self addSubview:tabContainer];
            [segmentButtons addObject:tabButton];
            
            [tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(tabContainer);
            }];
            
            [tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self);
                } else {
                    make.left.equalTo(lastView.mas_right);
                }
                
                make.top.bottom.mas_equalTo(0);
                if (lastView) {
                    make.width.equalTo(lastView.mas_width);
                }
            
                if (i == segmentCount - 1) {
                    make.right.equalTo(self);
                }
            }];
            
            lastView = tabContainer;
            
            if (_currentIndex == i) {
                [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(26, 3));
                    make.centerX.equalTo(tabButton);
                    make.bottom.equalTo(self);
                }];
                
                [self setSelectedStyle:tabButton];
            }
        }
        
        _segmentButtons = [segmentButtons copy];

    }
    
    return self;
}

- (instancetype)initWithSegments:(NSArray<AGSegmentItem *> *)segments {
    return [self initWithSegments:segments style:AGSegmentControlStyleLight];
}

- (void)resetSegments:(NSArray<AGSegmentItem *> *)segments {
    
    if(segments.count) {
        
        _segmentButtons = @[].copy;
        [self removeAllSubview];
        
        _currentIndex = 0;
        _segments = [segments copy];
        NSUInteger segmentCount = segments.count;
        NSMutableArray<UIView *> *segmentButtons = [NSMutableArray arrayWithCapacity:segmentCount];
        
        UIView *lastView;
        
        UIView *indicator = [[UIView alloc] init];
        indicator.size = CGSizeMake(26, 3);
        indicator.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:indicator.size colors:@[UIColorFromRGB(0x30E79A), UIColorFromRGB(0x43E1EA)] gradientType:1]];
        indicator.layer.cornerRadius = 3.f / 2.f;
        indicator.layer.masksToBounds = YES;
        [self addSubview:indicator];
        _indicator = indicator;
        
        for (NSInteger i = 0; i < segmentCount; i++) {
            AGSegmentItem *segment = segments[i];
            UIView *tabContainer = [[UIView alloc] init];
            UIButton *tabButton = [[UIButton alloc] init];
            [tabButton setTitle:segment.title forState:UIControlStateNormal];
            tabButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            [tabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tabButton addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
            [tabContainer addSubview:tabButton];
            [self addSubview:tabContainer];
            [segmentButtons addObject:tabButton];
            
            [tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(tabContainer);
            }];
            
            [tabContainer mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self);
                } else {
                    make.left.equalTo(lastView.mas_right);
                }
                
                make.top.bottom.mas_equalTo(0);
                if (lastView) {
                    make.width.equalTo(lastView.mas_width);
                }
            
                if (i == segmentCount - 1) {
                    make.right.equalTo(self);
                }
            }];
            
            lastView = tabContainer;
            
            if (_currentIndex == i) {
                [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(26, 3));
                    make.centerX.equalTo(tabButton);
                    make.bottom.equalTo(self);
                }];
                
                [self setSelectedStyle:tabButton];
            }
        }
        
        _segmentButtons = [segmentButtons copy];
    }
}

- (void)animatedToIndex:(NSInteger)index {
    self.currentIndex = index;
    AGSegmentItem *segItem = [self.segments objectAtIndex:index];
    UIButton *segmentButton = [self.segmentButtons objectAtIndex:index];
    if (segItem.callback) segItem.callback(segItem, index);
    
    __WeakObject(self);
    [self.segmentButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __WeakStrongObject();
        
        if(idx == index) {
            
            [__strongObject setSelectedStyle:obj];
        }
        else {
            [__strongObject setNomarlStyle:obj];
        }
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 3));
            make.centerX.equalTo(segmentButton);
            make.bottom.equalTo(self);
        }];
        
        [self layoutIfNeeded];
    }];
}

- (void)onTabClick:(UIButton *)button {
    NSUInteger nextIndex = [self.segmentButtons indexOfObject:button];
    if (nextIndex == self.currentIndex) return;
    
    [self animatedToIndex:nextIndex];
}

- (void)setNomarlStyle:(UIButton *)button {
    
    button.titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightRegular];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSelectedStyle:(UIButton *)button {
    
    button.titleLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
    
    if(AGSegmentControlStyleLight == self.mStyle) {
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [button setTitleColor:UIColorFromRGB(0x32E7A2) forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    NSLog(@"delloc agseg!!");
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self animatedToIndex:selectedIndex];
}

@end
