//
//  ABMultiContainerTableView.h
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/5/30.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 使用时，内容视图需要实现Scroll的代理来控制容器是否可以滚动
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
 if (!self.mContainerTableView.canContentScroll) {
 
 scrollView.contentOffset = CGPointZero;
 }
 else if (scrollView.contentOffset.y <= 0) {
 
 self.mContainerTableView.canContentScroll = NO;
 self.mContainerTableView.canContainerScroll = YES;
 }
 
 scrollView.showsVerticalScrollIndicator = self.mContainerTableView.canContentScroll;
 }
 */

@protocol ABMultiContainerViewCustomDataSource, ABMultiContainerViewCustomDelegate;

@interface ABMultiContainerTableView : UITableView

/**
 底部视图(类似淘宝商品详情底部View)
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 分段控制器
 */
@property (nonatomic, strong) UIView *segmentView;

/**
 子试图
 */
@property (nonatomic, strong) NSArray *contentViewsArray;

@property (nonatomic, weak) id<ABMultiContainerViewCustomDataSource> customDataSource;
@property (nonatomic, weak) id<ABMultiContainerViewCustomDelegate> customDelegate;

/**
 控制容器是否可以滚动
 */
@property (nonatomic, assign) BOOL canContainerScroll;

/**
 控制内容视图是否可以滚动
 */
@property (nonatomic, assign) BOOL canContentScroll;

/**
 是否隐藏底部视图
 */
@property (nonatomic, assign) BOOL shouldHideBottomView;

/**
 控制滚动到index页

 @param index index
 */
- (void)contentScrollToIndex:(NSInteger)index;

@end

/**
 ABMultiContainerViewCustomDataSource
 */
@protocol ABMultiContainerViewCustomDataSource <NSObject>

@optional
/**
 根据导航栏是否透明,返回顶部高度

 @param containerView ABMultiContainerTableView
 @return translucent=false,默认为0;
                translucent=ture,普通机型return 64,刘海屏return 88;
 */
- (CGFloat)containerTableViewContentInsetTop:(ABMultiContainerTableView *)containerView;

/**
 设置ContentView底部距离

 @param containerView ABMultiContainerTableView
 @return 默认为0; 刘海屏需要return 34;
 */
- (CGFloat)containerTableViewContentInsetBottom:(ABMultiContainerTableView *)containerView;
- (CGFloat)containerTableViewContentFixedOffsetY:(ABMultiContainerTableView *)containerView;

@end

/**
 ABMultiContainerViewCustomDelegate
 */
@protocol ABMultiContainerViewCustomDelegate <NSObject>

@optional
/**
 通知内容页面是否可以滚动
 */
- (void)containerViewContentShouldScroll:(BOOL)shouldScroll;

/**
 通知容器是否可以滚动
 */
- (void)containerViewContainerShouldScroll:(BOOL)shouldScroll;

/**
 当前容器滚动监控
 */
- (void)containerViewDidScroll:(UIScrollView *)scrollView;

/**
 通过滑动内容视图滚动

 @param index 当前页码
 */
- (void)containerViewContentDidScrollToIndex:(NSInteger)index;

/**
 通过滑动内容视图滚动

 @param index 即将显示的页面，尚未滚动到该页面
 */
- (void)containerViewContentWillScrollToIndex:(NSInteger)index;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

NS_ASSUME_NONNULL_END
