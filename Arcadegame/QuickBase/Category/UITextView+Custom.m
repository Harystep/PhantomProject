//
//  UITextView+Custom.m
//  QuickBase
//
//  Created by Abner on 2019/12/2.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "UITextView+Custom.h"

NSInteger const kTextViewCanNotEditingTag = 6666;

@implementation UITextView (Custom)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{

    if(kTextViewCanNotEditingTag == self.tag){
        
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

@end
