//
//  UIImage+PhotoClip.h
//  Interactive
//
//  Created by Abner on 16/6/27.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PhotoClip)

// 自动纠正图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

// 根据比例缩放图片
+ (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

// 将照片裁剪成正方形
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;

// 按照给定的圆心,半径开始角度将图片剪成圆形
+ (UIImage *)circleImageFromImage:(UIImage *)image imageSize:(CGSize)size withArcCenter:(CGPoint)center radius:(CGFloat)radius;

// 按照给定的rect将图片裁剪成正方形
+ (UIImage *)squareImageFromImage:(UIImage *)image imageSize:(CGSize)size withRect:(CGRect)rect;

// 将图片旋转一定角度
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

//// 颜色转换成图片(带圆角的)
//+ (UIImage *)imageWithColor:(UIColor *)color redius:(CGFloat)redius size:(CGSize)size;
//
//// 将图片截成圆形图片
//+ (UIImage *)imagewithImage:(UIImage *)image;
//
//
//// 获得某个范围内的屏幕图像
//+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)rect;
//
//// 根据rect将图片剪裁成圆形
//+ (UIImage *)circleImage:(UIImage *)image withRect:(CGRect)rect;

@end
