//
//  NSMutableAttributedString+formate.m
//  Abner
//
//  Created by on 15/3/19.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSMutableAttributedString+formate.h"

@implementation NSMutableAttributedString (formate)

- (void)appendString:(NSString *)string attri:(NSDictionary *)attr{
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attr]];
}

- (void)appendString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)color{
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    if (font) {
        [attri setObject:font forKey:NSFontAttributeName];
    }
    if (color) {
        [attri setObject:color forKey:NSForegroundColorAttributeName];
    }
    [self appendString:string attri:attri];
}

- (void)setLineSpace:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paramStype = [[NSMutableParagraphStyle alloc] init];
    paramStype.lineSpacing = lineSpace;
    
    [self addAttributes:@{NSParagraphStyleAttributeName : paramStype} range:NSMakeRange(0, self.string.length)];
}

- (void)setString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)color{
    NSRange range = [self.string rangeOfString:string];
    if (range.location != NSNotFound) {
        NSMutableDictionary *attri = [NSMutableDictionary dictionary];
        if (font) {
            [attri setObject:font forKey:NSFontAttributeName];
        }
        if (color) {
            [attri setObject:color forKey:NSForegroundColorAttributeName];
        }
        if (attri.count) {
            [self addAttributes:attri range:range];
        }
    }
}

@end
