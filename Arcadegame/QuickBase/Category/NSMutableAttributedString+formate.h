//
//  NSMutableAttributedString+formate.h
//  Abner
//
//  Created by on 15/3/19.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (formate)

- (void)appendString:(NSString *)string attri:(NSDictionary *)attr;

- (void)appendString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)color;

- (void)setLineSpace:(CGFloat)lineSpace;

- (void)setString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)color;

@end
