//
//  UIImage+Crop.m
//  Interactive
//
//  Created by Abner on 15/12/29.
//  Copyright © 2015年 . All rights reserved.
//

#import "UIImage+Crop.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (Crop)

- (UIImage*)cropImageWithRect:(CGSize)rectSize{
    
//    if (pointArr.count == 0) {
//        return nil;
//    }
//    
//    CGPoint *points = malloc(sizeof(CGPoint) * pointArr.count);
//    for (int i = 0; i < pointArr.count; ++i) {
//        points[i] = [[pointArr objectAtIndex:i] CGPointValue];
//    }
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * self.scale, self.size.height * self.scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextAddArc(context, 0, 0, rectSize.width/2, 0, M_PI * 2, 0);
    //CGContextAddLines(context, points, pointArr.count);
    CGContextClosePath(context);
    CGRect boundsRect = CGContextGetPathBoundingBox(context);
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(boundsRect.size);
    context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, boundsRect.size.width, boundsRect.size.height));
    
    CGMutablePathRef  path = CGPathCreateMutable();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-boundsRect.origin.x, -boundsRect.origin.y);
    //CGPathAddLines(path, &transform, points, pointArr.count);
    CGPathAddArc(path, &transform, 4.f, 4.f, (boundsRect.size.width - 4.f * 2)/2, 0, M_PI * 2, 0);
    
    CGContextBeginPath(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    [self drawInRect:CGRectMake(-boundsRect.origin.x, -boundsRect.origin.y, self.size.width * self.scale, self.size.height * self.scale)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
