//
//  UIView+FindSubView.m
//  QuickBase
//
//  Created by Abner on 2019/9/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "UIView+FindSubView.h"

@implementation UIView (FindSubView)

- (UIView *)findSubview:(NSString *)name resursion:(BOOL)resursion{
    Class class = NSClassFromString(name);
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
    }
    
    if (resursion) {
        for (UIView *subview in self.subviews) {
            UIView *tempView = [subview findSubview:name resursion:resursion];
            if (tempView) {
                return tempView;
            }
        }
    }
    
    return nil;
}

@end
