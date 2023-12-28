//
//  QBPasswordFieldView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/8/15.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBPasswordFieldView.h"

@interface QBPasswordFieldView () <UITextFieldDelegate>

@property (nonatomic, assign) NSInteger passwordLength;
@property (nonatomic, strong) NSMutableArray *textMutableArray;
@property (nonatomic, strong) UITextField *backTextField;

@end

@implementation QBPasswordFieldView

- (instancetype)initWithFrame:(CGRect)frame withPasswordLength:(NSInteger)length{
    
    if(self = [super initWithFrame:frame]){
        
        self.shouldAutoHideKeyboard = YES;
        self.passwordLength = (length <= 0) ? 1 : length;
       
        [self addSubview:self.backTextField];
        self.backTextField.frame = self.bounds;
        
        CGFloat orginX = 0.f;
        CGFloat labelWidth = CGRectGetWidth(self.frame) / self.passwordLength + 0.5f;
        
        for (int i = 0; i < self.passwordLength; i++){
            
            UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(orginX, 0.f, labelWidth, CGRectGetHeight(self.frame))];
            passwordLabel.layer.borderColor = [UIColor colorWithRed:((float)((0xD7D7D7 & 0xFF0000) >> 16))/255.0 green:((float)((0xD7D7D7 & 0xFF00) >> 8))/255.0 blue:((float)(0xD7D7D7 & 0xFF))/255.0 alpha:1.0].CGColor;
            passwordLabel.backgroundColor = [UIColor whiteColor];
            passwordLabel.textAlignment = NSTextAlignmentCenter;
            passwordLabel.font = [UIFont systemFontOfSize:28.f];
            passwordLabel.userInteractionEnabled = YES;
            passwordLabel.layer.borderWidth = 1.f;
            [self addSubview:passwordLabel];
            
            orginX = CGRectGetMaxX(passwordLabel.frame) - 0.5f;
            
            UITapGestureRecognizer *passwordTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordLabelAction:)];
            [passwordLabel addGestureRecognizer:passwordTapGestureRecognizer];
            
            [self.textMutableArray addObject:passwordLabel];
        }
    }
    
    return self;
}

- (BOOL)becomeFirstResponder{
    
    [self.backTextField becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder{
    
    [self.backTextField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)cleanPassword{
    
    self.backTextField.text = @"";
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    
    UILabel *leftTextLabel = self.textMutableArray.firstObject;
    UILabel *rightTextLabel = self.textMutableArray.lastObject;
    
    if(self.textMutableArray.count == 1){
        
        if(leftTextLabel){
            
            leftTextLabel.layer.cornerRadius = cornerRadius;
            leftTextLabel.layer.masksToBounds = YES;
        }
    }
    else {
        
        if(leftTextLabel){
            [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) withRadii:CGSizeMake(cornerRadius, cornerRadius) forView:leftTextLabel];
        }
        
        if(rightTextLabel){
            [self addRoundedCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) withRadii:CGSizeMake(cornerRadius, cornerRadius) forView:rightTextLabel];
        }
    }
}

- (void)setTextBorderColor:(UIColor *)textBorderColor{
    _textBorderColor = textBorderColor;
    
    for (UILabel *textLabel in self.textMutableArray) {
        
        if(textLabel){
            
            textLabel.layer.borderColor = textBorderColor.CGColor;
        }
    }
}

#pragma mark - Selector

- (void)passwordLabelAction:(UITapGestureRecognizer *)gesture{
    
    if(self.backTextField.isFirstResponder){
        
        [self.backTextField resignFirstResponder];
    }
    else {
        
        [self.backTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldChange:(UITextField *)textField{
    
    for (int i = 0; i < self.textMutableArray.count; i++){
        
        UILabel *pwdLabel = [self.textMutableArray objectAtIndex:i];
        
        if (i < textField.text.length){
            
            //NSString *password = [textField.text substringWithRange:NSMakeRange(i, 1)];
            pwdLabel.text = @"•";
        }
        else {
            pwdLabel.text = @"";
        }
    }
    
    if(textField.text.length == self.passwordLength){
        
        self.passwordString = textField.text;
        
        if(self.shouldAutoHideKeyboard){
            
            [textField resignFirstResponder];
        }
    }
    else {
        self.passwordString = @"";
    }
    
    if(self.textFieldDidChangedHandle){
        
        self.textFieldDidChangedHandle(textField.text, self.passwordString);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL shouldEdit = YES;
    
    if((string.length> range.length) &&
       (([self convertToInt:textField.text] + [self convertToInt:string] - range.length) > self.passwordLength)){
        
        shouldEdit = NO;
    }
    
    return shouldEdit;
}

#pragma mark - Private

- (NSUInteger)convertToInt:(NSString *)strtemp{
    
    NSUInteger strlength = 0;
    char * p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    
    return strlength;
}

- (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii forView:(UIView *)view{
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:radii];
    
    CAShapeLayer *shape = [CAShapeLayer new];
    [shape setLineWidth:(view.layer.borderWidth * 2.f)];
    [shape setFillColor:[UIColor clearColor].CGColor];
    [shape setStrokeColor:view.layer.borderColor];
    [shape setFrame:view.bounds];
    [shape setPath:rounded.CGPath];
    [view.layer addSublayer:shape];
    
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:shape];
    mask.path = rounded.CGPath;
    view.layer.mask = mask;
}

#pragma mark - Getter

- (NSMutableArray *)textMutableArray{
    
    if(!_textMutableArray){
        
        _textMutableArray = [NSMutableArray arrayWithCapacity:self.passwordLength];
    }
    
    return _textMutableArray;
}

- (UITextField *)backTextField{
    
    if(!_backTextField){
        
        _backTextField = [UITextField new];
        _backTextField.keyboardType = UIKeyboardTypePhonePad;
        _backTextField.delegate = self;
        _backTextField.hidden = YES;
        
        [_backTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _backTextField;
}

@end
