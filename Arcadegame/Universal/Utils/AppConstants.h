//
//  AppConstants.h
//  Abner
//
//  Created by Abner on 15/3/6.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#ifndef Abner_AppConstants_h
#define Abner_AppConstants_h

/***************************************************************************
 *
 * APP 常量
 *
 ***************************************************************************/

//#ifdef USEBASEURL
//    #define WSURL @"http://ar.jingfree.com:8010/"
//#else
//    #define WSURL @"http://exe666.com/client"
//#endif

#define WSURL @"https://hyjjq-api.5iwanquan.com/api"
//@"https://qsylc.5iwanquan.com/api"
//@"https://jjdwc-api.5iwanquan.com/api"
//#define WSURL @"https://jjdwc-api.5iwanquan.com/api"
//#define NDWSURL @"https://h5.ewangshop.com"
#define CHANNEL_KEY @"huanyingjiejiquan"
//@"jiejidianwancheng"
//#define GAMEHOST @"123.60.149.177"
//#define GAMEPORT @"56792"
#define GAMEHOST @"121.36.196.87"
#define GAMEPORT @"58888"

static const NSString *kNewsDetailAPI = @"/newsDetail/";
static const NSString *kServiceUrl = @"http://www.zuoja.com/license.html";

static NSString *const kAPISalt = @"00987b7224b540d4ae7838d2a468298a";
static NSString *const kAPISaltOther = @"0a39e578a4244c4199a3df5115f1005a";

#define NOTIFICATIONRELOADUSERINFO @"NOTIFICATIONRELOADUSERINFO"
#define NOTIFICATION401RELOGIN @"NOTIFICATION401RELOGIN"
// 6001

//@"http://ar.jingfree.com:81/ar/"

/*
 方案Code :  FC200100000022339

 秘钥：  nCUyEKt+GHrtOnlnkvS9ehwJiu6IgLg7p3kJAp3mqimeHmhpRjhFxCOsoxPRUbL8TR36JL4KSmYqnVBKBvK/hHdk7GJDjI3UL4uaZkspmWzDFZ84Q37I7524sDl5mH8HUB1JkFpnXHYcQnfnsokgzpuVhLCcDTqzk7h+u54hw/KKn3hxNw7++0AqiDJ9ImLMAj7RVWu9bi32zCqa/yDV/tktgy5bnm4ZwUMjLkwoOkdrfK7e2LnohEmaE72Gh5kNlGekeesXAHs=
 */
#define PNSATAUTHSDKINFO @"i96I8wnG1cyKR48pe3M6GKFBFN7yVka/cINGkpaWEBzzMhdq68F3e2z8ubXI/XMXvAjvALB7OzptrtMEXYx2AcEKMSOL/CpIRaRPjfCW81+1q/6xObKZ7Igcg6D/+gFW8ZDh8Ltdx493YJWon5RLjse6JRjTQwYVEAj1MBkvVbNS9+4uGcmKAg+UHhuP7D+sZQVlT7ODH5a//VSa+L9vgXugi87ce17oXXUb19Zu+r0P6h43k7d8IjIg121OpkiYeJ2Dw0dpczTUJlYHMBkbFw=="


//IMAGE_NAMED(@"default_user_backImage")

// 关于我们
#define URL_CUSTOMABOUT_LINK @"/aboutUs?a=1"
#define INVITEURL @"/invite/"
#define DISTRIBUTION_INVITE @"/inviteLogin"

// <隐私政策><用户协议>
#define URL_ARCADEGAME_POLICY_LINK @"http://hyjjq-site.5iwanquan.com/policy.html"
#define URL_ARCADEGAME_USER_LINK  @"http://hyjjq-site.5iwanquan.com/user.html"

#define NOTIFICATION_PAYRESULT  @"NOTIFICATION_PAYRESULT"
#define NOTIFICATION_LOGOUT     @"NOTIFICATION_LOGOUT"
#define NOTIFICATION_LOGIN      @"NOTIFICATION_LOGIN"
#define NOTIFICATION_LOGIN_F    @"NOTIFICATION_LOGIN_F"
#define NOTIFICATION_REFRESH    @"NOTIFICATION_REFRESH"

//缓存字段名&文件名
#define kUserMobilePhoneNum         @"userMobilePhoneNum"       //用户手机号
#define kBackgroundImageName        @"sys_background"           //背景图片名
#define kDetailBackgroundImageName  @"detail_sys_background"    //商品详情背景图片名
#define kUserInfoDataCache          @"userInfoDataCache"        //用户缓存文件

static char * decryptConstString(char* string){
    char *origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}
#define ZFJ_NSSTRING(string) [NSString stringWithUTF8String:decryptConstString(string)]

#endif
