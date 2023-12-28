
//
//  UIColor+THColor.m
//  Abner
//
//  Created by Abner on 14-7-12.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "UIColor+THColor.h"

@implementation UIColor (THColor)

+ (UIColor *)primaryColor{
    return Ex_RGB_COLOR(28, 118, 26);
}

+ (UIColor *)textHighColor{
    return [UIColor blackColor];
}

+ (UIColor *)textTintColor{
    return [UIColor grayColor];
}

+ (UIColor *)buttonColor{
    return Ex_UIColorFromRGB(0x689f38);
}

+ (UIColor *)lineColor{
    return Ex_UIColorFromRGB(0xf2f2f2);
}

+ (UIColor *)cellLineColor{
    //return Ex_UIColorFromRGB(0xe2e1e0);
    return Ex_UIColorFromRGB(0xEEEEEE);
}

+ (UIColor *)f2Color{
    return Ex_UIColorFromRGB(0xf2f2f2);
}

+ (UIColor *)black31Color{
    return Ex_UIColorFromRGB(0x313131);
}

+ (UIColor *)orangeColorff6600{
    return UIColorFromRGB(0xff6600);
}

+ (UIColor *)redButtonColor{
    return RGB_COLOR(186, 57, 38);
}

+ (UIColor *)exeColor{
    return RGB_COLOR(138, 236, 227);
}

+ (UIColor *)eshopColor{
    
    //return Ex_UIColorFromRGB(0x3EC662);
    return Ex_UIColorFromRGB(0x02AF66);
}

+ (UIColor *)eshopRedColor{
    // 0xFD3232
    return Ex_UIColorFromRGB(0xDD3B45);
}

+ (UIColor *)mainBackColor{
    return [UIColor whiteColor];
    //return Ex_UIColorFromRGB(0xf5f5f5);
    //return RGB_COLOR(238.f, 238.f, 238.f);
    //return UIColorFromRGB(0xf4f4f4);
    //return RGB_COLOR(243, 242, 241);
}

+ (UIColor *)defaultBackColor {
    
    return Ex_UIColorFromRGB(0x262E42);
}

+ (UIColor *)mainYellowColor{
    
    return Ex_UIColorFromRGB(0xffd119);
}

+ (UIColor *)mainLowergrayColor{
    
    return Ex_UIColorFromRGB(0xbfbfbf);
}

+ (UIColor *)grayColor808080{
    
    return Ex_UIColorFromRGB(0x808080);
}

+ (UIColor *)grayColor666666{
    return Ex_UIColorFromRGB(0x666666);
}

+ (UIColor *)grayColor999999{
    return Ex_UIColorFromRGB(0x999999);
}

/*红色*/
+ (UIColor *)redColorF43F50{
    return Ex_UIColorFromRGB(0xF43F50);
}

/*黑色*/
+ (UIColor *)blackColor333333{
    return Ex_UIColorFromRGB(0x333333);
}

/*白色*/
+ (UIColor *)whiteColorffffff{
    return [UIColor whiteColor];
}

+ (UIColor *)whiteColorffffffAlpha:(CGFloat)alpha{
    return Ex_UIColorFromRGBA(0xffffff, alpha);
}

+ (UIColor *)whiteColorffffffAlpha01{
    return Ex_UIColorFromRGBA(0xffffff, 0.1f);
}
+ (UIColor *)whiteColorffffffAlpha03{
    return [self whiteColorffffffAlpha:0.3f];
}
+ (UIColor *)whiteColorffffffAlpha08{
    return [self whiteColorffffffAlpha:0.8f];
}

/*黑色*/
+ (UIColor *)blackColor000000{
    
    return [UIColor blackColor];
}

+ (UIColor *)blackColor000000Alpha01{
    
    return [self blackColor000000Alpha:0.1f];
}

+ (UIColor *)blackColor000000Alpha03{
    
    return [self blackColor000000Alpha:0.3f];
}

+ (UIColor *)blackColor000000Alpha08{
    
    return [self blackColor000000Alpha:0.8f];
}

+ (UIColor *)blackColor000000Alpha:(CGFloat)alpha{
    
    return Ex_UIColorFromRGBA(0x000000, alpha);
}

+ (id)getColor:(NSString *) hexColor alpha:(CGFloat)alpha {
    unsigned int redInt_, greenInt_, blueInt_;
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;  // 范围长度为2
    
    // 取红色的值
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&redInt_];
    
    // 取绿色的值
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&greenInt_];
    
    // 取蓝色的值
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&blueInt_];
    
    return [UIColor colorWithRed:(float)(redInt_/255.0f) green:(float)(greenInt_/255.0f) blue:(float)(blueInt_/255.0f) alpha:alpha];
}

+ (id)getColor:(NSString *) hexColor {
    return [self getColor:hexColor alpha:1.0f];
}

@end
