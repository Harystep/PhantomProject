//
//  Constants.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#ifndef Abner_Constants_h
#define Abner_Constants_h

/***************************************************************************
 *
 * 通用常量
 *
 ***************************************************************************/

/**
 *  判断系统 & 设备
 */
#define SYSTEM_VERSION_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define isIOS8          ((([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) && ([[[UIDevice currentDevice] systemVersion] doubleValue] < 9.0)) ? YES : NO)
#define isIOS8_LATER    ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO)
#define isIOS7_LATER    ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0? YES : NO)
#define isIOS5_EARLIER  ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0? YES : NO)

#define isPad           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIphone        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isIPHONE4       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPHONE5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPHONE6       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPHONE6P      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPHONEX      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPHONE6_LATER ((isIPHONE6 || isIPHONE6P || isIPHONEX) ? YES : NO)

/**
 *  系统版本号 & APP名称 & APP版本号
 */
#define SYSTEMVERSION_FLOAT     ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SYSTEMVERSION_STRING    ([[UIDevice currentDevice] systemVersion])

//#define APP_DISPLAY_NAME    [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define APP_BUNDLE_NAME  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define APP_DISPLAY_NAME    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUNDLEVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/**
 *  获取颜色
 */
#define RGB_COLOR(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_COLOR_ALPHA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB_ALPHA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

/**
 *  debug log
 */
#if DEBUG
#define DLOG(FORMAT, ...) NSLog(@"<%s:%d>\t%@\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define DLOG(FORMAT, ...)
#endif

/**
 *  App Main Frame
 */
#define MainScreenScale     [[UIScreen mainScreen] scale] //屏幕的分辨率 结果为1时，普通屏，结果为2时，Retian屏
#define Application_Frame   [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame
#define Application_Height  [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度
#define Application_Width   [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度
#define Main_Screen_Height  [[UIScreen mainScreen] bounds].size.height //主屏幕的高度
#define Main_Screen_Width   [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define maxViewHeight       ((isIOS7_LATER == NO) ? Application_Height:Main_Screen_Height)//界面最大高度
/**
 *  系统控件的默认高度
 */
#define kStatusBarHeight    [UIApplication sharedApplication].statusBarFrame.size.height
#define kNaviBarHeight      (44.f)
#define kTabBarHeight       (49.f)
#define kCellDefaultHeight  (44.f)
#define kSafeAreaHeight  (34.f)
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
/**
 *   基础计算pt值
 */
#define kPadding 8.f

/**
 *  键盘的高度
 */
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

/**
 *  PNG JPG 图片路径
 */
#define IMAGE_PNG_PATH(NAME)        [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]
#define IMAGE_JPG_PATH(NAME)        [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]
#define IMAGE_ANY_PATH(NAME, TYPE)  [[NSBundle mainBundle] pathForResource:(NAME) ofType:(TYPE)]

/**
 *  图片加载
 */
#define IMAGE_PNG_NAMED(NAME)       [UIImage imageWithContentsOfFile:IMAGE_PNG_PATH(NAME)]
#define IMAGE_JPG_NAMED(NAME)       [UIImage imageWithContentsOfFile:IMAGE_JPG_PATH(NAME)]
#define IMAGE_ANY_NAMED(NAME, TYPE) [UIImage imageWithContentsOfFile:IMAGE_ANY_PATH(NAME, TYPE)]
#define IMAGE_NAMED(NAME)           [UIImage imageNamed:(NAME)]

/**
 *  字体大小
 */
#define FONT_BOLD_SYSTEM(FONTSIZE)  [UIFont boldSystemFontOfSize:FONTSIZE]
#define FONT_SYSTEM(FONTSIZE)       [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)        [UIFont fontWithName:(NAME) size:(FONTSIZE)]

/**
 *  AppDelegate
 */
#define kAppDelegate    ((AppDelegate *)([UIApplication sharedApplication].delegate))

/**
 *  block
 */
#define __BlockObject(object) __block typeof(object)__blockObject = object
#define __StrongObject(weakSelf) __strong __typeof(weakSelf)strongSelf = weakSelf

#define __WeakObject(object) __weak __typeof(object)__weakObject = object
#define __WeakStrongObject() __strong __typeof(__weakObject)__strongObject = __weakObject

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/**
 *  dispatch_main_async_safe
 */
#define dispatch_main_async_safe(block)\
        if ([NSThread isMainThread]) {\
            block();\
        } else {\
            dispatch_async(dispatch_get_main_queue(), block);\
        }

/**
 *  adjustsScrollViewInsets
 */
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#define UITableViewEstimatedHeight(tableView) \
if (@available(iOS 11.0, *)) { \
tableView.estimatedRowHeight = 0; \
tableView.estimatedSectionHeaderHeight = 0; \
tableView.estimatedSectionFooterHeight = 0; \
}

/**
 *  NS_ENUM TO STRING
 */
#define ENUM_BEGIN const char *c_str = 0; switch(typeName) {

#define ENUM_CASE(value) case (value): c_str = #value; break;

#define ENUM_END default: break; } return [NSString stringWithCString:c_str encoding:NSASCIIStringEncoding];

#define AB_ENUM_BEGIN const char *c_str = 0; switch(typeName) {

#define AB_ENUM_CASE(value) case (value): c_str = #value; break;

#define AB_ENUM_END default: break; } return [NSString stringWithCString:c_str encoding:NSASCIIStringEncoding];

/**
 *  Waring
 */
/*
 1.方法弃用告警
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wdeprecated-declarations"
 
 #pragma clang diagnostic pop
 
 2.指针类型不兼容
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wincompatible-pointer-types"
 
 #pragma clang diagnostic pop
 
 3.循环引用
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-retain-cycles"
 
 #pragma clang diagnostic pop
 
 4.未使用变量
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wunused-variable"
 
 #pragma clang diagnostic pop
 */

// 5.未知方法
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//缓存字段名&文件名
#define kUserMobilePhoneNum                 @"userMobilePhoneNum"         //用户手机号
#define kBackgroundImageName               @"sys_background"                  //背景图片名
#define kDetailBackgroundImageName      @"detail_sys_background"       //商品详情背景图片名

//缓存字体大小比例
#define kFontValueRateDefault  @"kFontValueRateDefault"

//在keychain中保存生成的UUID
#define kKEYCHAIN_UUID  @"com.exelook.app.uuid"

//资源下载地址
#define DOWNLOAD_URL @""

//刷新通知
#define NOTIFICATION_REFRESH_DATA(s) [NSString stringWithFormat:@"NOTIFICATION_REFRESH_%@", [s uppercaseString]]

//access token
#define kAccessToken @"1asdf12asdfe44sdfawdfjoly_tokenasdfag3344"

#endif
