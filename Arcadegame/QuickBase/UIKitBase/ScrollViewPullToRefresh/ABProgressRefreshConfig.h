//
//  ABProgressRefreshConstants.h
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#ifndef TreasureHunter_ABProgressRefreshConstants_h
#define TreasureHunter_ABProgressRefreshConstants_h

typedef NS_ENUM(NSUInteger, ABProgressRefreshState) {
    ABProgressRefreshStateNone = 0,
    ABProgressRefreshStateStopped,
    ABProgressRefreshStateTriggering,
    ABProgressRefreshStateTriggered,
    ABProgressRefreshStateLoading,
};

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define PulltoRefreshThreshold 60.0
#define TEMP_OFFSET (PulltoRefreshThreshold - self.bounds.size.height + 1 - 20)

typedef NS_ENUM(NSInteger, ABProgressAnimateStyle){

    ABProgressAnimateStyleNormal,    // 菊花
    ABProgressAnimateStyleImage,     // 图片
    ABProgressAnimateStyleGifImage,  // Gif
    ABProgressAnimateStyleCustom,    // 自定义
    ABProgressAnimateStyle1,         // 样式1 [ABCicleImageView]
};

// ----------------------

// 正在加载动画的样式
static ABProgressAnimateStyle kPullRefreshAnimateType = ABProgressAnimateStyleGifImage;
// View中的图片(图片名/GIF名)
static NSString *kPullRefreshImageName = @"pulldownIcon0";
static CGFloat kPullProgressViewHeight = 70.f;

// ----------------------
static ABProgressAnimateStyle kInstertRefreshAnimateType = ABProgressAnimateStyleNormal;
static NSString *kInstertRefreshImageName = @"";
static CGFloat kInstertProgressViewHeight = 40.f;

#endif
