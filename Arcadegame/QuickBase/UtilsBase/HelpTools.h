//
//  HelpTools.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "GiveupOrderDimmerView.h"

@class UserEntity;
@class SetingEntity;

typedef NS_ENUM(NSInteger, IntervalDateState) {
    IntervalDateState_Unstart,
    IntervalDateState_InProgress,
    IntervalDateState_End,
};

/***************************************************************************
 *
 * 工具类
 *
 ***************************************************************************/

//@class AppDelegate;
@class AppSingleton;

@interface HelpTools : NSObject

//+ (AppDelegate *)sharedAppDelegate;

+ (AppSingleton *)sharedAppSingleton;

/**
 *  QuickBaseConfig
 */
+ (NSDictionary *)readBaseConfigData;
+ (id)getLoginVCInfoFromConfig;
+ (NSDictionary *)getURLParams:(NSString *)urlString;

/**
 *  APP Version(根据保存在本地的版本号判断是否覆盖安装)
 */
+ (BOOL)isCoveringInstallation;
+ (NSString *)lastVersion;

//-----------------------------------------------------------------------------
#pragma mark - User common cache data save and get
/**
 *  缓存背景图片到本地
 */
+ (BOOL)saveBackgroundImage:(UIImage *)image isDetail:(BOOL)iDetail;

/**
 *  获取背景图片
 *
 *  @return If there is no network image,then take the local default image
 */
+ (UIImage *)getBackgroundImageWith20PercentMaskIsDetail:(BOOL)isDetail isRefresh:(BOOL)isRefresh;

/**
 *  获取背景图片 高斯模糊+70%透明的黑色遮罩层
 */
+ (UIImage *)getBackgroundImageWithBlurAndMask:(void (^)(UIImage *image))handle;

/**
 *  @param image 高斯模糊的image
 *  @param level 模糊半径
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)level;

+ (void)createNormalBlurImage_async:(UIImage *)image handle:(void (^)(UIImage *image))handle;

/**
*  对图片清晰度重新处理
*  @param targetSizeWidth 目标大小
*/
+ (UIImage *)correctImageQualityWithCIImage:(CIImage *)image withSizeWidth:(CGFloat)targetSizeWidth;

/**
 *  生成二维码 (> iOS 7)
 *  @param content 二维码内容
 */
+ (UIImage *)QRCodeImageWithContent:(NSString *)content;
+ (UIImage *)QRCodeImageWithContent:(NSString *)content withSizeWidth:(CGFloat)targetSizeWidth;

/**
 *  保存以及获取用户手机号
 */
+ (BOOL)saveUserMobilePhoneNumber:(NSString *)phoneNum;
+ (NSString *)getUserMobilePhomeNumber;
+ (NSString *)getUserPayCoins;

/**
 *  Getter Setter user session struct
 */
+ (void)setUserDataNull:(void(^)(BOOL isSuccess))result;
+ (void)prereadUserDataHandle:(void(^)(void))handle;
+ (void)saveUserData:(id)userData;
+ (void)saveUserDataCleanToken;
+ (void)cleanUserDataCache;
+ (id )userData;
+ (id)userDataForToken;
+ (BOOL)isLoginHandle:(void(^)(BOOL isLoginSuccess))loginHandle;
+ (BOOL)isLogin;
+ (BOOL)isLoginWithoutVC;
+ (NSDictionary *)getUserSessionObject;
+ (void)saveTabMenuEntity:(SetingEntity *)settingEntity;
+ (SetingEntity *)getTabMenuEntity;
+ (NSString *)checkDownLoadURL:(NSString *)urlString;
+ (BOOL)checkShouldSkullIcon:(NSInteger)avid;
+ (void)showHttpError:(id)responseObject complete:(void(^)(BOOL is401))handle;
+ (void)showHttpError:(id)responseObject;
//-----------------------------------------------------------------------------

/**
 *  LoadingView
 */
+ (void)hideLoadingView;
+ (void)hideLoadingForcible;
+ (void)hideLoadingForcibleWithVIew:(UIView *)view;
+ (void)showLoadingForView:(UIView *)view;
+ (void)hideLoadingForView:(UIView *)view;
+ (void)showLoadingForView:(UIView *)view withProgress:(CGFloat)progress;
//+ (void)hideLoadingViewProcess;
+ (void)setLoadingProgress:(CGFloat)progress;

/**
 *  显示Toast
 */
+ (void)showHUDOnlyWithText:(NSString *)text toView:(UIView *)view;
+ (void)showHUDOnlyWithText:(NSString *)text andDetailText:(NSString *)detailText toView:(UIView *)view;

/**
 *  显示底部toast
 */
//+ (void)showDimmerTitle:(NSString *)title  btnTitles:(NSArray *)btnTitles selectIndex:(SelectBlock)selectBlock;

+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view;

+ (void)hideHUDforView:(UIView *)view;

+ (void)hideAllHUDforView:(UIView *)view;

/**
 *  获取父View的Controller
 */
+ (UIViewController *)superViewController:(UIView *)view;
+ (UIViewController *)rootViewController;
// 获取当前正在显示的页面
+ (UIViewController * )activityViewController;
+ (UIWindow *)getKeyWindow;

/**
 *  NSString 转 NSDate
 */
+ (NSDate *)getDateFromGMTString:(NSString *)string;

/**
 *  毫秒时间戳格式化时间
 *
 *  @param timestampString 毫秒时间戳
 *
 *  @return 返回yyyy-MM-dd形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestamp:(NSString *)timestampString;
+ (NSString *)getFormatterDateFromDate:(NSDate *)date;

/**
 *  @return 返回yyyy.MM.dd形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestampStyle1:(NSString *)timestampString;

/**
 *  @return 返回 MM月dd日 形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestampStyle2:(NSString *)timestampString;

/**
 *  @return 返回 YYYY年MM月dd日 HH:mm 形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestampStyle3:(NSString *)timestampString;

/**
 *  @return 返回 yyyy-MM-dd HH:mm:ss 形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestampStyle4:(NSString *)timestampString;

/**
 *  @return 返回 昨天 今天 yyyy-MM-dd HH:mm:ss 形式的时间
 */
+ (NSString *)getFormatterDateFromMsecTimestampStyle5:(NSString *)timestampString;

/**
 *  @return 返回 “进行中 后天结束 MM月dd日 结束”
 */
+ (NSString *)getDateStateFromStartMsecTimestamp:(NSString *)startTimestampString end:(NSString *)endTimestampString;

+ (NSString *)getFormatterDateFromMsecTimestampStyle2:(NSString *)startTimestampString end:(NSString *)endTimestampString;

/**
 *  @return 返回时间区间类型 未开始 进行中 已结束
 */
+ (IntervalDateState)checkDateStateFromStartMsecTimestamp:(NSString *)startTimestampString end:(NSString *)endTimestampString;

/**
 *  @return 返回格式为“yyyy-MM-dd HH:mm:ss”的时间戳
 */
+ (NSTimeInterval)getTimeIntervalForDateString:(NSString *)dateString;

/**
 *  判断系统版好
 *  @return -1：版号错误；0：与本地版号相同；1：比本地版号高；2：比本地版号低
 */
+ (NSInteger)versionCompareWithServerVersion:(NSString *)serverVersion;

/**
 系统空间 单位:MB
 */
+ (double)totalDiskSpace;

/**
 系统剩余空间 单位:MB
 */
+ (double)freeDiskSpace;

/**
 *  根据字符串返回Label的Size
 *
 *  @param string    字符串
 *  @param font      字体大小
 *  @param viewWidth 最大宽度
 */
+ (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font viewWidth:(CGFloat)viewWidth;
//固定宽获取高度size：CGSizeMake(100, MAXFLOAT)
//固定高获取宽度size：CGSizeMake(MAXFLOAT,100)
+ (CGSize)sizeWithString:(NSString *)string withShowSize:(CGSize)showSize withFont:(UIFont *)font;
+ (CGSize)sizeWithAttributeString:(NSAttributedString *)string withShowSize:(CGSize)showSize;

/**
 *  json to dictionary
 *
 *  @param jsonString json字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  View 生成为 UIImage
 */
+ (UIImage *)convertViewToImage:(UIView *)view;

/**
 *  生成纯色的 UIImage 对象
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect)rect;
+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect)rect radius:(CGFloat)radius;

/**
 *  渐变View image
 */
+ (UIView *)createShadeViewWithSize:(CGSize)size withColor:(NSArray *)colors;
+ (UIView *)createHorizontalShadeViewWithSize:(CGSize)size withColor:(NSArray *)colors;
+ (UIImage *)createGradientImageWithSize:(CGSize)size colors:(NSArray *)colors gradientType:(int)gradientType; //gradientType=0:上下 gradientType=1:左右
+ (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii forView:(UIView *)view;
+ (void)removeRoundedCornersForView:(UIView *)view;
// 生成边框为1, 圆角自定, 中间空白的图片
+ (UIImage *)imageBlankWithOneWeightsBorderForSize:(CGSize)size color:(UIColor *)color corner:(CGFloat)corner;
+ (UIImage *)imageCutWithOriginalImage:(UIImage *)originImage withRect:(CGRect)rect;

/**
 *  Check mobile number is valid
 */
+ (BOOL)isValidateMobileNum:(NSString *)mobileNum;
+ (BOOL)isEasyValidateMobileNum:(NSString *)mobileNum;

/**
 *  Check email is valid
 */
+ (BOOL)isValidateEmail:(NSString *)emailString;
// 字符串计算个数
+ (NSUInteger)convertToInt:(NSString *)strtemp;
// 16进制字符串转16进制
+ (NSInteger)numberWithHexString:(NSString *)hexString;
// 16进制转16进制字符串
+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber;
// 获取数字的整数部分
+ (NSInteger)getValueIntegerPart:(CGFloat)priceValue;
// 获取数字的小数部分；length:小数后几位
+ (NSInteger)getValueDecimalPart:(CGFloat)priceValue withLength:(NSInteger)length;
// 截取相同两个字符中间的字符
+ (NSString *)subStringDoubleFlagSeparateWithContentText:(NSString *)contentText separateString:(NSString *)separateString;

/**
 *  Check network is reachable
 */
+ (BOOL)connectedToNetwork;

/**
 *  Check string is pure number
 */
+ (BOOL)stringIsPureInt:(NSString *)string;
+ (BOOL)stringIsPureFloat:(NSString *)string;
+ (BOOL)stringIsPureNumber:(NSString *)string;

/**
 *  get uuid
 */
+ (NSString *)getUUID;

/**
 *  get device model
 */
+ (NSString *)deviceModel;
+ (BOOL)iPhoneNotchScreen;

/**
 *  返回的是服务器与本地时间的秒数
 */
+ (NSTimeInterval)getOffsetForLocalAndServerDate:(NSDate *)serverData;

/**
 *  Get Lable
 */
+ (UILabel *)getLabelWithFont:(UIFont *)font withTextColor:(UIColor *)textColor;

/**
*  Price
*/
+ (double)getDecimalPriceValueWithFloatData:(CGFloat)data;
+ (NSDecimalNumber *)getDecimalPriceValueWithFloatData1:(CGFloat)data;
+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithFloatValue:(CGFloat)floadValue;
+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithNumberValue:(NSNumber *)numberValue;
+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithDCNumberValue:(NSDecimalNumber *)numberValue;
+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithStringValue:(NSString *)stringValue;

/**
 *  NSNotificationCenter
 */
+ (void)addNotifiction:(NSString *)name observer:(id)observer selector:(SEL)selector;
+ (void)postNotifiction:(NSString *)name userInfo:(NSDictionary *)userInfo;
+ (void)removeNotifiction:(NSString *)name observer:(id)observer;
+ (void)removeAllNotifiction:(id)observer;

+ (NSString *)md5:(NSString *)string;
+ (void)pasteWithText:(NSString *)text;

/**
 *  System Size
 */
+ (UIWindow *)keyWindow;
+ (CGRect)statusBarFrame;
+ (CGFloat)safeAreaInsetsTop;
+ (CGFloat)safeAreaInsetsBottom;

/**
 * APP
 */
+ (NSString *)checkNumberInfo:(NSString *)userNum plus:(NSInteger)plus;
+ (NSString *)checkCircleInfo:(NSString *)userNum;
+ (NSString *)checkNumberInfo:(NSString *)userNum;
+ (NSString *)urlencode:(NSString *)url;

+ (void)savePlayRecordInfo:(NSDictionary *)dic;
+ (NSMutableArray *)getPlayRecordInfo;

@end
