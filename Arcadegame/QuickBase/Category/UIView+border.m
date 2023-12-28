//
//  UIView+border.m
//  Abner
//
//  Created by on 15/3/10.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "UIView+border.h"

@implementation UIView (border)

/*
 self.orderIcon.layer.cornerRadius = self.orderIcon.width/2.0f;
 self.orderIcon.layer.borderColor  = [UIColor grayColor].CGColor;
 self.orderIcon.layer.borderWidth  = 1.0f;
 self.orderIcon.clipsToBounds      = YES;
 */
- (void)circleOrderIcon{
    [self CircleBorderColor:[UIColor grayColor999999] borderWidth:1.5f];
}
//将自己变成圆形
- (void)CircleBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    self.layer.cornerRadius = self.width/2.0f;
    if (color) {
        self.layer.borderColor  = color.CGColor;
    }
    self.layer.borderWidth  = borderWidth;
    self.clipsToBounds      = YES;
}

//设置默认圆角6.0f
- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    self.layer.cornerRadius = 6.0f;
    if (color) {
        self.layer.borderColor  = color.CGColor;
    }
    self.layer.borderWidth  = borderWidth;
    self.clipsToBounds      = YES;
}
@end
