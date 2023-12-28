//
//  ABValueSlider.m
//  ZhiWei
//
//  Created by Abner on 14-8-5.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import "ABValueSlider.h"

#define DEFAULT_BACKGROUND_COLOR(a, b) [UIColor colorWithRed:a/255.0 green:a/255.0 blue:a/255.0 alpha:b]
#define ABVS_RGB_COLOR(a, b, c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

static NSTimeInterval animationTime = 0.2f;
static NSTimeInterval autoAppearTime = 1.2f;
static CGFloat zoomInterval = 5.0f;

@interface ABValueSlider(){
    UIView *_tempSliderBackView;
    UIView *_sliderBackView;
    UIView *_sliderView;
    NSTimer *_delayTimer;
    
    CGFloat _currentValue;
    CGPoint _touchBeginPoint;
    CGFloat _zoomButtonWidth;
    BOOL _isAutoDisappear;
    BOOL _hasPlusBtn;
    BOOL _isEnabled;
    
    ResetFoucsBlock _foucsBlock;
}

@end

@implementation ABValueSlider
@synthesize sliderWidth = _sliderWidth;

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithSize:(CGSize)sliderSize
      currentValue:(CGFloat)currentValue
       withPlusBtn:(BOOL)hasPlusBtn{
    self = [super init];
    if(self){
        _isEnabled = YES;
        _foucsBlock = nil;
        _isAutoDisappear = NO;
        _touchBeginPoint = CGPointZero;
        _currentValue = currentValue;
        _hasPlusBtn = hasPlusBtn;
        _sliderWidth = 15.0;
        _zoomButtonWidth = 15.0;
        
        [self setSliderSize:sliderSize];
    }
    return self;
}

- (void)setSliderSize:(CGSize)sliderSize{
    
    if(_hasPlusBtn){
        self.frame = CGRectMake(0, 0, sliderSize.width + (_zoomButtonWidth + 10)*2, MAX(_sliderWidth, sliderSize.height));
    }
    else {
        self.frame = CGRectMake(0, 0, sliderSize.width, MAX(_sliderWidth, sliderSize.height));
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    //-----------------------------------------------------------------------
    if(!_sliderBackView){
        _sliderBackView = [[UIView alloc] init];
        _sliderBackView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _sliderBackView.backgroundColor = DEFAULT_BACKGROUND_COLOR(255, 0.16);
        _sliderBackView.layer.cornerRadius = sliderSize.height/2;
        [self addSubview:_sliderBackView];
    }
    
    _sliderBackView.frame = CGRectMake((_zoomButtonWidth + 10), (MAX(_sliderWidth, sliderSize.height) - sliderSize.height)/2, sliderSize.width, sliderSize.height);
    if(!_hasPlusBtn){
        _sliderBackView.frame = CGRectMake(0, (MAX(_sliderWidth, sliderSize.height) - sliderSize.height)/2, sliderSize.width, sliderSize.height);
    }
    //-----------------------------------------------------------------------
    if(!_tempSliderBackView){
        _tempSliderBackView = [[UIView alloc] init];
        _tempSliderBackView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        _tempSliderBackView.backgroundColor = ABVS_RGB_COLOR(24, 191, 232);
        _tempSliderBackView.layer.cornerRadius = sliderSize.height/2;
    }
    
    if(!_hasPlusBtn){
        CGRect tempSliderRect = CGRectMake(0, 0, _sliderBackView.bounds.size.width, _sliderBackView.bounds.size.height);
        tempSliderRect.size.width = 0;
        
        _tempSliderBackView.frame = tempSliderRect;
        
        [_sliderBackView addSubview:_tempSliderBackView];
    }
    //-----------------------------------------------------------------------
    if(!_sliderView){
        _sliderView = [[UIView alloc] init];
        _sliderView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        if(!_hasPlusBtn){
            _sliderView.layer.contents = (id)[[UIImage imageNamed:@"sliderImage.png"] CGImage];
            _sliderView.clipsToBounds = YES;
        }
        else {
            _sliderView.backgroundColor = DEFAULT_BACKGROUND_COLOR(255, 1);
            _sliderView.layer.cornerRadius = self.sliderWidth/2;
        }
        
        [_sliderBackView addSubview:_sliderView];
    }
    _sliderView.frame = CGRectMake(0, 0, self.sliderWidth, self.sliderWidth);
    //-(self.sliderWidth-_sliderBackView.bounds.size.height)/2
    _sliderView.center = CGPointMake(0, _sliderBackView.bounds.size.height/2);
    //-----------------------------------------------------------------------
    if(_hasPlusBtn){
        [self setZoomButton:_sliderBackView.frame];
    }
    [_sliderBackView bringSubviewToFront:_sliderView];
}

#pragma mark - Add ZoomButton
- (void)setZoomButton:(CGRect)relativeRect{
    CGFloat padding = 10;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, (self.frame.size.height - _zoomButtonWidth)/2, _zoomButtonWidth, _zoomButtonWidth);
    leftButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"scan_zoomBotton_samll.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetMaxX(relativeRect) + padding, (self.frame.size.height - _zoomButtonWidth)/2, _zoomButtonWidth, _zoomButtonWidth);
    rightButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"scan_zoomBotton_big.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

- (void)leftButtonAction:(id)sender{
    CGPoint tempCenter = _sliderView.center;
    tempCenter.x -= zoomInterval;
    
    [self resetSliderCenter:tempCenter withTouchType:SliderTouchTypeNone selfAction:YES];
}

- (void)rightButtonAction:(id)sender{
    CGPoint tempCenter = _sliderView.center;
    tempCenter.x += zoomInterval;
    
    [self resetSliderCenter:tempCenter withTouchType:SliderTouchTypeNone selfAction:YES];
}

#pragma mark - Touch Respose
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!_isEnabled){
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:_sliderBackView];
    if(CGRectContainsPoint(_sliderView.frame, touchPoint)){
        _touchBeginPoint = touchPoint;
        CGPoint centerPoint = CGPointMake(touchPoint.x, _sliderView.center.y);
        [self resetSliderCenter:centerPoint withTouchType:SliderTouchTypeBegin selfAction:YES];
    }
    else {
        _touchBeginPoint = CGPointZero;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self sliderCenter:touches withTouchType:SliderTouchTypeMoved];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self sliderCenter:touches withTouchType:SliderTouchTypeEnd];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self sliderCenter:touches withTouchType:SliderTouchTypeEnd];
}

- (void)sliderCenter:(NSSet *)touches withTouchType:(SliderTouchType)touchType{
    if(!CGPointEqualToPoint(_touchBeginPoint, CGPointZero)){
        CGPoint touchPoint = [[touches anyObject] locationInView:_sliderBackView];
        CGPoint centerPoint = CGPointMake(touchPoint.x, _sliderView.center.y);
        
        [self resetSliderCenter:centerPoint withTouchType:touchType selfAction:YES];
    }
}

#pragma mark - Privated
- (void)resetSliderCenter:(CGPoint)centerPoint withTouchType:(SliderTouchType)touchType selfAction:(BOOL)isYes{
    
    if(!_isEnabled) return;
    if(centerPoint.x > (_sliderBackView.bounds.size.width - _sliderWidth/2)) return;
    if(centerPoint.x < _sliderWidth/2) return;
    
    _sliderView.center = centerPoint;
    
    CGRect tempSliderRect = _tempSliderBackView.frame;
    tempSliderRect.size.width = centerPoint.x;
    _tempSliderBackView.frame = tempSliderRect;
    
    [self appearSlider:YES];
    
    if(isYes) {
        double slodeRatio = (centerPoint.x - _sliderWidth/2)/(_sliderBackView.bounds.size.width - _sliderWidth);
        self.sliderValue = slodeRatio;
        
        if(_foucsBlock){
            _foucsBlock(slodeRatio, touchType);
        }
    }
}

#pragma mark - Interface
- (void)setSliderViewEnabled:(BOOL)enabled{
    _isEnabled = enabled;
}

- (void)resetCaptureFocus:(ResetFoucsBlock)foucsBlock{
    if(foucsBlock){
        _foucsBlock = [foucsBlock copy];
    }
}

- (void)resetSliderWithRatio:(double)slideRatio{
    self.sliderValue = slideRatio;
    
    CGFloat point_x = (slideRatio == 0)?(_sliderWidth/2):((_sliderBackView.bounds.size.width - _sliderWidth/2)*slideRatio);
    CGPoint centerPoint = CGPointMake(point_x, _sliderView.center.y);
    
    [self resetSliderCenter:centerPoint withTouchType:SliderTouchTypeNone selfAction:NO];
}

- (void)disappearSlider:(BOOL)animated{
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
    }
}

- (void)appearSlider:(BOOL)animated{
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
    
    [self disappearSlider:YES];
}

@end
