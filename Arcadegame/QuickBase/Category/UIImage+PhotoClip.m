//
//  UIImage+PhotoClip.m
//  Interactive
//
//  Created by Abner on 16/6/27.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "UIImage+PhotoClip.h"

@implementation UIImage (PhotoClip)

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
            
    }
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
            
        case UIImageOrientationDownMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRightMirrored:
            
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
            
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            
                                            CGImageGetColorSpace(aImage.CGImage),
                                            
                                            CGImageGetBitmapInfo(aImage.CGImage));
    
    CGContextConcatCTM(ctx, transform);
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
            
        case UIImageOrientationLeftMirrored:
            
        case UIImageOrientationRight:
            
        case UIImageOrientationRightMirrored:
            
            // Grr...
            
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
            
    }
    
    // And now we just create a new UIImage from the drawing context
    
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
    
}

+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)circleImageFromImage:(UIImage *)image imageSize:(CGSize)size withArcCenter:(CGPoint)center radius:(CGFloat)radius {
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 创建圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    // 设置为剪裁区域
    [path addClip];
    // 绘制图片
    [image drawAtPoint:CGPointZero];
    // 获取剪裁后的图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(circleImage, nil, nil, nil);  // 保存到相册,测试用
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
}

+ (UIImage *)squareImageFromImage:(UIImage *)image imageSize:(CGSize)size withRect:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 创建矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [path addClip];
    [image drawAtPoint:CGPointZero];
    
    // 获取剪裁后的图片
    UIImage *squareImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(circleImage, nil, nil, nil);  // 保存到相册,测试用
    
    UIGraphicsEndImageContext();
    
    return squareImage;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
            
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}


//+ (UIImage *)imageWithColor:(UIColor *)color redius:(CGFloat)redius size:(CGSize)size {
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ref, color.CGColor);
//    CGContextFillRect(ref, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIGraphicsBeginImageContext(image.size);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height) cornerRadius:redius];
//    [path addClip];
//    [image drawAtPoint:CGPointZero];
//    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image1;
//}
//
//+ (UIImage *)imagewithImage:(UIImage *)image {
//    
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
//    CGFloat redius = ((width <= height) ? width : height)/2;
//    CGRect  rect = CGRectMake(width/2-redius, height/2-redius, redius*2, redius*2);
//    
//    CGImageRef sourceImageRef = [image CGImage];
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newImage.size.width, newImage.size.height), NO, 0);
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(newImage.size.width/2, newImage.size.height/2) radius:redius startAngle:0 endAngle:M_PI*2 clockwise:0];
//    [path addClip];
//    [newImage drawAtPoint:CGPointZero];
//    UIImage *imageCut = UIGraphicsGetImageFromCurrentImageContext();
//    
//    return imageCut;
//    
//}
//
//+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)rect {
//    UIGraphicsBeginImageContext(theView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(rect);
//    [theView.layer renderInContext:context];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return  theImage;
//}
//
//+ (UIImage *)circleImage:(UIImage *)image withRect:(CGRect)rect {
//    UIGraphicsBeginImageContext(image.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
////    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
//    CGContextAddEllipseInRect(context, rect);
//    CGContextClip(context);
//    
//    [image drawInRect:rect];
//    CGContextAddEllipseInRect(context, rect);
//    CGContextStrokePath(context);
//    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newimg;
//}

@end
