//
//  BaseTableViewController.h
//  Abner
//
//  Created by Abner on 15/3/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

/**
 *  子类实现 TableView注册Cell
 */
- (Class)tableViewCellClass;

#pragma mark - 下拉刷新上拉加载
/**
 *  给ScrollView添加刷新事件
 */
- (void)addRefreshControlWithScrollView:(UIScrollView *)scrollView isInitialRefresh:(BOOL)isRefresh shouldInsert:(BOOL)shouldInsert forKey:(const void *)key;
/**
 *  手动下拉刷新
 */
- (void)triggerPullToRefreshWithKey:(const void *)key;
/**
 *  下拉刷新事件响应调用的方法,需子类重写
 */
- (void)dropViewDidBeginRefresh:(const void *)key;
/**
 *  下拉加载完成,取消动画
 */
- (void)dropViewDidFinishRefresh:(const void *)key;
/**
 *  上拉加载事件调用方法,需子类重写
 */
- (void)loadInsertDidBeginRefresh:(const void *)key;
/**
 *  上拉加载完成,取消动画
 */
- (void)loadInsertDidFinishRefresh:(const void *)key;
/**
 *  加载完成,取消下拉或者上拉动画
 */
- (void)refreshDidFinishRefresh:(const void *)key;

#pragma mark - Set NaviBar Button
/* 项目默认左导航栏按钮 */
- (void)setLeftNaviBarButton;
/* 项目默认右导航栏按钮 */
- (void)setRightNaviBarButton;

/* 隐藏左导航栏按钮 */
- (void)hideLeftNaviBarButton;
/* 隐藏右导航栏按钮 */
- (void)hideRightNaviBarButton;

/* 自定义左导航栏按钮 */
- (void)setLeftNaviBarButton:(UIImage *)normalImage
                   highImage:(UIImage *)highImage
                    selector:(SEL)btnAction;

/* 自定义右导航栏按钮 */
- (UIButton *)setRightNaviBarButton:(UIImage *)normalImage
                          highImage:(UIImage *)highImage
                           selector:(SEL)btnAction;

/* 自定义导航栏按钮,根据高度等比缩放按钮背景图 */
- (UIButton *)setNaviBarButton:(UIImage *)normalImage
                     highImage:(UIImage *)highImage
                  buttonHeight:(CGFloat)buttonHeight
                      selector:(SEL)btnAction;

/* 设置右导航纯文字按钮 */
- (UIButton *)setRightNaviBarTitle:(NSString *)titleString
                       normalColor:(UIColor *)normalColor
                         highColor:(UIColor *)highColor
                          selector:(SEL)btnAction;

/* 设置导航纯文字按钮 */
- (UIButton *)setNaviBarButtonTitle:(NSString *)titleString
                        normalColor:(UIColor *)normalColor
                          highColor:(UIColor *)highColor
                           selector:(SEL)btnAction;

/**
 *  导航栏按钮响应方法
 */
/* left button action */
- (void)backToParentView;
/* right button action */
- (void)rightBtnAction:(id)sender;

/**
 *  Loading
 */
- (void)popLoadingView;
- (void)removeLoadingView;

@end
