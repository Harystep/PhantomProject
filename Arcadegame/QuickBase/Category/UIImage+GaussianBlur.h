//
//  UIImage+GaussianBlur.h
//  Abner
//
//  Created by Abner on 15/4/7.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlur)

- (UIImage *)blurImageWithBlurLevel:(CGFloat)level;

@end
