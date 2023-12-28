//
//  UIColor+THColor.h
//  Abner
//
//  Created by Abner on 14-7-12.
//  Copyright (c) 2014年 . All rights reserved.
//
/*
 *  APP颜色管理类
 *  命名要求:尽量使用通用名称命名,并添加注释说明
 *  eg:描述+Color
 */

#import <UIKit/UIKit.h>

//16进制颜色值
#define Ex_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Ex_UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

//不带alpha的RBG颜色
#define Ex_RGB_COLOR(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]

//带alpha的RBG颜色
#define Ex_RGB_COLOR_ALPHA(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

@interface UIColor (THColor)

+ (UIColor *)primaryColor;
+ (UIColor *)textHighColor;
+ (UIColor *)textTintColor;


+ (UIColor *)buttonColor;
+ (UIColor *)lineColor;
+ (UIColor *)cellLineColor;
+ (UIColor *)redButtonColor;
+ (UIColor *)exeColor;
+ (UIColor *)mainBackColor;
+ (UIColor *)mainYellowColor;
+ (UIColor *)mainLowergrayColor;
+ (UIColor *)grayColor808080;

+ (UIColor *)f2Color;
+ (UIColor *)black31Color;
+ (UIColor *)eshopColor;
+ (UIColor *)eshopRedColor;
+ (UIColor *)defaultBackColor;

/*橙色*/
+ (UIColor *)orangeColorff6600;

/*灰色*/
+ (UIColor *)grayColor666666;
+ (UIColor *)grayColor999999;

/*黑色*/
+ (UIColor *)blackColor333333;

/*红色*/
+ (UIColor *)redColorF43F50;

/*白色*/
+ (UIColor *)whiteColorffffff;
+ (UIColor *)whiteColorffffffAlpha01;
+ (UIColor *)whiteColorffffffAlpha03;
+ (UIColor *)whiteColorffffffAlpha08;
+ (UIColor *)whiteColorffffffAlpha:(CGFloat)alpha;

/*黑色*/
+ (UIColor *)blackColor000000;
+ (UIColor *)blackColor000000Alpha01;
+ (UIColor *)blackColor000000Alpha03;
+ (UIColor *)blackColor000000Alpha08;
+ (UIColor *)blackColor000000Alpha:(CGFloat)alpha;

// 传入十六进制字符串 如009174
+ (id)getColor:(NSString *) hexColor alpha:(CGFloat)alpha;
+ (id)getColor:(NSString *) hexColor;

@end
