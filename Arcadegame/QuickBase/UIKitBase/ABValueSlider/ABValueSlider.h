//
//  ABValueSlider.h
//  ZhiWei
//
//  Created by Abner on 14-8-5.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SliderTouchType){
    SliderTouchTypeNone = 0,
    SliderTouchTypeBegin,
    SliderTouchTypeEnd,
    SliderTouchTypeMoved,
};

typedef void(^ResetFoucsBlock)(double slideRatio, SliderTouchType touchType);

@interface ABValueSlider : UIView

@property(nonatomic, assign) double sliderValue;
@property(nonatomic, assign) CGFloat sliderWidth;
@property(nonatomic, assign) CGSize sliderSize;

- (id)initWithSize:(CGSize)sliderSize
      currentValue:(CGFloat)currentValue
       withPlusBtn:(BOOL)hasPlusBtn;

- (void)resetSliderWithRatio:(double)slideRatio;
- (void)resetCaptureFocus:(ResetFoucsBlock)foucsBlock;
- (void)setSliderViewEnabled:(BOOL)enabled;

/**
 *  自动隐藏;如果需要自动隐藏和显示,需要首先调用该方法,
 *  并设animated的值为NO
 */
- (void)disappearSlider:(BOOL)animated;
/**
 *  自动显示;该方法配合disappearSlider使用,否则没效果
 */
- (void)appearSlider:(BOOL)animated;

@end
