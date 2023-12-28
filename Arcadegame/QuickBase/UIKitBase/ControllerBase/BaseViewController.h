//
//  BaseViewController.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJErrorView.h"

#import "AGNavigateView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL isInsertRefreshing;

@property (nonatomic, strong) ZJErrorView *mZJErrorViewEmpty;
@property (nonatomic, strong) ZJErrorView *mZJErrorViewError;
@property (strong, nonatomic) UILabel *mEmptyNoticeLabel;
@property (strong, nonatomic) UILabel *mErroNoticeLabel;

@property (strong, nonatomic) AGNavigateView *mAGNavigateView;

- (void)setAGNavibarHide:(BOOL)isHide;

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

/**
 *  没有更多
 */
- (void)shouldInsertMore:(BOOL)shouldMore key:(const void *)key;
- (void)setMoreInfoString:(NSString *)moreInfoString withKey:(const void *)key;

/**
 重新刷新页面数据(eg: 登录过期，重新登录后刷新)
 */
- (void)didReloadViewData;

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


- (NSArray *)setRightNaviBarButtons:(NSArray *)normalImages
                         highImages:(NSArray *)highImages
                     selectedImages:(NSArray *)selectedImages
                       buttonHeight:(CGFloat)buttonHeight
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
- (void)leftBtnAction:(id)sender;
/* back */
- (void)backToParentView;
- (void)backToParentViewAnimate:(BOOL)Animate;
- (void)backToRootViewControllerAnimate:(BOOL)animate;
/* right button action */
- (void)rightBtnAction:(id)sender;

/**
 *  是否属于自定义模仿push动画
 */
- (void)setPushDirectionFlag;

/**
 *  刷新数据,子类实现具体方法
 */
- (void)reloadDataFromServer:(id)sender;

/**
 *  Loading
 */
- (void)popLoadingView;
- (void)removeLoadingView;

/**
 *  Keyboard
 */
- (void)addClickCloseKeyboardForObserver:(id)observer;
- (void)hideKeyBoard;

@end
