//
//  UINavigationBar+CustonBackground.m
//  Abner
//
//  Created by Abner on 15/6/22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "UINavigationBar+CustonBackground.h"
#import <objc/runtime.h>

static char NaviBackgroundImageKey;

@implementation UINavigationBar (CustonBackground)

- (void)drawRect:(CGRect)rect{
    
    [self.naviBackgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

#pragma mark naviBackgroundImage Getter & Setter
- (void)setNaviBackgroundImage:(UIImage *)naviBackgroundImage{
    [self willChangeValueForKey:@"naviBackgroundImage"];
    
    objc_setAssociatedObject(self, &NaviBackgroundImageKey, naviBackgroundImage, OBJC_ASSOCIATION_ASSIGN);
    
    [self didChangeValueForKey:@"naviBackgroundImage"];
    
    [self setNeedsDisplay];
}

- (UIImage *)naviBackgroundImage{
    return objc_getAssociatedObject(self, &NaviBackgroundImageKey);
}

@end
