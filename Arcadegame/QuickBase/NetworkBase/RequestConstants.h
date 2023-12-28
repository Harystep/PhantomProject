//
//  RequestConstants.h
//  Interactive
//
//  Created by Abner on 16/4/12.
//  Copyright © 2016年 Abner. All rights reserved.
//

#ifndef RequestConstants_h
#define RequestConstants_h

static int kCountOfSinglePage = 10;
static int kInitialIndexPage = 1; // 页码起始值

typedef NS_ENUM(NSInteger, HttpType) {
    
    NONE = 0,
    POST = 1,
    GET = 2,
    PUT = 3,
    DELETE = 4,
    PATCH = 5,
};

typedef enum{
    ErrorType_NOERROR,        //请求成功
    ErrorType_NOCONNECTION,   //没有网络连接
    ErrorType_SEVERERROR,     //服务器错误
    ErrorType_RESPONSEERROR,  //返回数据错误(通用错误)
    ErrorType_NORESPONSEDATA, //返回数据为空
    ErrorType_NOLOGIN,        //未登录
    ErrorType_UPDATE,         //需要升级
    ErrorType_PHYSICALNEED,   //体力不足
    ErrorType_Internal_Error,  //200 suceed = 0
    ErrorType_HttpType_Error,
}ConnectionErrorType;

//typedef enum : NSUInteger {
//    UserErrorType_START = 200000,
//
//    //第三方登录的uid不合法
//    UserErrorType_Invalid_UID = 200001,
//
//    //该第三方帐号未绑定过我们的账号
//    UserErrorType_ACCOUNT_NOTBIND = 200002,
//
//    //该第三方帐号已经在系统里注册过了
//    UserErrorType_ACCOUNT_UID_HAS_REGISTER = 200003,
//
//    //账号被冻结了
//    UserErrorType_ACCOUNT_FREEZED = 200004,
//
//    //非法字符 名字已注册
//    UserErrorType_Invalid_charactors = 200005,
//
//    UserErrorType_END = 200006
//
//}UserErrorType;

//typedef enum : NSUInteger{
//    CommonErrorType_Start = 100000,
//    CommonErrorType_common          = 100001,
//    CommonErrorType_broken          = 100002,
//    CommonErrorType_parameterCheck  = 100003,
//    CommonErrorType_clientUpgradeNeed = 100004,
//    CommonErrorType_timeout           = 100005,
//    CommonErrorType_serverMaintaince  = 100006,
//    CommonErrorType_unauthorized      = 100401,
//    CommonErrorType_forbidden         = 100403,
//    CommonErrorType_end               = 100404,
//
//}CommonErrorType;

#endif /* RequestConstants_h */
