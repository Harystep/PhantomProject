//
//  UIFont+THFont.h
//  Abner
//
//  Created by Abner on 14-7-12.
//  Copyright (c) 2014年 . All rights reserved.
//
/*
 *  APP字体管理类
 *  命名要求:尽量使用通用名称命名,并添加注释说明
 *  eg:描述+Bold(粗体,有则加)+Font
 */

#import <UIKit/UIKit.h>

@interface UIFont (THFont)

+ (CGFloat)getFontValueRate;
+ (void)setFontValueRate:(CGFloat)rate;

+ (UIFont *)largeFont;
+ (UIFont *)middleFont;
+ (UIFont *)littleFont;

+ (UIFont *)titleFont;
+ (UIFont *)contentFont;

+ (UIFont *)font36pt;
+ (UIFont *)font42pt;
+ (UIFont *)font48pt;
+ (UIFont *)font60pt;
+ (UIFont *)font72pt;
+ (UIFont *)font78pt;

+ (UIFont *)bold36pt;
+ (UIFont *)bold48pt;
+ (UIFont *)bold54pt;
+ (UIFont *)bold78pt;
+ (UIFont *)yuanti108pt;

+ (UIFont *)orderDetailFont;

+ (UIFont *)font28;
+ (UIFont *)font28Bold;
+ (UIFont *)font26;
+ (UIFont *)font26Bold;
+ (UIFont *)font24;
+ (UIFont *)font24Bold;
+ (UIFont *)font22;
+ (UIFont *)font22Bold;
+ (UIFont *)font20Bold;
+ (UIFont *)font19;
+ (UIFont *)font19Bold;
+ (UIFont *)font18;
+ (UIFont *)font18Bold;
+ (UIFont *)font16;
+ (UIFont *)font16Bold;
+ (UIFont *)font15;
+ (UIFont *)font15Bold;
+ (UIFont *)font14;
+ (UIFont *)font14Bold;
+ (UIFont *)font13;
+ (UIFont *)font13Bold;
+ (UIFont *)font12;
+ (UIFont *)font12Bold;
+ (UIFont *)font11;
+ (UIFont *)font10;
+ (UIFont *)font9;
+ (UIFont *)font8;

@end
