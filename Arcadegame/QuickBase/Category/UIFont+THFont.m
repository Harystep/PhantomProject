//
//  UIFont+THFont.m
//  Abner
//
//  Created by Abner on 14-7-12.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "UIFont+THFont.h"


@implementation UIFont (THFont)

#define Ex_FONT_BOLD_SYSTEM(FONTSIZE)  [UIFont boldSystemFontOfSize:FONTSIZE]
#define Ex_FONT_SYSTEM(FONTSIZE)       [UIFont systemFontOfSize:FONTSIZE]
#define Ex_FONT(NAME, FONTSIZE)        [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define BoldFont(size)   [UIFont boldSystemFontOfSize:(size)/3.0f]
#define SystemFont(size) [UIFont systemFontOfSize:(size)/3.0f]

+ (CGFloat)getFontValueRate{
    
    CGFloat fontValueRate = [[[NSUserDefaults standardUserDefaults] valueForKey:kFontValueRateDefault] floatValue];
    if(fontValueRate > 0){
        return fontValueRate;
    }
    
    return 1.f;
}

+ (void)setFontValueRate:(CGFloat)rate{
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:rate] forKey:kFontValueRateDefault];
}

+ (UIFont *)largeFont{
    return Ex_FONT_SYSTEM(21.f);
}

+ (UIFont *)middleFont{
    return Ex_FONT_SYSTEM(14.f * [self getFontValueRate]);
}

+ (UIFont *)littleFont{
    return Ex_FONT_SYSTEM(12.f * [self getFontValueRate]);
}

+ (UIFont *)titleFont{
    return Ex_FONT_SYSTEM(16.f * [self getFontValueRate]);
}

+ (UIFont *)contentFont{
    return Ex_FONT_SYSTEM(15.f * [self getFontValueRate]);
}

+ (UIFont *)font36pt{
    return SystemFont(36.f);
}

+ (UIFont *)font42pt{
    return SystemFont(42.f);
}

+ (UIFont *)font48pt{
    return SystemFont(48.f);
}

+ (UIFont *)font60pt{
     return SystemFont(60.f);
}

+ (UIFont *)font72pt{
    return SystemFont(72.f);
}

+ (UIFont *)font78pt{
    return SystemFont(78.f);
}


/*粗体*/
+ (UIFont *)bold48pt{
    return BoldFont(48.f);
}
+ (UIFont *)bold36pt{
    return BoldFont(36.0f);
}

+ (UIFont *)bold54pt{
    return BoldFont(54.0f);
}
+ (UIFont *)bold78pt{
    return BoldFont(78.0f);
}
+ (UIFont *)yuanti108pt{
    return BoldFont(108.f);
}

+ (UIFont *)orderDetailFont{
    return [self font42pt];
}

+ (UIFont *)font28{
    
    return [UIFont systemFontOfSize:28.f * [self getFontValueRate]];
}

+ (UIFont *)font28Bold{
    
    return [UIFont boldSystemFontOfSize:28.f * [self getFontValueRate]];
}

+ (UIFont *)font26{
    
    return [UIFont systemFontOfSize:26.f * [self getFontValueRate]];
}

+ (UIFont *)font26Bold{
    
    return [UIFont boldSystemFontOfSize:26.f * [self getFontValueRate]];
}

+ (UIFont *)font24{
    
    return [UIFont systemFontOfSize:24.f * [self getFontValueRate]];
}

+ (UIFont *)font24Bold{
    
    return [UIFont boldSystemFontOfSize:24.f * [self getFontValueRate]];
}

+ (UIFont *)font22{
    
    return [UIFont systemFontOfSize:22.f * [self getFontValueRate]];
}

+ (UIFont *)font22Bold{
    
    return [UIFont boldSystemFontOfSize:22.f * [self getFontValueRate]];
}

+ (UIFont *)font20Bold{
    
    return [UIFont boldSystemFontOfSize:20.f * [self getFontValueRate]];
}

+ (UIFont *)font19{
    
    return [UIFont systemFontOfSize:19.f * [self getFontValueRate]];
}

+ (UIFont *)font19Bold{
    
    return [UIFont boldSystemFontOfSize:19.f * [self getFontValueRate]];
}

+ (UIFont *)font18{
    
    return [UIFont systemFontOfSize:18.f * [self getFontValueRate]];
}

+ (UIFont *)font18Bold{
    
    return [UIFont boldSystemFontOfSize:18.f * [self getFontValueRate]];
}

+ (UIFont *)font16{
    
    return [UIFont systemFontOfSize:16.f * [self getFontValueRate]];
}

+ (UIFont *)font16Bold{
    
    return [UIFont boldSystemFontOfSize:16.f * [self getFontValueRate]];
}

+ (UIFont *)font15Bold{
    
    return [UIFont boldSystemFontOfSize:15.f * [self getFontValueRate]];
}

+ (UIFont *)font15{
    
    return [UIFont systemFontOfSize:15.f * [self getFontValueRate]];
}

+ (UIFont *)font14{
    
    return [UIFont systemFontOfSize:14.f * [self getFontValueRate]];
}

+ (UIFont *)font14Bold{
    
    return [UIFont boldSystemFontOfSize:14.f * [self getFontValueRate]];
}

+ (UIFont *)font13{
    
    return [UIFont systemFontOfSize:13.f * [self getFontValueRate]];
}

+ (UIFont *)font13Bold{
    
    return [UIFont boldSystemFontOfSize:13.f * [self getFontValueRate]];
}

+ (UIFont *)font12{
    
    return [UIFont systemFontOfSize:12.f * [self getFontValueRate]];
}

+ (UIFont *)font12Bold{
    
    return [UIFont boldSystemFontOfSize:12.f * [self getFontValueRate]];
}

+ (UIFont *)font11{
    
    return [UIFont systemFontOfSize:11.f * [self getFontValueRate]];
}

+ (UIFont *)font10{
    
    return [UIFont systemFontOfSize:10.f * [self getFontValueRate]];
}

+ (UIFont *)font9{
    
    return [UIFont systemFontOfSize:9.f * [self getFontValueRate]];
}

+ (UIFont *)font8{
    
    return [UIFont systemFontOfSize:8.f * [self getFontValueRate]];
}

@end
