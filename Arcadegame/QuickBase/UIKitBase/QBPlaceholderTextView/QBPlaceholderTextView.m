//
//  QBPlaceholderTextView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBPlaceholderTextView.h"

@implementation QBPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self initialTextView];
    }
    
    return self;
}

- (instancetype)init{
    
    if(self = [super init]){
        
        [self initialTextView];
    }
    
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.hasText) return;
    
    rect.origin.x = self.originPoint.x;
    rect.origin.y = self.originPoint.y;
    rect.size.width -= 2 * rect.origin.x;
    
    [self.placeholder drawInRect:rect withAttributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.placeholderColor}];
}

#pragma mark -

- (void)initialTextView{
    
    self.font = [UIFont systemFontOfSize:14.f];
    self.placeholderColor = [UIColor grayColor];
    self.originPoint = CGPointMake(5.f, 8.f);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Selector

- (void)textDidChange:(NSNotification *)notification{
    
    [self setNeedsDisplay];
    
    if(self.didTextDidChangeHandle){
        
        self.didTextDidChangeHandle(self);
    }
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

@end
