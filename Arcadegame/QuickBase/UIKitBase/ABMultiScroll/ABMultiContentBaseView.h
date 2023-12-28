//
//  ABMultiContentBaseView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/6/3.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义非ScrollView基类，实现scrollViewDidScroll的自动代理
 */

@protocol ABMultiContentBaseViewDelegate;

@interface ABMultiContentBaseView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<ABMultiContentBaseViewDelegate> delegate;

/**
 获取自定义非ScrollView类的子scrollView;在子类中需要对其赋值
 */
@property (nonatomic) UIScrollView *scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

/**
 ABMultiContentBaseViewDelegate
 */
@protocol ABMultiContentBaseViewDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
