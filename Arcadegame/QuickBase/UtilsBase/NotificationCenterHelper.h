//
//  NotificationCenterHelper.h
//  Interactive
//
//  Created by Abner on 16/5/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NotifyObject;

/**
 *  在.m中的 NSStringFromNotifCenterName 中注册；
 *  e.g.:ENUM_CASE(Cache_LoginEntity)
 */
typedef NS_ENUM(NSInteger, NotifCenterType){
    NotificationCenterVRPlaying,  // VR 开始播放
    NotificationCenterRelogin, // 重新登录
    NotificationCenterRefreshData, // 刷新页面数据
    NotificationCenterTimer, // 秒计时器
    NotificationCenterRloadCart, // 购物车数据刷新
//    NotificationCenterPayResult, // 支付结果通知
//    NotificationCenterPayViewClose, // 退出支付页面通知
//    NotificationCenterPayViewCloseFromCart, // 购物车退出支付页面通知
    NotificationCenterRYProgress, // 融云相关通知
    NotificationCenterLoginout, // 退出登录
//    NotificationCenterPayPassword, // 设置交易密码成功
//    NotificationCenterWechatLoginResult, // 微信登录结果通知
    NotificationCenterMessageUnread, // 未读系统消息通知
    NotificationCenterUserInfoReload, // 用户信息更新
    NotificationCenterLogined,
};

@interface NotificationCenterHelper : NSObject

+ (void)addNotifiction:(NotifCenterType)typeName observer:(id)observer selector:(SEL)selector;

+ (void)postNotifiction:(NotifCenterType)typeName userInfo:(NSDictionary *)userInfo;

+ (void)removeNotifiction:(NotifCenterType)typeName observer:(id)observer;

+ (void)removeAllNotifiction:(id)observer;

+ (NotifyObject *)createNotifyObject:(id)object,...;

@end

/**
 *  NotifyObject
 */
@interface NotifyObject : NSObject

@end
