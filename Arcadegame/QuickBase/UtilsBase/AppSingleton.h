//
//  AppSingleton.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LLSplitViewController.h"
//#import "AbountContentManage.h"
//#import "UserEntity.h"

/***************************************************************************
 *
 * 全局变量
 *
 ***************************************************************************/

@interface AppSingleton : NSObject

// @property (nonatomic, strong) NSString *xmlConfigPath;
@property (nonatomic, strong) NSArray *xmlConfigPathArray;
@property (nonatomic, strong) NSString *tokenString;
@property (nonatomic, strong) NSString *baseUrlString;
@property (nonatomic, strong) NSString *newsUrlString;
@property (nonatomic, assign) NSTimeInterval localAndServerTimeOffset;
@property (nonatomic, assign) NSTimeInterval serverLastTime;
//@property (nonatomic, strong) LLSplitViewController *llSplitVC;
//@property (nonatomic, strong) UserEntity *userEntity;
@property (nonatomic, strong) id userData;
@property (nonatomic, assign) BOOL isUserLogin;
@property (nonatomic, assign) BOOL hasRedPaperShow;
@property (nonatomic, strong) NSLock *showDataLock;
//@property (nonatomic, strong) AbountContentEntity *abountContentEntity;

@property (nonatomic, assign) BOOL canOrientationMaskLandscape;

@property (nonatomic, strong) NSLock *extendTargetCacheItemLock;

@property (nonatomic, strong) NSString *currentAPISalt;

/**
 *  需要本地存储的变量
 */
@property (nonatomic, assign) BOOL isShowedLeadPageView;

/**
 *  是否显示APP介绍/引导页
 */
@property (nonatomic, assign) BOOL isShowedIntoductionView;

/**
 *  是否显示播放器教学
 */
@property (nonatomic, assign) BOOL isShowedPlayerTeach;

/**
 *  首页商品的时间轴ID
 */
@property (nonatomic, strong) NSString *homeGoodsTimeId;

/**
 *  未登录返回nil;自行判断是否为nil
 */
@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, strong) NSDictionary *userSessionDic;

/**
 *  全局背景图(模糊)
 */
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) BOOL isRefreshBackgroundImage;

@end
