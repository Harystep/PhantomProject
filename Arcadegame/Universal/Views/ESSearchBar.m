//
//  ESSearchBar.m
//  EShopClient
//
//  Created by Abner on 2019/6/13.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESSearchBar.h"

@interface ESSearchBar ()

@property (nonatomic, strong) NSString *placeholderStr;

@end

@implementation ESSearchBar

- (instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder tintColor:(UIColor *)tintColor isShowCancelButton:(BOOL)isShowCancelButton{
    
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = tintColor; // 光标颜色
        //self.barTintColor = [UIColor whiteColor];
        self.showsCancelButton = isShowCancelButton;
        self.contentMode = UIViewContentModeCenter;
        self.placeholderStr = placeholder;
        
        [self setImage:IMAGE_NAMED(@"search_search_icon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [self cleanSearchBackground];
        
        if(@available(iOS 11.0, *)){

            [[self.heightAnchor constraintEqualToConstant:46.f] setActive:YES];
        }
        else {
            [self setPlaceholderLeft];
        }
    }
    
    return self;
}

- (void)cleanSearchBackground{
    
    [self setBackgroundImage:[UIImage new]];
    //[self setSearchFieldBackgroundImage:[HelpTools createImageWithColor:[UIColor whiteColorffffffAlpha:0.f] withRect:self.bounds] forState:UIControlStateNormal];
    /*
    for (UIView *view in self.subviews.lastObject.subviews) {
        DLOG(@"view:%@", view);
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            //view.layer.contents = nil;
            break;
        }
    }
     */
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UITextField *searchField = (UITextField *)[self findSubview:@"UITextField" resursion:YES];
    
    if(searchField){
        
        if(self.textFieldCornerRadius > 0.f) {
            searchField.layer.cornerRadius = self.textFieldCornerRadius;
        }
        else {
            searchField.layer.cornerRadius = searchField.height / 2.f;
        }
        
        if(self.textFieldBackColor){
            
            searchField.backgroundColor = self.textFieldBackColor;
        }
        else {
            searchField.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UITextField *searchField = (UITextField *)[self findSubview:@"UITextField" resursion:YES];
    
    if(searchField){
        
        if(self.textFieldBackColor){
            
            searchField.backgroundColor = self.textFieldBackColor;
        }
        else {
            searchField.backgroundColor = [UIColor whiteColor];
        }
        
        if(self.textFieldTextColor) {
            
            searchField.textColor = self.textFieldTextColor;
        }
        else {
            searchField.textColor = [UIColor blackColor333333];
        }
        
        if(self.textFieldTextFont) {
            
            searchField.font = self.textFieldTextFont;
        }
        else {
            searchField.font = [UIFont font14];
        }
        
        searchField.borderStyle = UITextBorderStyleNone;
        
        searchField.layer.masksToBounds = YES;
        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholderStr attributes:@{NSFontAttributeName : searchField.font, NSForegroundColorAttributeName : UIColorFromRGB(0xB0B0B0)}];
    }
    
    self.searchTextPositionAdjustment = (UIOffset){10.f, 0.f}; // 光标偏移量
}

- (void)setTextFieldBackColor:(UIColor *)textFieldBackColor{
    _textFieldBackColor = textFieldBackColor;
    
    [self setNeedsDisplay];
}

#pragma  mark -

- (void)setPlaceholderLeft{
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    
    if([self respondsToSelector:centerSelector]){
        
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}

@end
