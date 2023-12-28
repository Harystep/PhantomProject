//
//  UITextField+Custom.m
//  QuickBase
//
//  Created by Abner on 2019/8/12.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "UITextField+Custom.h"

NSInteger const kTextFieldCannotEditingTag = 3333;

@implementation UITextField (Custom)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{

    if(kTextFieldCannotEditingTag == self.tag){
        
        return NO;
    }

    return YES;
}

@end
