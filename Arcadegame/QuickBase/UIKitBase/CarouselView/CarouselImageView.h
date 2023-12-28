//
//  CarouselImageView.h
//  NetWorkDemo
//
//  Created by Abner on 14-7-22.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define CI_AUTORELEASE(expression) expression
#define CI_RELEASE(expression) expression
#define CI_RETAIN(expression) expression
#define CI_BLOCK_WEAK __weak
#define CI_STRONG strong
#define CI_WEAK
#else
#define CI_AUTORELEASE(expression) [expression autorelease]
#define CI_RELEASE(expression) [expression release]
#define CI_RETAIN(expression) [expression retain]
#define CI_BLOCK_WEAK __block
#define CI_STRONG retain
#define CI_WEAK assign
#endif

#define ci_dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }

//截取图片的方式(再加一种，直接返回图片实际大小)
typedef enum{
    INTERCEPT_FIXEDWIDTH_TOP = 0,   //宽充满View,截取顶部区域(默认)
    INTERCEPT_FIXEDWIDTH_CENTER,    //宽充满View,截取中间区域
    INTERCEPT_FIXEDWIDTH_BOTTOM,    //宽充满View,截取底部区域
    INTERCEPT_FIXEDHEIGHT_LEFT,     //高充满View,截取左边区域
    INTERCEPT_FIXEDHEIGHT_RIGHT,    //高充满View,截取右边区域
    INTERCEPT_FIXEDHEIGHT_CENTER,   //高充满View,截取中间区域
    INTERCEPT_FULLFORIMAGE_SIZE,    //图片完整显示,返回图片的实际尺寸(经过校正)
    INTERCEPT_FULL_SIZE,            //宽铺满屏幕,图片完整显示
    INTERCEPT_CENTER                //竖直长图,宽充满View,截取中间区域;
                                    //或横向长图,高充满View,截取中间区域
}CarouselInterceptImageModel;

//图片适配并截取后ImageView的Size
typedef void(^CorrectRectBlock)(CGSize size);

@interface CarouselImageView : UIImageView

// 是否淡出效果,默认为 YES
@property (nonatomic, assign) BOOL shouldAnimation;

// 临时修复BUG
@property (nonatomic, assign) BOOL ignoreCache;
@property (nonatomic, strong) NSString *cacheKey;

/*
 * imageObject内容:NSString(连接,本地图片名),NSURL,UIImage,CustomObject(自定义类型暂不支持)
 */
//使用预设的截图方式设置图片
- (void)setImageWithObject:(id)imageObject
      withPlaceholderImage:(UIImage *)defaultImage
       interceptImageModel:(CarouselInterceptImageModel)carouselInterceptModle
               correctRect:(CorrectRectBlock)rectBlock;

//使用自定义的截图位置设置图片
- (void)setImageWithObject:(id)imageObject
      withPlaceholderImage:(UIImage *)defaultImage
        interceptImageRect:(CGRect)interceptRect
               correctRect:(CorrectRectBlock)rectBlock;

@end
