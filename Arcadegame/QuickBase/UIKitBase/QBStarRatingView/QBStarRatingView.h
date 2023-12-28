//
//  QBStarRatingView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/12.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBStarRatingView : UIView

/**
 初始化, Star数量

 @param frame frame
 @param number Star数量, 默认为5
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withNumberOfStar:(NSInteger)number;

/**
 初始化, Star数量, 以及图片

 @param frame frame
 @param number Star数量, 默认为5
 @param images 图片images.0为选中状态, images.1为未选中状态
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withNumberOfStar:(NSInteger)number images:(NSArray<UIImage *> *)images;

/**
 初始化, 图片

 @param frame frame
 @param images 图片images.0为选中状态, images.1为未选中状态
 @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray<UIImage *> *)images;

/**
 是否为纯展示模式, 默认为NO
 */
@property (nonatomic, assign) BOOL isRevealModel;

/**
 是否可以拖动选择, 默认为YES
 */
@property (nonatomic, assign) BOOL canDragSelect;

/**
 是否支持小数, 默认为YES
 */
@property (nonatomic, assign) BOOL canDecimals;

/**
 是否使用半星, 默认NO, 设置为YES时canDecimals将不起作用
 */
@property (nonatomic, assign) BOOL isHalfStar;

/**
 各Star间的距离, 默认按照Frame平均分布
 */
@property (nonatomic, assign) CGFloat spacing;

/**
 Star分值，一星算一分
 */
@property (nonatomic, assign) CGFloat starRating;

/**
 触摸响应
 */
@property (nonatomic, copy) void(^qbStarTouchedHandle)(CGFloat starRating);

@end

NS_ASSUME_NONNULL_END
