//
//  ConfigUtility.h
//  Abner
//
//  Created by Abner on 15/3/6.
//  Copyright © 2015年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <RongIMKit/RongIMKit.h>

@interface ConfigUtility : NSObject

/**
 *  初始化全局UI
 */
+ (void)initUIAppearance;

/**
 *  设置全局HTTP请求的UserAgent
 */
+ (void)setHttpRequestUserAgent;
+ (void)setHttpRequestUserAgentWithNewAgent:(NSString *)agent;

/**
 *  初始化容云
 */
+ (void)initRongClound;

@end
