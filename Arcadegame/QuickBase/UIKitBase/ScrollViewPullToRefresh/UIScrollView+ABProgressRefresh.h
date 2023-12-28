//
//  UIScrollView+ABProgressRefresh.h
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ABProgressRefresh)

#pragma mark - PullToRefresh 下拉刷新
// 是否正在刷新
@property (nonatomic, assign, readonly, getter = isPullRefreshing) BOOL pullRefreshing;

// 添加下拉刷新
- (void)addPullToRefreshActionHandler:(void(^)(void))handle;
// 主动刷新
- (void)triggerPullToRefresh;
// 停止刷新动画
- (void)stopPullRefreshAnimation;
// 移除已添加的下拉刷新
- (void)removePullRefreshView;

#pragma mark - InsertToRefresh 上拉加载
// 是否需要加载更多
@property (nonatomic, assign, getter = isInsertMore) BOOL insertMore;
// 是否正在加载
@property (nonatomic, assign, readonly, getter = isInsertRefreshing) BOOL insertRefreshing;

@property (nonatomic, strong, setter = setMoreInfoString:) NSString *moreInfoString;

// 添加上拉加载
- (void)addInsertToRefreshActionHandler:(void(^)(void))handle;
// 停止加载动画
- (void)stopInsertRefreshAnimation;
// 移除已添加的上拉加载
- (void)removeInsertRefreshView;

@end
