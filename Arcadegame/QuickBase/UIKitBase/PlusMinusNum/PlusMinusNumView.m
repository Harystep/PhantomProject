//
//  PlusMinusNumView.m
//  Abner
//
//  Created by Abner on 15/6/2.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import "PlusMinusNumView.h"

@interface PlusMinusNumView ()

@property (nonatomic, strong) UIButton *minusButton;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *plusButton;

@end

@implementation PlusMinusNumView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.defaultValue = 1;
        self.maxValue = MAXFLOAT;
        self.minValue = 1;
        
        self.shouldEnable = YES;
        
        self.layer.borderColor = UIColorFromRGB(0xD0D0D0).CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 5.f;
        
        [self addSubview:self.plusButton];
        [self addSubview:self.minusButton];
        [self addSubview:self.numberLabel];
        
        CGRect buttonRect = CGRectMake(0, 0, CGRectGetHeight(frame) * 1.3, CGRectGetHeight(frame));
        self.minusButton.frame = buttonRect;
        
        buttonRect.origin.x = CGRectGetWidth(frame) - CGRectGetWidth(buttonRect);
        self.plusButton.frame = buttonRect;
        
        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minusButton.frame), 0, 1.f, CGRectGetHeight(frame))];
        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.plusButton.frame) - 1.f, 0, 1.f, CGRectGetHeight(frame))];
        
        rightLineView.backgroundColor = leftLineView.backgroundColor = UIColorFromRGB(0xD0D0D0);
        [self addSubview:rightLineView];
        [self addSubview:leftLineView];
        
        self.numberLabel.frame = CGRectIntegral(CGRectMake(CGRectGetMaxX(self.minusButton.frame) + 1.f, 0, CGRectGetMinX(self.plusButton.frame) - CGRectGetMaxX(self.minusButton.frame) - 2.f, CGRectGetHeight(frame)));
        self.numberValue = self.defaultValue;
    }
    
    return self;
}

- (void)setNumberValue:(NSInteger)numberValue{
    _numberValue = numberValue;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%@", @(numberValue)];
}

- (void)setShouldEnable:(BOOL)shouldEnable{
    _shouldEnable = shouldEnable;
    
    if(shouldEnable){
        self.numberLabel.textColor = [UIColor blackColor333333];
    }
    else {
        self.numberLabel.textColor = [UIColor grayColor999999];
    }
}

#pragma mark - selecotr
- (void)minusButtonAction:(id)sender{
    
    if(!self.shouldEnable) return;
    
    if(self.numberValue <= self.minValue){
        
        if(self.plusMinusValueHandle){
            self.plusMinusValueHandle(-1, self.tag, NO);
        }
        
        return;
    }
    
    self.numberValue = [self.numberLabel.text intValue] - 1;
    
    if(self.plusMinusValueHandle){
        self.plusMinusValueHandle(self.numberValue, self.tag, NO);
    }
}

- (void)plusButtonAction:(id)sender{
    
    if(!self.shouldEnable) return;
    
    self.numberValue = [self.numberLabel.text intValue] + 1;
    
    if(self.plusMinusValueHandle){
        self.plusMinusValueHandle(self.numberValue, self.tag, YES);
    }
}

#pragma mark - Getter

- (UIButton *)minusButton{
    
    if(!_minusButton){
        
        _minusButton = [UIButton new];
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        [_minusButton setTitleColor:UIColorFromRGB(0xD0D0D0) forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _minusButton.titleLabel.font = [UIFont font12];
    }
    
    return _minusButton;
}

- (UIButton *)plusButton{
    
    if(!_plusButton){
        
        _plusButton = [UIButton new];
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        [_plusButton setTitleColor:UIColorFromRGB(0xD0D0D0) forState:UIControlStateNormal];
        [_plusButton addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _plusButton.titleLabel.font = [UIFont font12];
        [_plusButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    
    return _plusButton;
}

- (UILabel *)numberLabel{
    
    if(!_numberLabel){
        
        _numberLabel = [UILabel new];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor grayColor999999];
        _numberLabel.font = [UIFont font12];
    }
    
    return _numberLabel;
}

@end
