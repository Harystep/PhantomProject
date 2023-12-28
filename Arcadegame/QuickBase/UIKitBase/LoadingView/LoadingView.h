//
//  LoadingView.h
//  Interactive
//
//  Created by Abner on 15/12/29.
//  Copyright © 2015年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProgressView;

@interface LoadingView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) ProgressView *progressView;

+ (LoadingView *)startLoadingForView:(UIView *)view withProgress:(CGFloat)progress;
+ (void)stopLoadingForView:(UIView *)view;
+ (void)stopLoadingForcible;
+ (void)stopLoadingForcibleWithView:(UIView *)view;

/**
 *  支持由大到小以及由小到大进度
 */
//+ (LoadingView *)startLoadingForView:(UIView *)view withProgress:(CGFloat)progress;
//+ (void)stopProgressLoadingView;

+ (LoadingView *)sharedLoadingView;

@end

/**
 *  ProgressView
 */
@interface ProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

@end

