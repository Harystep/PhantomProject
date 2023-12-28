//
//  CarouselScrollBar.m
//  
//
//  Created by Abner on 14-7-19.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import "CarouselScrollBar.h"

#define CS_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CS_RGB_COLOR_ALPHA(a, b, c, d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define CS_DEFAULT_BACKGROUND_COLOR(a, b) CS_RGB_COLOR_ALPHA(a, a, a, b)

static NSTimeInterval animationTime = 0.2f;
static NSTimeInterval autoAppearTime = 1.2f;

@interface CarouselScrollBar(){
    UIView *_leftBackView;
    UIView *_rightBackView;
    UIView *_leftLineView;
    UIView *_rightLineView;
    
    UILabel *_outputLabel;
    
    UIView *_backView;
    UIView *_sliderView;
    UIView *_tempSliderView;
    NSTimer *_delayTimer;
    
    NSInteger _currentIndex;
    BOOL _isAutoDisappear;
}

@property (nonatomic, assign) CarouselScrollBarType barType;

@end

@implementation CarouselScrollBar
@synthesize isCoherentAnimation;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)barSize{
    self = [super init];
    if(self){
    
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)barSize
               scrollBarType:(CarouselScrollBarType)barType
             andCurrentIndex:(NSInteger)currentIndex{
    
    self = [super init];
    if (self) {
        self.scrollContentCount = 1;
        self.isCoherentAnimation = YES;
        _isAutoDisappear = NO;
        _currentIndex = currentIndex;
        
        self.frame = CGRectMake(0, 20, barSize.width, barSize.height);
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _backView = CS_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        _backView.backgroundColor = CS_DEFAULT_BACKGROUND_COLOR(255, 0.16);
        [self addSubview:_backView];
        
        _leftBackView = CS_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        _rightBackView = CS_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        _leftBackView.backgroundColor = _rightBackView.backgroundColor = CS_DEFAULT_BACKGROUND_COLOR(255, 0.16);
        [self addSubview:_rightBackView];
        [self addSubview:_leftBackView];
        
        _leftLineView = CS_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        _rightLineView = CS_AUTORELEASE([[UIView alloc] initWithFrame:self.bounds]);
        _leftLineView.backgroundColor = _rightLineView.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.1);
        [self addSubview:_leftLineView];
        [self addSubview:_rightLineView];
        
        _outputLabel = CS_AUTORELEASE([[UILabel alloc] initWithFrame:CGRectZero]);
        _outputLabel.textColor = RGB_COLOR_ALPHA(255, 204, 0, 0.5);
        _outputLabel.backgroundColor = [UIColor clearColor];
        _outputLabel.textAlignment = NSTextAlignmentCenter;
        _outputLabel.font = FONT_SYSTEM(9);
        [self addSubview:_outputLabel];
        
        _sliderView = CS_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width/self.scrollContentCount), self.frame.size.height)]);
        _sliderView.backgroundColor = CS_DEFAULT_BACKGROUND_COLOR(255, 0.6);
        [self addSubview:_sliderView];
        
        _tempSliderView = CS_AUTORELEASE([[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width/self.scrollContentCount), self.frame.size.height)]);
        _tempSliderView.backgroundColor = CS_DEFAULT_BACKGROUND_COLOR(255, 0.6);
        _tempSliderView.hidden = YES;
        [self addSubview:_tempSliderView];
        
        [self setScrollBarType:barType];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

- (void)setScrollContentCount:(NSInteger)scrollContentCount{
    _scrollContentCount = scrollContentCount;
    
    CGFloat sliderWidth = self.frame.size.width/self.scrollContentCount;
    _sliderView.frame = CGRectOffset(CGRectMake(0, 0, sliderWidth, self.frame.size.height), _currentIndex*sliderWidth, 0);
    _tempSliderView.frame = CGRectMake(0, 0, sliderWidth, self.frame.size.height);
    
    if(self.barType == SCROLLBAR_STYLE1_TYPE){
        
        [self resetLeftRightOutputFrame:0.f];
    }
}

- (void)resetLeftRightOutputFrame:(CGFloat)offset{
    
    _leftBackView.frame = CGRectMake(0, CGRectGetHeight(self.frame) / 2, CGRectGetMinX(_sliderView.frame), CGRectGetHeight(self.frame) / 2);
    _rightBackView.frame = CGRectMake(CGRectGetMaxX(_sliderView.frame), CGRectGetHeight(self.frame) / 2, self.frame.size.width -  CGRectGetMinX(_sliderView.frame), CGRectGetHeight(self.frame) / 2);
    
    _leftLineView.frame = CGRectMake(CGRectGetMinX(_leftBackView.frame), CGRectGetMinY(_leftBackView.frame) - 0.5, CGRectGetWidth(_leftBackView.frame), 0.5);
    _rightLineView.frame = CGRectMake(CGRectGetMinX(_rightBackView.frame), CGRectGetMinY(_rightBackView.frame) - 0.5, CGRectGetWidth(_rightBackView.frame), 0.5);
    
    _outputLabel.frame = CGRectMake(CGRectGetMinX(_sliderView.frame), CGRectGetMinY(_sliderView.frame) - _outputLabel.font.lineHeight - 2.f, CGRectGetWidth(_sliderView.frame), _outputLabel.font.lineHeight);
    _outputLabel.text = [NSString stringWithFormat:@"%d-%d", @(_currentIndex + 1).intValue, @(self.scrollContentCount).intValue];
}

#pragma mark -
- (void)setScrollBarType:(CarouselScrollBarType)barType{
    
    self.barType = barType;
    
    switch (barType) {
        case SCROLLBAR_CIRCLECORNER_TYPE:{
            self.layer.cornerRadius = self.frame.size.height/2;
            _sliderView.layer.cornerRadius = _sliderView.frame.size.height/2;
            _tempSliderView.layer.cornerRadius = _tempSliderView.frame.size.height/2;
            
            break;
        }
        case SCROLLBAR_SQUARE_TYPE:{
            _backView.backgroundColor = [UIColor whiteColor];
            _backView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5f, CGRectGetWidth(self.frame), 0.5f);
            
            _sliderView.backgroundColor = CS_UIColorFromRGB(0xfecb00);
            _tempSliderView.backgroundColor = CS_UIColorFromRGB(0xfecb00);
            
            break;
        }
        case SCROLLBAR_STYLE1_TYPE:{
            
            _backView.hidden = YES;
            self.clipsToBounds = NO;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
- (void)setBackGround:(id)background sliderBack:(id)sliderBack{
    if([background isKindOfClass:[NSString class]]){
        _backView.layer.contents = (id)[[UIImage imageNamed:(NSString *)background] CGImage];
        _leftBackView.layer.contents = (id)[[UIImage imageNamed:(NSString *)background] CGImage];
        _rightBackView.layer.contents = (id)[[UIImage imageNamed:(NSString *)background] CGImage];
    }
    else if([background isKindOfClass:[UIImage class]]){
        _backView.layer.contents = (id)[(UIImage *)background CGImage];
        _leftBackView.layer.contents = (id)[(UIImage *)background CGImage];
        _rightBackView.layer.contents = (id)[(UIImage *)background CGImage];
    }
    else if([background isKindOfClass:[UIColor class]]){
        _backView.backgroundColor = (UIColor *)background;
        _leftBackView.backgroundColor = (UIColor *)background;
        _rightBackView.backgroundColor = (UIColor *)background;
    }
    
    if([sliderBack isKindOfClass:[NSString class]]){
        _sliderView.layer.contents = (id)[[UIImage imageNamed:(NSString *)sliderBack] CGImage];
        _tempSliderView.layer.contents = (id)[[UIImage imageNamed:(NSString *)sliderBack] CGImage];
    }
    else if([sliderBack isKindOfClass:[UIImage class]]){
        _sliderView.layer.contents = (id)[(UIImage *)sliderBack CGImage];
        _tempSliderView.layer.contents = (id)[(UIImage *)sliderBack CGImage];
    }
    else if([sliderBack isKindOfClass:[UIColor class]]){
        _sliderView.backgroundColor = (UIColor *)sliderBack;
        _tempSliderView.backgroundColor = (UIColor *)sliderBack;
    }
}

#pragma mark -
//currentIndex从零开始
- (void)reloadScrollBarLocation:(CGFloat)scrollOffsetX scrollWidth:(CGFloat)scrollWidth currentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    CGFloat sliderWidth = self.frame.size.width / self.scrollContentCount;
    
    if(self.barType == SCROLLBAR_STYLE1_TYPE){
        
        CGFloat rate = sliderWidth / scrollWidth;
        
        _sliderView.frame = CGRectOffset(CGRectMake(0, 0, sliderWidth, self.frame.size.height), scrollOffsetX * rate, 0);
        
        [self resetLeftRightOutputFrame:ABS(scrollOffsetX)];
        
        return;
    }
    
    float proportion = (scrollOffsetX - scrollWidth)/scrollWidth + currentIndex;
    _sliderView.frame = CGRectOffset(CGRectMake(0, 0, sliderWidth, self.frame.size.height), proportion * sliderWidth, 0);
    
    if(!self.isCoherentAnimation){
        return;
    }
    
    if((currentIndex == (self.scrollContentCount - 1)) && (proportion > currentIndex)){
        
        _tempSliderView.hidden = NO;
        CGRect tempSliderRect = _tempSliderView.frame;
        tempSliderRect.origin.x = -(1-(proportion - currentIndex))*sliderWidth;
        tempSliderRect.size.width = sliderWidth;
        _tempSliderView.frame = tempSliderRect;
    }
    else if((currentIndex == 0) && (proportion < currentIndex)){
        
        _tempSliderView.hidden = NO;
        CGRect tempSliderRect = _tempSliderView.frame;
        tempSliderRect.origin.x = (self.scrollContentCount - fabsf(proportion))*sliderWidth;
        tempSliderRect.size.width = sliderWidth;
        _tempSliderView.frame = tempSliderRect;
    }
    else {
        _tempSliderView.hidden = YES;
    }
}

#pragma mark -
- (void)disappearScrollBar:(BOOL)animated{
    if(animated && _isAutoDisappear){
        if(self.alpha == 1){
            [UIView animateWithDuration:animationTime animations:^{
                self.alpha = 0;
            }];
        }
    }
    else {
        self.alpha = 0;
        _isAutoDisappear = YES;
        [self setNeedsDisplay];
    }
}

- (void)appearScrollBar:(BOOL)animated{
    if(!_isAutoDisappear) return;
    
    if(animated){
        [self startTimer];
        if(self.alpha == 0){
            [UIView animateWithDuration:animationTime animations:^{
                self.alpha = 1;
            }];
        }
    }
    else {
        self.alpha = 1;
    }
}

#pragma mark -
- (void)startTimer{
    if(_delayTimer){
        [_delayTimer invalidate];
        _delayTimer = nil;
    }
    
    _delayTimer = [NSTimer scheduledTimerWithTimeInterval:autoAppearTime target:self selector:@selector(timerEnded:) userInfo:nil repeats:NO];
}

- (void)timerEnded:(id)sender{
    if(_delayTimer){
        [_delayTimer invalidate];
        _delayTimer = nil;
    }
    
    [self disappearScrollBar:YES];
}

@end
