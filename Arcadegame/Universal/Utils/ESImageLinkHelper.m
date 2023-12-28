//
//  ESImageLinkHelper.m
//  EShopClient
//
//  Created by Abner on 2019/11/27.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESImageLinkHelper.h"

static CGFloat const kFixImageMinWidth = 300.f;

@implementation ESImageLinkHelper

+ (NSString *)fixedImageLinkWithURLString:(NSString *)URLString withSize:(CGSize)imageSize{
    
    if([NSString isNotEmptyAndValid:URLString] &&
       imageSize.width != 0.f &&
       imageSize.height != 0.f){
        
        CGFloat maxFixImageWidth = MAX((imageSize.width * MainScreenScale), (imageSize.height * MainScreenScale));
        maxFixImageWidth = MAX(maxFixImageWidth, kFixImageMinWidth);
        maxFixImageWidth = ceil(maxFixImageWidth);
        
        return [NSString stringWithFormat:@"%@?imageView2/2/w/%@/h/%@", URLString, @(maxFixImageWidth), @(maxFixImageWidth)];
    }
    
    return @"";
}

@end
