//
//  CarouselScrollBar.h
//  
//
//  Created by Abner on 14-7-19.
//  Copyright (c) 2014年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define CS_AUTORELEASE(expression) expression
#define CS_STRONG strong
#define CS_WEAK
#else
#define CS_AUTORELEASE(expression) [expression autorelease]
#define CS_STRONG retain
#define CS_WEAK assign
#endif

typedef enum {
    SCROLLBAR_CIRCLECORNER_TYPE,    //圆角
    SCROLLBAR_SQUARE_TYPE,          //方的
    SCROLLBAR_STYLE1_TYPE,          //样式1,没有循环轮播的动画
}CarouselScrollBarType;

@interface CarouselScrollBar : UIView

//图片总数
@property(nonatomic, CS_WEAK) NSInteger scrollContentCount;
//如不需要从第一张到最后一张的动画,设置为NO,默认为YES
@property(nonatomic, CS_WEAK) BOOL isCoherentAnimation;

- (instancetype)initWithSize:(CGSize)barSize
               scrollBarType:(CarouselScrollBarType)barType
             andCurrentIndex:(NSInteger)currentIndex;

/*
 * 设置外观(值可为imageName,UIImage,UIColor)
 * background:底图/底色  sliderBack:滑块背景图/滑块背景色
 */
- (void)setBackGround:(id)background sliderBack:(id)sliderBack;
//刷新滑块位置
- (void)reloadScrollBarLocation:(CGFloat)scrollOffsetX scrollWidth:(CGFloat)scrollWidth currentIndex:(NSInteger)currentIndex;
/**
 *  自动隐藏;如果需要自动隐藏和显示,需要首先调用该方法,
 *  并设animated的值为NO
 */
- (void)disappearScrollBar:(BOOL)animated;
/**
 *  自动显示;该方法配合disappearSlider使用,否则没效果
 */
- (void)appearScrollBar:(BOOL)animated;

@end
