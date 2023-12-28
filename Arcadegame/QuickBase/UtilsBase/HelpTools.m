//
//  HelpTools.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import "HelpTools.h"
//#import "AppDelegate.h"
//#import "EXEUserData.h"
//#import "UserEntity.h"
//#import "LoginEntity.h"
#import "LoadingView.h"
//#import "SetingEntity.h"
#import "MBProgressHUDFIX.h"
#import "CarouselImageView.h"
#import "UIImage+GaussianBlur.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <Security/Security.h>
#import <sys/utsname.h>
#import <netinet/in.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <CommonCrypto/CommonCrypto.h>

//#import "KDLoginViewController.h"
#import "UIViewController+Activity.h"
#import "HttpErrorEntity.h"

@implementation HelpTools

#pragma mark - Singleton
//+ (AppDelegate *)sharedAppDelegate{
//    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
//}

+ (AppSingleton *)sharedAppSingleton{
    static AppSingleton *sharedAppSingleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppSingleton = [AppSingleton new];
    });
    
    return sharedAppSingleton;
}

/**
 *  QuickBaseConfig
 */
+ (NSDictionary *)readBaseConfigData{
    
    NSString *configPlistPath = [[NSBundle mainBundle] pathForResource:@"QuickBaseConfig" ofType:@"plist"];
    
    return [[NSDictionary alloc] initWithContentsOfFile:configPlistPath];
}

// QBLOGINCLASS
+ (id)getLoginVCInfoFromConfig{
    
    NSDictionary *configDataDic = [HelpTools readBaseConfigData];
    if(configDataDic){
        
        NSString *className = [[configDataDic valueForKey:@"QBLOGINCLASS"] valueForKey:@"className"];
        NSString *initMethodName = [[configDataDic valueForKey:@"QBLOGINCLASS"] valueForKey:@"initMethodName"];
        NSArray *initPropertyValueArray = [[configDataDic valueForKey:@"QBLOGINCLASS"] valueForKey:@"initPropertyValue"];
        NSDictionary *propertyKeysDic = [[configDataDic valueForKey:@"QBLOGINCLASS"] valueForKey:@"propertyKeys"];
        
        if([NSString isNotEmptyAndValid:className]){
            
            Class viewClass = NSClassFromString(className);
            UIViewController *controller = nil;
            
            if([NSString isNotEmptyAndValid:initMethodName]){
                
                SEL initMethod = NSSelectorFromString(initMethodName);
                
                controller = [HelpTools reflectionObject:[viewClass alloc] performSelector:initMethod withParames:initPropertyValueArray];
            }
            else {
                
                controller = [viewClass new];
            }
            
            if(propertyKeysDic && propertyKeysDic.count){
                
                for(NSString *key in propertyKeysDic.allKeys){
                    
                    [controller setValue:[propertyKeysDic objectForKey:key] forKey:key];
                }
            }
            
            return controller;
        }
    }
    
    return nil;
}

// 对象的反射操作
+ (id)reflectionObject:(NSObject *)object performSelector:(SEL)selector withParames:(NSArray *)parames{
    NSMethodSignature * signature = [object methodSignatureForSelector:selector];
    
    if(signature){
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:object];
        [invocation setSelector:selector];
        
        if(parames && parames.count){
            for(int i = 0; i < parames.count; i++){
                id obj = [parames objectAtIndex:i];
                [invocation setArgument:&obj atIndex:i+2];
            }
        }
        
        [invocation retainArguments];
        [invocation invoke];
        
        if(signature.methodReturnLength){
            __unsafe_unretained id returnValue;
            [invocation getReturnValue:&returnValue];
            
            return returnValue;
        }
        else {
            return nil;
        }
    }
    
    return nil;
}

+ (BOOL)isCoveringInstallation{
    
    BOOL resultValue = NO;
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"666_appLastVersion"];
    // 是否比本地版号低
    if([HelpTools versionCompareWithServerVersion:lastVersion] == 2){
        
        resultValue = YES;
    }
    
    return resultValue;
}

+ (NSString *)lastVersion{
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"666_appLastVersion"];
}

+ (NSDictionary *)getURLParams:(NSString *)urlString {
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSRange range1  = [urlString rangeOfString:@"?"];
    NSRange range2  = [urlString rangeOfString:@"#"];
    NSRange range;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    }else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    }else{
        range = NSMakeRange(NSNotFound, 1);
    }
    
    if (range.location != NSNotFound) {
        NSString * paramString = [urlString substringFromIndex:range.location+1];
        NSArray * paramCouples = [paramString componentsSeparatedByString:@"&"];
        for (int i = 0; i < [paramCouples count]; i++) {
            NSArray * param = [[paramCouples objectAtIndex:i] componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                [dic setObject:[[param objectAtIndex:1] stringByRemovingPercentEncoding] forKey:[[param objectAtIndex:0] stringByRemovingPercentEncoding]];
            }
        }
        return dic;
    }
    return nil;
}

#pragma mark -
+ (UIViewController *)superViewController:(UIView *)view{
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

+ (UIViewController *)rootViewController{
    //return [(AppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

#pragma mark - BackgroundImage related
+ (BOOL)saveBackgroundImage:(UIImage *)image isDetail:(BOOL)iDetail{
    
    BOOL resultValue = NO;
    
    NSString *bgImagePathStr = [PathTools getBgImagePathIsDetail:iDetail];
    if(image && bgImagePathStr && ![bgImagePathStr isEqualToString:@""]){
        resultValue = [UIImagePNGRepresentation(image) writeToFile:bgImagePathStr options:NSAtomicWrite error:nil];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOMEBACKGROUONDIMAGE object:nil userInfo:@{@"isDetail":@(iDetail)}];
    }
    
    if(YES){
        [self sharedAppSingleton].isRefreshBackgroundImage = YES;
        [self createBlurImage_async:nil];
    }
    
    return resultValue;
}

+ (UIImage *)getBackgroundImageWith20PercentMaskIsDetail:(BOOL)isDetail isRefresh:(BOOL)isRefresh{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[self getBackgroundImageIsDetail:isDetail isRefresh:isRefresh]];
    
    UIView *maskView = [[UIView alloc] initWithFrame:backgroundImageView.bounds];
    maskView.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.2);
    [backgroundImageView addSubview:maskView];
    maskView = nil;
    
    return [self convertViewToImage:backgroundImageView];
}

+ (UIImage *)getBackgroundImageIsDetail:(BOOL)isDetail isRefresh:(BOOL)isRefresh{
    UIImage *bgImage = nil;
    
    NSString *bgImagePathStr = [PathTools getBgImagePathIsDetail:isDetail];
    if(isRefresh && bgImagePathStr && ![bgImagePathStr isEqualToString:@""]){
        NSData *adImageData = [NSData dataWithContentsOfFile:bgImagePathStr];
        bgImage = [UIImage imageWithData:adImageData];
    }
    
    if(!bgImage){
        bgImage = IMAGE_ANY_NAMED(@"home_defaultBackImage", @"png");
    }
    
    return [self fixedBackgroundImage:bgImage];
}

+ (UIImage *)getBackgroundImageWithBlurAndMask:(void (^)(UIImage *image))handle{
    
    if(![self sharedAppSingleton].isRefreshBackgroundImage &&
       [self sharedAppSingleton].backgroundImage){
        
        return [self sharedAppSingleton].backgroundImage;
    }
    
    [self createBlurImage_async:^(UIImage *image) {
        handle(image);
    }];
    
    return [self fixedBackgroundImage:IMAGE_ANY_NAMED(@"home_defaultBackImage", @"png")];
}

+ (void)createBlurImage_async:(void (^)(UIImage *image))handle{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurryImage = [self blurryImage:[self getBackgroundImageIsDetail:NO isRefresh:YES] withBlurLevel:4.5f];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:blurryImage];
        CGRect rect = imageView.frame;
        rect.origin.y -= 5.f;
        rect.origin.x -= 5.f;
        rect.size.width += 10.f;
        rect.size.height += 10.f;
        imageView.frame = rect;
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [backgroundImageView addSubview:imageView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:backgroundImageView.bounds];
        maskView.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.7);
        [backgroundImageView addSubview:maskView];
        maskView = nil;
        imageView = nil;
        
        UIImage *backgroundImage = [self convertViewToImage:backgroundImageView];
        [self sharedAppSingleton].backgroundImage = backgroundImage;
        [self sharedAppSingleton].isRefreshBackgroundImage = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handle){
                handle(backgroundImage);
            }
        });
        
    });
}

+ (void)createNormalBlurImage_async:(UIImage *)image handle:(void (^)(UIImage *image))handle{
    
    if(!image)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurryImage = [self blurryImage:image withBlurLevel:4.5f];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:blurryImage];
        CGRect rect = imageView.frame;
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
        
        rect.origin.y = -5.f;
        rect.origin.x = -5.f;
        rect.size.width += 10.f;
        rect.size.height += 10.f;
        imageView.frame = rect;
        [backgroundImageView addSubview:imageView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:backgroundImageView.bounds];
        maskView.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.1);
        [backgroundImageView addSubview:maskView];
        maskView = nil;
        imageView = nil;
        
        UIImage *backgroundImage = [self convertViewToImage:backgroundImageView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handle){
                handle(backgroundImage);
            }
        });
        
    });
}

+ (UIImage *)fixedBackgroundImage:(UIImage *)image{
    CarouselImageView *backgroundImageView = [[CarouselImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [backgroundImageView setImageWithObject:image withPlaceholderImage:nil interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    UIImage *viewToImage = [self convertViewToImage:backgroundImageView];
    backgroundImageView = nil;
    
    return viewToImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)level{
    
    //return [image blurImageWithBlurLevel:level];
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(level), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil]; // save it to self.context
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    
    UIImage *resultImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return resultImage;
}

+ (UIImage *)QRCodeImageWithContent:(NSString *)content{
    
    if(![NSString isNotEmptyAndValid:content])   return nil;
    
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setDefaults];
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrCodeFilter setValue:contentData forKeyPath:@"inputMessage"];
    
    CIImage *qrCodeImage = [qrCodeFilter outputImage];
    
    return [UIImage imageWithCIImage:qrCodeImage];
}

+ (UIImage *)QRCodeImageWithContent:(NSString *)content withSizeWidth:(CGFloat)targetSizeWidth{
    
    if(![NSString isNotEmptyAndValid:content] || targetSizeWidth <= 0)   return nil;
    
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setDefaults];
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrCodeFilter setValue:contentData forKeyPath:@"inputMessage"];
    
    CIImage *qrCodeImage = [qrCodeFilter outputImage];
    
    return [HelpTools correctImageQualityWithCIImage:qrCodeImage withSizeWidth:targetSizeWidth];
}

+ (UIImage *)correctImageQualityWithCIImage:(CIImage *)image withSizeWidth:(CGFloat)targetSizeWidth{
    
    CGRect imgaeExtent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(targetSizeWidth / CGRectGetWidth(imgaeExtent), targetSizeWidth / CGRectGetHeight(imgaeExtent));
    
    size_t width = CGRectGetWidth(imgaeExtent) * scale;
    size_t height = CGRectGetHeight(imgaeExtent) * scale;
    
    CGColorSpaceRef csRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, csRef, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *contex = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [contex createCGImage:image fromRect:imgaeExtent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, imgaeExtent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - User
+ (BOOL)saveUserMobilePhoneNumber:(NSString *)phoneNum{
    if([NSObject isNotEmptyAndValid:phoneNum]){
        [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:kUserMobilePhoneNum];
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)getUserPayCoins{
//    id cacheData = [CacheHelpTools getCommonCacheFile:Cache_LoginEntity];
//    
//    if(cacheData && ((LoginEntity *)cacheData).isLogin){
//        NSString *payCoins = ((LoginEntity *)cacheData).data.user.pay_points;
//        if([NSObject isNotEmptyAndValid:payCoins]){
//            return payCoins;
//        }
//    }
    
    return nil;
}

+ (NSString *)getUserMobilePhomeNumber{
//    id cacheData = [CacheHelpTools getCommonCacheFile:Cache_LoginEntity];
//    
//    if(cacheData && ((LoginEntity *)cacheData).isLogin){
//        NSString *phoneNum = ((LoginEntity *)cacheData).data.user.mobile;
//        if([NSObject isNotEmptyAndValid:phoneNum]){
//            return phoneNum;
//        }
//    }
    
    return nil;
}

+ (NSDictionary *)getUserSessionObject{
//    id cacheData = [CacheHelpTools getCommonCacheFile:Cache_LoginEntity];
//    
//    if(cacheData && ((LoginEntity *)cacheData).isLogin){
//        NSDictionary *sessionDic = [((LoginEntity *)cacheData).data.session toDictionary];
//        
//        if(![sessionDic isEmpty]){
//            return nil;
//        }
//        
//        return sessionDic;
//    }
    
    return nil;
}

+ (void)prereadUserDataHandle:(void(^)(void))handle{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AGUserData *userData = [CacheHelpTools getCommonCacheFile:Cache_UserInfo];
        [HelpTools sharedAppSingleton].userData = userData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(handle){
                handle();
            }
        });
    });
}

+ (void)setUserDataNull:(void(^)(BOOL isSuccess))result{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [self sharedAppSingleton].userData = nil;
    
    [CacheHelpTools saveCommonCacheFile:Cache_LoginEntity withFile:nil result:^(BOOL isSuccess) {
        if(result){
            result(isSuccess);
        }
    }];
}

+ (void)saveUserData:(id)userData{
    
    [HelpTools sharedAppSingleton].userData = userData;
    [CacheHelpTools saveCommonCacheFile:Cache_UserInfo withFile:userData result:nil];
}

+ (void)saveUserDataCleanToken{
    
    SEL selector = NSSelectorFromString(@"setToken:");
    id userData = [HelpTools sharedAppSingleton].userData;
    if(userData &&
       [userData respondsToSelector:selector]){
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [userData performSelector:selector withObject:@""];
#pragma clang diagnostic pop
    }
    
    [HelpTools sharedAppSingleton].userData = userData;
    [CacheHelpTools saveCommonCacheFile:Cache_UserInfo withFile:userData result:nil];
}

+ (void)cleanUserDataCache {
    
    [HelpTools sharedAppSingleton].userData = nil;
    [CacheHelpTools removeCommonCacheFile:Cache_UserInfo];
}

+ (id)userDataForToken{
    
    id userData = [self userData];
    if(userData) {
        
        return ((AGUserData *)userData).accessToken.accessToken;
    }
    else {
        return nil;
    }
    
//    SEL selector = NSSelectorFromString(@"token");
//    id userData = [self userData];
//
//    if(userData &&
//       [userData respondsToSelector:selector]){
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        NSString *token = [userData performSelector:selector];
//#pragma clang diagnostic pop
//
//        return token;
//    }
//
//    return nil;
}

+ (id)userData{
    
    return [HelpTools sharedAppSingleton].userData;
}

+ (BOOL)isLoginWithoutVC{
    
    NSString *token = [self userDataForToken];
    if([NSString isNotEmptyAndValid:token]){
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLogin{
    
    if([self isLoginWithoutVC]){
        
        return YES;
    }
    else {
        /*
        UIViewController *viewcontroller = [self activityViewController];
        
        UIStoryboard *mineStory = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        AVLoginViewController *loginVC = [mineStory instantiateViewControllerWithIdentifier:@"AVLoginViewController"];
        UINavigationController *loginNaviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewcontroller presentViewController:loginNaviVC animated:YES completion:nil];
        });
         */
        
        /*
        UIViewController *viewcontroller = [self activityViewController];

        UIViewController *vc = (UIViewController *)[HelpTools getLoginVCInfoFromConfig];
        
        if(vc){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [viewcontroller presentViewController:vc animated:YES completion:nil];
            });
        }
         */
        [[HelpTools activityViewController] showLoginViewControllerHandle:^(BOOL isLoginSuccsee) {
            
            if(isLoginSuccsee){
                
                //[NotificationCenterHelper postNotifiction:NotificationCenterRefreshData userInfo:nil];
                [NotificationCenterHelper postNotifiction:NotificationCenterLogined userInfo:nil];
            }
        }];
    }
    
    return NO;
}

+ (BOOL)isLoginHandle:(void(^)(BOOL isLoginSuccess))loginHandle{
    
    if([self isLoginWithoutVC]){
        
        return YES;
    }
    else {
        
        [[HelpTools activityViewController] showLoginViewControllerHandle:^(BOOL isLoginSuccsee) {
            
            if(loginHandle){
                
                loginHandle(isLoginSuccsee);
            }
        }];
    }
    
    return NO;
}

+ (void)showHttpError:(id)responseObject{
    
    NSString *errorMessage;
    
    if(responseObject){
        
        if([responseObject isKindOfClass:[HttpErrorEntity class]]){
            
            HttpErrorEntity *errorData = (HttpErrorEntity *)responseObject;
            errorMessage = [NSString stringSafeChecking:errorData.errMsg];
            if(!errorMessage.length) {
                errorMessage = [NSString stringSafeChecking:errorData.msg];
            }
            errorMessage = errorMessage.length ? errorMessage : @"网络连接错误";
        }
    }
    
    [HelpTools showHUDOnlyWithText:errorMessage toView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHttpError:(id)responseObject complete:(void(^)(BOOL is401))handle{
    
    NSString *alertMessage = @"网络连接错误";
    
    if(responseObject && [responseObject isKindOfClass:[HttpErrorEntity class]]){
        
        HttpErrorEntity *errorData = (HttpErrorEntity *)responseObject;
        
        alertMessage = [NSString stringSafeChecking:errorData.errMsg];
        if(!alertMessage.length) {
            
            alertMessage = [NSString stringSafeChecking:errorData.msg];
        }
        alertMessage = alertMessage.length ? alertMessage : @"网络连接错误";
        
        NSString *code = [NSString stringSafeChecking:errorData.errCode];
        if(!code.length) {
            code = [NSString stringSafeChecking:errorData.code];
        }
        if([code isEqualToString:@"401"]){
            
            // 重新登录
            [HelpTools cleanUserDataCache];
            [NotificationCenterHelper postNotifiction:NotificationCenterRelogin userInfo:nil];
            
            if(handle)
                handle(YES);
            
            return;
        }
        
        [HelpTools showHUDOnlyWithText:alertMessage toView:[UIApplication sharedApplication].keyWindow];
    }
    
    /*
    AVAlertPopView *alertView = [[AVAlertPopView alloc] initWithTitle:nil info:alertMessage confirmButton:@"确定" cancelButton:nil closeButton:NO];
    [alertView show];
     */
    [HelpTools showHUDOnlyWithText:alertMessage toView:[UIApplication sharedApplication].keyWindow];
    
    if(handle)
        handle(NO);
}

//+ (UIViewController *)activityViewController{
//
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//
//    while (topVC.presentedViewController) {
//
//        topVC = topVC.presentedViewController;
//    }
//
//    UINavigationController *rootNaviVC = nil;
//
//    if([topVC isKindOfClass:[UINavigationController class]]){
//
//        rootNaviVC = (UINavigationController *)topVC;
//    }
//    else if([topVC isKindOfClass:[UIViewController class]]){
//
//        rootNaviVC = [(UIViewController *)topVC navigationController];
//    }
//
//    UIViewController *viewController = [rootNaviVC.viewControllers lastObject];
//
//    return viewController;
//}


//+ (UIViewController * )activityViewController{
//
//    UIViewController *resultVC = [self recursiveTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
//
//    while (resultVC.presentedViewController) {
//
//        resultVC = [self recursiveTopViewController:resultVC.presentedViewController];
//    }
//
//    return resultVC;
//}

+ (UIViewController *)getRootViewController {
    
    if(@available(iOS 13.0, *)) {
        
        UIWindow *keyyWindow;
        
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]) {
                UIWindow *window = [(id<UIWindowSceneDelegate>)scene.delegate window];
                
                //NSLog(@"getCurrentWindow0:%@", window);
                keyyWindow = window;
            }
            
            //NSLog(@"getCurrentWindow1:%@", keyyWindow.gestureRecognizers);
        }
        
        if(!keyyWindow) {
            
            keyyWindow = [UIApplication sharedApplication].windows.lastObject;
        }
        
        return keyyWindow.rootViewController;
    }
    else {
        
        return [UIApplication sharedApplication].windows.lastObject.rootViewController;
    }
}

+ (UIWindow *)getKeyWindow {
    
    if(@available(iOS 13.0, *)) {
        
        UIWindow *keyWindow;
        
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]) {
                UIWindow *window = [(id<UIWindowSceneDelegate>)scene.delegate window];
                
                //NSLog(@"getCurrentWindow0:%@", window);
                keyWindow = window;
            }
            
            //NSLog(@"getCurrentWindow1:%@", keyyWindow.gestureRecognizers);
        }
        
        if(!keyWindow) {
            
            keyWindow = [UIApplication sharedApplication].windows.lastObject;
        }
        
        return keyWindow;
    }
    else {
        
        return [UIApplication sharedApplication].windows.lastObject;
    }
}

+ (UIViewController * )activityViewController{
    
    UIViewController *resultVC = [self recursiveTopViewController:[self getRootViewController]];
    
    while (resultVC.presentedViewController) {
        
        resultVC = [self recursiveTopViewController:resultVC.presentedViewController];
    }
    
    return resultVC;
}

+ (UIViewController * )recursiveTopViewController:(UIViewController *)vc{
    
    if([vc.childViewControllers count] &&
       [vc.childViewControllers.firstObject isKindOfClass:[UITabBarController class]]){
        
        return [self recursiveTopViewController:[(UITabBarController *)vc.childViewControllers.firstObject selectedViewController]];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self recursiveTopViewController:[(UINavigationController *)vc topViewController]];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self recursiveTopViewController:[(UITabBarController *)vc selectedViewController]];
    }
    else {
        
        return vc;
    }
}

+ (void)saveTabMenuEntity:(SetingEntity *)settingEntity{
    
//    NSDictionary *dic = [settingEntity toDictionary];
//    
//    [CacheHelpTools saveCommonCacheFile:Cache_MenuEntity withFile:dic result:^(BOOL isSuccess) {
//        
//    }];
}

+ (SetingEntity *)getTabMenuEntity{
    
//    SetingEntity *settingEntity = [[SetingEntity alloc] initWithDictionary:[CacheHelpTools getCommonCacheFile:Cache_MenuEntity] error:nil];
//    if(settingEntity && settingEntity.data.count){
//        return settingEntity;
//    }
//    else {
//       
//        NSString *jsonString = @"{\"code\":200,\"msg\":\"\u67e5\u8be2\u680f\u76ee\u6210\u529f\",\"data\":[{\"id\":\"1\",\"ownerId\":\"1\",\"pid\":\"0\",\"name\":\"\u9884\u8ba2\",\"ename\":\"BOOKING\",\"byorder\":\"1\",\"status\":\"1\",\"addtime\":\"2015-07-09 18:26:41\"},{\"id\":\"2\",\"ownerId\":\"1\",\"pid\":\"0\",\"name\":\"\u8d44\u8baf\",\"ename\":\"NEWS\",\"byorder\":\"2\",\"status\":\"1\",\"addtime\":\"2015-07-09 18:32:02\"},{\"id\":\"3\",\"ownerId\":\"1\",\"pid\":\"0\",\"name\":\"\u5962\u54c1\",\"ename\":\"LUXURY\",\"byorder\":\"3\",\"status\":\"1\",\"addtime\":\"2015-07-09 18:29:25\"}]}";
//        
//        NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
//        settingEntity = [[SetingEntity alloc] initWithDictionary:dic error:nil];
//        
//        return settingEntity;
//    }
    return nil;
}

// 只有整蛊与惊悚频道显示骷髅
+ (BOOL)checkShouldSkullIcon:(NSInteger)avid{
    
    if(avid == 1 ||
       avid == 2){
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)checkDownLoadURL:(NSString *)urlString{
    
    if(![NSString isNotEmptyAndValid:urlString]){
    
        return @"";
    }
    
    if([urlString hasPrefix:@"http"]){
        
        return urlString;
    }
    
    return [DOWNLOAD_URL stringByAppendingString:urlString];
}

#pragma mark - UILocalNotification
- (void)addLocalNotification{
    if([[UIApplication sharedApplication].currentUserNotificationSettings types] == UIUserNotificationTypeNone){
        if(isIOS8_LATER){
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
        }
        else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert];
        }
    }
}

- (void)removeALLLocalNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Date related
+ (NSDateFormatter *)sharedDateFormatter{
    
    static NSDateFormatter *sharedDateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDateFormatter = [NSDateFormatter new];
        [sharedDateFormatter setLocale:[NSLocale currentLocale]];
    });
    
    [sharedDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return sharedDateFormatter;
}

+ (NSDate *)getDateFromGMTString:(NSString *)string{
    //eg.  Thu, 28 Mar 2013 06:42:46 GMT
    NSDate *date = nil;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormatter setLocale:locale];
    
    date = [dateFormatter dateFromString:string];
    dateFormatter = nil;
    
    return date;
}

+ (NSString *)getFormatterDateFromMsecTimestamp:(NSString *)timestampString{
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[timestampString longLongValue]];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
   
    dateFormatter = nil;
    
    return formatterString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle1:(NSString *)timestampString{
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[timestampString longLongValue]];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
    
    dateFormatter = nil;
    
    return formatterString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle2:(NSString *)timestampString{
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[timestampString longLongValue]];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
    
    dateFormatter = nil;
    
    return formatterString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle3:(NSString *)timestampString{
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:([timestampString longLongValue] / 1000)];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
    
    dateFormatter = nil;
    
    return formatterString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle4:(NSString *)timestampString{
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[timestampString longLongValue]];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
    
    dateFormatter = nil;
    
    return formatterString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle5:(NSString *)timestampString{
    
    NSTimeInterval objectTimes = [timestampString longLongValue] / 1000;
    NSTimeInterval oneDayBaseValue = 24 * 60 * 60;
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:objectTimes];
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *formatterString = [dateFormatter stringFromDate:timestampDate];
    
    dateFormatter = nil;
    DLOG(@"getFormatterDateFromMsecTimestampStyle5");
    objectTimes -= [[NSDate date] timeIntervalSince1970] / 1000;
    
    if(objectTimes > oneDayBaseValue * 2){
        
        return formatterString;
    }
    else if(objectTimes >= oneDayBaseValue &&
            objectTimes < oneDayBaseValue * 2){
        
        formatterString = [formatterString componentsSeparatedByString:@" "].lastObject;
        formatterString = [NSString stringWithFormat:@"昨天 %@", formatterString];
        
        return formatterString;
    }
    else if(objectTimes > 0){
        
        formatterString = [formatterString componentsSeparatedByString:@" "].lastObject;
        formatterString = [NSString stringWithFormat:@"今天 %@", formatterString];
        
        return formatterString;
    }
    
    return formatterString;
}

+ (NSString *)getDateStateFromStartMsecTimestamp:(NSString *)startTimestampString end:(NSString *)endTimestampString{
    
    NSString *resulrString = @"";
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval nowDateInterval = [nowDate timeIntervalSince1970];
    
    if(nowDateInterval < [startTimestampString doubleValue]){
        // 尚未开始
        resulrString = [NSString stringWithFormat:@"%@开始", [HelpTools getFormatterDateFromMsecTimestampStyle2:[NSString stringWithFormat:@"%@", @(nowDateInterval)] end:startTimestampString]];
    }
    else if(nowDateInterval >= [startTimestampString doubleValue] &&
            nowDateInterval < [endTimestampString doubleValue]){
        // 进行中
        resulrString = [NSString stringWithFormat:@"进行中 %@结束", [HelpTools getFormatterDateFromMsecTimestampStyle2:[NSString stringWithFormat:@"%@", @(nowDateInterval)] end:endTimestampString]];
    }
    else {
        // 已结束
        resulrString = @"已结束";
    }
    
    return resulrString;
}

+ (NSString *)getFormatterDateFromMsecTimestampStyle2:(NSString *)startTimestampString end:(NSString *)endTimestampString{
    
    NSString *resultString = @"";
    
    NSTimeInterval oneDayBaseValue = 24 * 60 * 60;
    
    NSTimeInterval dValue = fabs([endTimestampString doubleValue] - [startTimestampString doubleValue]);
    
    if(dValue >= oneDayBaseValue * 3){
        
        NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
        dateFormatter.dateFormat = @"MM月dd日";
        
        NSDate *endTimestampDate = [NSDate dateWithTimeIntervalSince1970:[endTimestampString longLongValue]];
        
        resultString = [dateFormatter stringFromDate:endTimestampDate];
    }
    else if(dValue >= oneDayBaseValue * 2 &&
            dValue < oneDayBaseValue * 3){
        
        resultString = @"后天";
    }
    else {
        
        NSInteger dayNum = 1.0 * dValue / oneDayBaseValue;
        if(dayNum == 0){
            
            resultString = @"今天";
        }
        else if(dayNum == 1){
         
            resultString = @"明天";
        }
    }
    
    return resultString;
}

+ (NSString *)getFormatterDateFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    NSString *formatterString = [dateFormatter stringFromDate:date];
    
    dateFormatter = nil;
    
    return formatterString;
}

+ (IntervalDateState)checkDateStateFromStartMsecTimestamp:(NSString *)startTimestampString end:(NSString *)endTimestampString{

    IntervalDateState dateState;
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval nowDateInterval = [nowDate timeIntervalSince1970];
    
    if(nowDateInterval < [startTimestampString doubleValue]){
        // 尚未开始
        dateState = IntervalDateState_Unstart;
    }
    else if(nowDateInterval >= [startTimestampString doubleValue] &&
            nowDateInterval < [endTimestampString doubleValue]){
        // 进行中
        dateState = IntervalDateState_InProgress;
    }
    else {
        // 已结束
        dateState = IntervalDateState_End;
    }
    
    return dateState;
}

+ (NSTimeInterval)getOffsetForLocalAndServerDate:(NSDate *)serverData{
    //返回的是服务器与本地时间的秒数
    NSDate *nowDate = [NSDate date];
    NSTimeInterval date = [serverData timeIntervalSinceDate:nowDate];
    DLOG(@"OffsetForLocal:%@,,,%@,%f", serverData, nowDate, date );
    return date ;
}

+ (NSTimeInterval)getTimeIntervalForDateString:(NSString *)dateString{
    
    if(![NSString isNotEmptyAndValid:dateString])    return 0;
    
    NSDateFormatter *dateFormatter = [HelpTools sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return  [date timeIntervalSince1970];
}

+ (NSInteger)versionCompareWithServerVersion:(NSString *)serverVersion{
    
    if(![NSString isNotEmptyAndValid:serverVersion]) return -1;
    
    NSInteger resultValue = -1;
    NSString *localVersion = APP_VERSION;
    
    NSArray *localVersionArray = [localVersion componentsSeparatedByString:@"."];
    NSArray *serverVersionArray = [serverVersion componentsSeparatedByString:@"."];
    
    NSInteger count = (localVersionArray.count > serverVersionArray.count) ? localVersionArray.count : serverVersionArray.count;
    for(int i = 0; i < count; i++){
        
        NSInteger local = [[localVersionArray objectAtIndexForSafe:i] integerValue];
        NSInteger server = [[serverVersionArray objectAtIndexForSafe:i] integerValue];
        
        if(local < server){
            
            resultValue = 1;
            break;
        }
        else if(local > server){
            
            resultValue = 2;
            break;
        }
        else {
            
            resultValue = 0;
        }
    }
    
    return resultValue;
}

#pragma mark - DiskSpace
// 单位:MB
+ (double)totalDiskSpace{
    
    return 0.f;
}

// 单位:MB
+ (double)freeDiskSpace{
    
    struct statfs buf;
    
    long long freespace = -1;
    
    if(statfs("/var", &buf) >= 0){
        
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    return freespace / 1024.f / 1024.f;
}

+ (unsigned long long)getFileSizeWithPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:filePath]) {
        
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        return fileSize;
    }
    return 0.f;
}

+ (unsigned long long)getFolderSizeWithFolderPath:(NSString *)folderPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:folderPath]) {
        
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:folderPath];
        unsigned long long totalSize = 0.f;
        NSString *file;
        
        while (file = [enumerator nextObject]) {
            
            totalSize += [self getFileSizeWithPath:[NSString stringWithFormat:@"%@/%@", folderPath, file]];
        }
        
        return totalSize / 1024.f / 1024.f;
    }
    
    return 0.f;
}

#pragma mark - UIKit
//View to image
+ (UIImage*)convertViewToImage:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGSize)sizeForString:(NSString *)string withFont:(UIFont *)font viewWidth:(CGFloat)viewWidth{
    
    string = [NSObject stringSafeChecking:string];
    
    CGSize stringSize = CGSizeZero;
    if(isIOS7_LATER){
        stringSize = [string boundingRectWithSize:CGSizeMake(viewWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        stringSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(viewWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    
    return stringSize;
}

+ (CGSize)sizeWithString:(NSString *)string withShowSize:(CGSize)showSize withFont:(UIFont *)font{
    
    //固定宽获取高度size：CGSizeMake(100, MAXFLOAT)
    //固定高获取宽度size：CGSizeMake(MAXFLOAT,100)
    CGSize stringSize = [string boundingRectWithSize:showSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return stringSize;
}

+ (CGSize)sizeWithAttributeString:(NSAttributedString *)string withShowSize:(CGSize)showSize{
    
    if(!string || !string.length) return CGSizeZero;
    //固定宽获取高度size：CGSizeMake(100, MAXFLOAT)
    //固定高获取宽度size：CGSizeMake(MAXFLOAT,100)
    NSRange effectiveRange;
    NSDictionary *attriDic = [string attributesAtIndex:0 longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, string.length)];
    CGSize stringSize = [[string string] boundingRectWithSize:showSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attriDic ?: @{} context:nil].size;
    
    return stringSize;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if(![NSString isNotEmptyAndValid:jsonString]){
        
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error){
        NSLog(@"json解析失败：%@", error);
        
        return nil;
    }
    
    return dic;
}

//+ (NSString *)jsonStringWithJsonData:(id)theData{
//    
//    if(!theData)    return @"";
//
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONWritingPrettyPrinted error:&error];
//    if()
//}

#pragma mark - Create solid color image
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect)rect radius:(CGFloat)radius{
    
    if(rect.size.width <= 0 || rect.size.height <= 0)   return nil;
    
    UIImage *originalImage = [self createImageWithColor:color withRect:rect];
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [originalImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect)rect{
    if(rect.size.width <= 0 ||
       rect.size.height <= 0)
        return nil;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIView *)createShadeViewWithSize:(CGSize)size withColor:(NSArray *)colors{
    
    if(!colors || !colors.count){
        
        return nil;
    }
    
    CGFloat location = 0.f;
    CGFloat perLocation = 1.0/colors.count;
    NSMutableArray *colorsArray = [NSMutableArray arrayWithCapacity:colors.count];
    NSMutableArray *colorLocations = [NSMutableArray arrayWithCapacity:colors.count];
    for(UIColor *color in colors){
        [colorsArray addObject:((id)[color CGColor])];
        
        location += perLocation;
        [colorLocations addObject:@(location)];
    }
    
    UIView *shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    shadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = shadeView.bounds;
    gradientLayer.borderWidth = 0;
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    gradientLayer.colors = [NSArray arrayWithArray:colorsArray];
    //gradientLayer.locations = [NSArray arrayWithArray:colorLocations];
    gradientLayer.opacity = 1.f;
    
    [shadeView.layer insertSublayer:gradientLayer atIndex:0];
    
    return shadeView;
}

+ (UIView *)createHorizontalShadeViewWithSize:(CGSize)size withColor:(NSArray *)colors{
    
    if(!colors || !colors.count){
        
        return nil;
    }
    
    CGFloat location = 0.f;
    CGFloat perLocation = 1.0/colors.count;
    NSMutableArray *colorsArray = [NSMutableArray arrayWithCapacity:colors.count];
    NSMutableArray *colorLocations = [NSMutableArray arrayWithCapacity:colors.count];
    for(UIColor *color in colors){
        [colorsArray addObject:((id)[color CGColor])];
        
        location += perLocation;
        [colorLocations addObject:@(location)];
    }
    
    UIView *shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = shadeView.bounds;
    gradientLayer.borderWidth = 0;
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    gradientLayer.colors = [NSArray arrayWithArray:colorsArray];
    //gradientLayer.locations = [NSArray arrayWithArray:colorLocations];
    gradientLayer.opacity = 1.f;
    
    [shadeView.layer insertSublayer:gradientLayer atIndex:0];
    
    return shadeView;
}

+ (UIImage *)createGradientImageWithSize:(CGSize)size colors:(NSArray *)colors gradientType:(int)gradientType{
    
    NSMutableArray *cgs = [NSMutableArray arrayWithCapacity:colors.count];
    for(UIColor *color in colors){
        
        [cgs addObject:(id)color.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgs, NULL);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if(gradientType == 0){
        
        endPoint = CGPointMake(0.f, size.height);
    }
    else if(gradientType == 1){
        
        endPoint = CGPointMake(size.width, 0.f);
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return resultImage;
}

+ (UIImage *)imageBlankWithOneWeightsBorderForSize:(CGSize)size color:(UIColor *)color corner:(CGFloat)corner{
    
    UIView *view = [[UIView alloc] initWithFrame:({
        CGRect rect = {CGPointZero, size};
        rect;
    })];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = corner;
    view.layer.borderWidth = 1.f;
    
    return [HelpTools convertViewToImage:view];
}

+ (UIImage *)imageCutWithOriginalImage:(UIImage *)originImage withRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return resultImage;
}

+ (void)addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii forView:(UIView *)view{
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.masksToBounds = YES;
    view.layer.mask = shape;
}

+ (void)removeRoundedCornersForView:(UIView *)view {
    
    view.layer.mask = nil;
}

#pragma mark - HUD
+ (void)showLoadingForView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [LoadingView startLoadingForView:view withProgress:-1];
    });
}

+ (void)hideLoadingForView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [LoadingView stopLoadingForView:view];
    });
}

+ (void)hideLoadingView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LoadingView stopLoadingForView:nil];
    });
}

+ (void)showLoadingForView:(UIView *)view withProgress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LoadingView startLoadingForView:view withProgress:progress];
    });
}

+ (void)hideLoadingForcible{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LoadingView stopLoadingForcible];
    });
}

+ (void)hideLoadingForcibleWithVIew:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LoadingView stopLoadingForcibleWithView:view];
    });
}

//+ (void)hideLoadingViewProcess{
//    [LoadingView stopLoadingForView];
//}

+ (void)setLoadingProgress:(CGFloat)progress{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[LoadingView sharedLoadingView].progressView setProgress:progress];
    });
}

+ (void)showHUDWithText:(NSString *)text toView:(UIView *)view{
    
    MBProgressHUDFIX *hud = [MBProgressHUDFIX showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.defaultMotionEffectsEnabled = NO;
    hud.userInteractionEnabled = NO;
    
    if([NSString isNotEmptyAndValid:text]){
       hud.label.text = text;
    }
}

+ (void)hideHUDforView:(UIView *)view{
    [MBProgressHUDFIX hideHUDForView:view animated:YES];
}

+ (void)hideAllHUDforView:(UIView *)view{
    
    //[MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (void)showHUDOnlyWithText:(NSString *)text toView:(UIView *)view{
    if(!view) return;
    
    MBProgressHUDFIX *hud = [MBProgressHUDFIX showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor whiteColor];//UIColorFromRGB_ALPHA(0x000000, 0.6);
    hud.userInteractionEnabled = NO;
    hud.defaultMotionEffectsEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.2f];
    hud.centerY -= kPadding * 2;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = FONT_SYSTEM(16.f);
    hud.detailsLabel.textColor = [UIColor blackColor333333];
    /*
    hud.label.text = text;
    hud.label.font = FONT_SYSTEM(16.f);
    hud.label.textColor = [UIColor whiteColor];
     */
}

+ (void)showHUDOnlyWithText:(NSString *)text andDetailText:(NSString *)detailText toView:(UIView *)view{
    MBProgressHUDFIX *hud = [MBProgressHUDFIX showHUDAddedTo:view animated:YES];
    hud.detailsLabel.font = hud.label.font = FONT_SYSTEM(14.f);
    hud.defaultMotionEffectsEnabled = NO;
    hud.detailsLabel.text = detailText;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.5f];
    hud.label.text = text;
}

//+ (void)showDimmerTitle:(NSString *)title btnTitles:(NSArray *)btnTitles selectIndex:(SelectBlock)selectBlock{
////    GiveupOrderDimmerView *giveUp = [[GiveupOrderDimmerView alloc] initWithTitle:title btnTitles:btnTitles];
////    giveUp.touchDismiss = NO;
////    giveUp.selectBlock = selectBlock;
////    [giveUp showFromView:nil];
//}

#pragma mark - Account is valid
// 2017
+ (BOOL)isValidateMobileNum:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,145,155,156,176,185,186
     * 电信：133,1349,153,177,180,181,189
     * 虚拟运营商：170（11位中的前四位区分三大商,1700:电信;1705:移动;1709:联通）
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-235-9]|7[06-8]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     */
    NSString * CM = @"^1(34[0-8]|705|(3[5-9]|47|5[0-27-9]|78|8[2-478])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,1709
     */
    NSString * CU = @"^1(709|(3[0-2]|45|5[56]|76|8[56])\\d)\\d{7}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,181,189,1700
     */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349|700)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if([regextestmobile evaluateWithObject:mobileNum]){
        if([regextestcm evaluateWithObject:mobileNum]){
            
        }
        else if([regextestcu evaluateWithObject:mobileNum]){
            
        }
        else if([regextestct evaluateWithObject:mobileNum]){
        
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

// ADD 2019.01
+ (BOOL)isEasyValidateMobileNum:(NSString *)mobileNum{
    
    NSString * MOBILE = @"^[1]([3-9])[0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if([regextestmobile evaluateWithObject:mobileNum]){
       
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isValidateEmail:(NSString *)emailString{
    
    NSString *emailRegex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[a-zA-Z0-9](?:[\\w-]*[\\w])?";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

+ (NSUInteger)convertToInt:(NSString *)strtemp{
    
    NSUInteger strlength = 0;
    char * p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    
    return strlength;
}

+ (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}

+ (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    
    return [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
}

+ (NSInteger)getValueIntegerPart:(CGFloat)priceValue{
    
    return floorf(priceValue);
}

+ (NSInteger)getValueDecimalPart:(CGFloat)priceValue withLength:(NSInteger)length{
    
    priceValue -= floorf(priceValue);
    
    return floorf(fabs(priceValue) * pow(10, length));
}

+ (BOOL)connectedToNetwork{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    // 获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    // 如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        
        return NO;
    }
    // 根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (BOOL)stringIsPureInt:(NSString *)string{
    
    if(![NSString isNotEmptyAndValid:string])
        return NO;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    int val;
    
    return ([scanner scanInt:&val] && [scanner isAtEnd]);
}

+ (BOOL)stringIsPureFloat:(NSString *)string{
    
    if(![NSString isNotEmptyAndValid:string])
        return NO;
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    float val;
    
    return ([scanner scanFloat:&val] && [scanner isAtEnd]);
}

+ (BOOL)stringIsPureNumber:(NSString *)string{
    
    return ([HelpTools stringIsPureInt:string] || [HelpTools stringIsPureFloat:string]);
}

+ (NSString *)subStringDoubleFlagSeparateWithContentText:(NSString *)contentText separateString:(NSString *)separateString{
    
    if(!contentText || !separateString || !contentText.length || !contentText.length)
        return @"";
    
    NSInteger firstFlagIndex = 1;
    NSInteger secondFlagIndex = 2;
    NSRange startRange = NSMakeRange(0, 0);
    NSRange endRange = NSMakeRange(0, 0);
    NSInteger flagCount = 0;
    
    for (int i = 0; i < contentText.length; ++i) {
        
        NSString *tempString = [contentText substringWithRange:NSMakeRange(i, 1)];
        if([tempString isEqualToString:separateString]){
            
            flagCount += 1;
            if(firstFlagIndex == flagCount){
                
                startRange = NSMakeRange(i, 1);
            }
            else if(secondFlagIndex == flagCount){
                
                endRange = NSMakeRange(i, 1);
            }
        }
    }
    
    if(NSEqualRanges(startRange, NSMakeRange(0, 0)) ||
       NSEqualRanges(endRange, NSMakeRange(0, 0))){
        
        return @"";
    }
    
    NSRange rangeTextRange = NSMakeRange(startRange.location + startRange.length, endRange.location - (startRange.location + startRange.length));
    NSString *rangeText = [contentText substringWithRange:rangeTextRange];
    
    return rangeText;
}

+ (NSString *)getUUIDAndSaveKeyChain{
    
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidStr = CFUUIDCreateString(nil, puuid);
    NSString *uuidResutStr = (NSString *)CFBridgingRelease(CFStringCreateCopy(nil, uuidStr));
    
    CFRelease(puuid);
    CFRelease(uuidStr);
    
    uuidResutStr = uuidResutStr?uuidResutStr:@"";
    
    [self save:kKEYCHAIN_UUID data:uuidResutStr];
    
    return uuidResutStr;
}

+ (NSString *)getUUID{
    
    NSString *uuidSrting = [self loadStringClass:kKEYCHAIN_UUID];
    if(!uuidSrting ||
       !uuidSrting.length){
    
        uuidSrting = [self getUUIDAndSaveKeyChain];
    }
    
    return uuidSrting;
}

+ (NSString *)deviceModel{
    //https://www.theiphonewiki.com/wiki/Models
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";//(A1203)
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";//(A1241/A1324)
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";//(A1303/A1325)
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";//(A1332)
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";//(A1332)
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";//(A1349)
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";//(A1387/A1431)
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";//(A1428)
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";//(A1429/A1442)
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";//(A1456/A1532)
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";//(A1507/A1516/A1526/A1529)
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";//(A1453/A1533)
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";//(A1457/A1518/A1528/A1530)
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";//(A1522/A1524)
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";//(A1549/A1586)
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";//(A1660/A1779/A1780)
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";//(A1778)
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";//(A1661/A1785/A1786)
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";//(A1784)
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";//(A1863/A1906/A1907)
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";//(A1905)
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";//(A1864/A1898/A1899)
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";//(A1897)
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";//(A1865/A1902)
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";//(A1901)
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";//(A1213)
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";//(A1288)
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";//(A1318)
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";//(A1367)
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";//(A1421/A1509)
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod touch 6G";
    if ([platform isEqualToString:@"iPod9,1"])   return @"iPod touch 7G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1";//(A1219/A1337)
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";//(A1395)
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";//(A1396)
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";//(A1397)
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";//(A1395+New Chip)
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";//(A1432)
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";//(A1454)
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";//(A1455)
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";//(A1416)
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";//(A1403)
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";//(A1430)
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";//(A1458)
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";//(A1459)
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";//(A1460)
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";//(A1474)
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";//(A1475)
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";//(A1476)
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";//(A1489)
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";//(A1490)
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";//(A1491)
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4";//(Wi-Fi)
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4";//(Wi-Fi + Cellular)
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";//(Wi-Fi)
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";//(Wi-Fi + Cellular)
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro 9.7";//(Wi-Fi)
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro 9.7";//(Wi-Fi + Cellular)
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad 5th";
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad 5th";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro 12.9 2nd";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro 12.9 2nd";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro 10.5";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro 10.5";
    if ([platform isEqualToString:@"iPad7,5"])   return @"iPad 6th";
    if ([platform isEqualToString:@"iPad7,6"])   return @"iPad 6th";
    if ([platform isEqualToString:@"iPad8,1"])   return @"iPad Pro 11";
    if ([platform isEqualToString:@"iPad8,2"])   return @"iPad Pro 11";
    if ([platform isEqualToString:@"iPad8,3"])   return @"iPad Pro 11";
    if ([platform isEqualToString:@"iPad8,4"])   return @"iPad Pro 11";
    if ([platform isEqualToString:@"iPad8,5"])   return @"iPad Pro 12.9 3rd";
    if ([platform isEqualToString:@"iPad8,6"])   return @"iPad Pro 12.9 3rd";
    if ([platform isEqualToString:@"iPad8,7"])   return @"iPad Pro 12.9 3rd";
    if ([platform isEqualToString:@"iPad8,8"])   return @"iPad Pro 12.9 3rd";
    if ([platform isEqualToString:@"iPad11,3"])   return @"iPad Air 3rd";
    if ([platform isEqualToString:@"iPad11,4"])   return @"iPad Air 3rd";
    if ([platform isEqualToString:@"iPad11,1"])   return @"iPad Mini 5th";
    if ([platform isEqualToString:@"iPad11,2"])   return @"iPad Mini 5th";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    return platform;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadStringClass:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class] fromData:(__bridge NSData *)keyData error:nil];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (BOOL)iPhoneNotchScreen {
    
    if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0) {
        return false;
    }
    
    CGFloat iPhoneNotchDirectionSafeAreaInsets = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left;
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right;
            }
                break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom;
            }
                break;
            default:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
                break;
        }
    }
    
    return iPhoneNotchDirectionSafeAreaInsets > 20;
}

#pragma mark - getLabel
+ (UILabel *)getLabelWithFont:(UIFont *)font withTextColor:(UIColor *)textColor{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = font;
    
    return label;
}

#pragma mark - Price

+ (double)getDecimalPriceValueWithFloatData:(CGFloat)data{
    
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", data]];
    NSDecimalNumberHandler *numerHandler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    DLOG(@"requestGrouponOpenGrouponDataResultHandle 1: %@", decimalNumber);
    return [decimalNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0"] withBehavior:numerHandler].doubleValue;
}

+ (NSDecimalNumber *)getDecimalPriceValueWithFloatData1:(CGFloat)data{
    
    return [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%f", data]];
}

+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithFloatValue:(CGFloat)floadValue{
    
    NSMutableAttributedString *priceAttriText = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSKernAttributeName: @(-4)}];
    [priceAttriText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", floadValue]]];
    
    return priceAttriText;
}

+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithNumberValue:(NSNumber *)numberValue{
    
    NSMutableAttributedString *priceAttriText = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSKernAttributeName: @(-4)}];
    [priceAttriText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", numberValue]]];
    
    return priceAttriText;
}

+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithDCNumberValue:(NSDecimalNumber *)numberValue{
    
    NSMutableAttributedString *priceAttriText = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSKernAttributeName: @(-4)}];
    [priceAttriText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", numberValue]]];
    
    return priceAttriText;
}

+ (NSMutableAttributedString *)priceStringStartAtRMBSymbolFixWithStringValue:(NSString *)stringValue{
    
    NSMutableAttributedString *priceAttriText = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{NSKernAttributeName: @(-4)}];
    [priceAttriText appendAttributedString:[[NSAttributedString alloc] initWithString:stringValue]];
    
    return priceAttriText;
}

#pragma mark - NSNotificationCenter
+ (void)addNotifiction:(NSString *)name observer:(id)observer selector:(SEL)selector{
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:nil];
}

+ (void)postNotifiction:(NSString *)name userInfo:(NSDictionary *)userInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

+ (void)removeNotifiction:(NSString *)name observer:(id)observer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:nil];
}

+ (void)removeAllNotifiction:(id)observer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

////+ (NSString *)jsonForBankCode{
////
////    return @"{
////    \"SRCB\":\"深圳农村商业银行\",
////    "BGB": "广西北部湾银行",
////    "SHRCB": "上海农村商业银行",
////    "BJBANK": "北京银行",
////    "WHCCB": "威海市商业银行",
////    "BOZK": "周口银行",
////    "KORLABANK": "库尔勒市商业银行",
////    "SPABANK": "平安银行",
////    "SDEB": "顺德农商银行",
////    "HURCB": "湖北省农村信用社",
////    "WRCB": "无锡农村商业银行",
////    "BOCY": "朝阳银行",
////    "CZBANK": "浙商银行",
////    "HDBANK": "邯郸银行",
////    "BOC": "中国银行",
////    "BOD": "东莞银行",
////    "CCB": "中国建设银行",
////    "ZYCBANK": "遵义市商业银行",
////    "SXCB": "绍兴银行",
////    "GZRCU": "贵州省农村信用社",
////    "ZJKCCB": "张家口市商业银行",
////    "BOJZ": "锦州银行",
////    "BOP": "平顶山银行",
////    "HKB": "汉口银行",
////    "SPDB": "上海浦东发展银行",
////    "NXRCU": "宁夏黄河农村商业银行",
////    "NYNB": "广东南粤银行",
////    "GRCB": "广州农商银行",
////    "BOSZ": "苏州银行",
////    "HZCB": "杭州银行",
////    "HSBK": "衡水银行",
////    "HBC": "湖北银行",
////    "JXBANK": "嘉兴银行",
////    "HRXJB": "华融湘江银行",
////    "BODD": "丹东银行",
////    "AYCB": "安阳银行",
////    "EGBANK": "恒丰银行",
////    "CDB": "国家开发银行",
////    "TCRCB": "江苏太仓农村商业银行",
////    "NJCB": "南京银行",
////    "ZZBANK": "郑州银行",
////    "DYCB": "德阳商业银行",
////    "YBCCB": "宜宾市商业银行",
////    "SCRCU": "四川省农村信用",
////    "KLB": "昆仑银行",
////    "LSBANK": "莱商银行",
////    "YDRCB": "尧都农商行",
////    "CCQTGB": "重庆三峡银行",
////    "FDB": "富滇银行",
////    "JSRCU": "江苏省农村信用联合社",
////    "JNBANK": "济宁银行",
////    "CMB": "招商银行",
////    "JINCHB": "晋城银行JCBANK",
////    "FXCB": "阜新银行",
////    "WHRCB": "武汉农村商业银行",
////    "HBYCBANK": "湖北银行宜昌分行",
////    "TZCB": "台州银行",
////    "TACCB": "泰安市商业银行",
////    "XCYH": "许昌银行",
////    "CEB": "中国光大银行",
////    "NXBANK": "宁夏银行",
////    "HSBANK": "徽商银行",
////    "JJBANK": "九江银行",
////    "NHQS": "农信银清算中心",
////    "MTBANK": "浙江民泰商业银行",
////    "LANGFB": "廊坊银行",
////    "ASCB": "鞍山银行",
////    "KSRB": "昆山农村商业银行",
////    "YXCCB": "玉溪市商业银行",
////    "DLB": "大连银行",
////    "DRCBCL": "东莞农村商业银行",
////    "GCB": "广州银行",
////    "NBBANK": "宁波银行",
////    "BOYK": "营口银行",
////    "SXRCCU": "陕西信合",
////    "GLBANK": "桂林银行",
////    "BOQH": "青海银行",
////    "CDRCB": "成都农商银行",
////    "QDCCB": "青岛银行",
////    "HKBEA": "东亚银行",
////    "HBHSBANK": "湖北银行黄石分行",
////    "WZCB": "温州银行",
////    "TRCB": "天津农商银行",
////    "QLBANK": "齐鲁银行",
////    "GDRCC": "广东省农村信用社联合社",
////    "ZJTLCB": "浙江泰隆商业银行",
////    "GZB": "赣州银行",
////    "GYCB": "贵阳市商业银行",
////    "CQBANK": "重庆银行",
////    "DAQINGB": "龙江银行",
////    "CGNB": "南充市商业银行",
////    "SCCB": "三门峡银行",
////    "CSRCB": "常熟农村商业银行",
////    "SHBANK": "上海银行",
////    "JLBANK": "吉林银行",
////    "CZRCB": "常州农村信用联社",
////    "BANKWF": "潍坊银行",
////    "ZRCBANK": "张家港农村商业银行",
////    "FJHXBC": "福建海峡银行",
////    "ZJNX": "浙江省农村信用社联合社",
////    "LZYH": "兰州银行",
////    "JSB": "晋商银行",
////    "BOHAIB": "渤海银行",
////    "CZCB": "浙江稠州商业银行",
////    "YQCCB": "阳泉银行",
////    "SJBANK": "盛京银行",
////    "XABANK": "西安银行",
////    "BSB": "包商银行",
////    "JSBANK": "江苏银行",
////    "FSCB": "抚顺银行",
////    "HNRCU": "河南省农村信用",
////    "COMM": "交通银行",
////    "XTB": "邢台银行",
////    "CITIC": "中信银行",
////    "HXBANK": "华夏银行",
////    "HNRCC": "湖南省农村信用社",
////    "DYCCB": "东营市商业银行",
////    "ORBANK": "鄂尔多斯银行",
////    "BJRCB": "北京农村商业银行",
////    "XYBANK": "信阳银行",
////    "ZGCCB": "自贡市商业银行",
////    "CDCB": "成都银行",
////    "HANABANK": "韩亚银行",
////    "CMBC": "中国民生银行",
////    "LYBANK": "洛阳银行",
////    "GDB": "广东发展银行",
////    "ZBCB": "齐商银行",
////    "CBKF": "开封市商业银行",
////    "H3CB": "内蒙古银行",
////    "CIB": "兴业银行",
////    "CRCBANK": "重庆农村商业银行",
////    "SZSBK": "石嘴山银行",
////    "DZBANK": "德州银行",
////    "SRBANK": "上饶银行",
////    "LSCCB": "乐山市商业银行",
////    "JXRCU": "江西省农村信用",
////    "ICBC": "中国工商银行",
////    "JZBANK": "晋中市商业银行",
////    "HZCCB": "湖州市商业银行",
////    "NHB": "南海农村信用联社",
////    "XXBANK": "新乡银行",
////    "JRCB": "江苏江阴农村商业银行",
////    "YNRCC": "云南省农村信用社",
////    "ABC": "中国农业银行",
////    "GXRCU": "广西省农村信用",
////    "PSBC": "中国邮政储蓄银行",
////    "BZMD": "驻马店银行",
////    "ARCU": "安徽省农村信用社",
////    "GSRCU": "甘肃省农村信用",
////    "LYCB": "辽阳市商业银行",
////    "JLRCU": "吉林农信",
////    "URMQCCB": "乌鲁木齐市商业银行",
////    "XLBANK": "中山小榄村镇银行",
////    "CSCB": "长沙银行",
////    "JHBANK": "金华银行",
////    "BHB": "河北银行",
////    "NBYZ": "鄞州银行",
////    "LSBC": "临商银行",
////    "BOCD": "承德银行",
////    "SDRCU": "山东农信",
////    "NCB": "南昌银行",
////    "TCCB": "天津银行",
////    "WJRCB": "吴江农商银行",
////    "CBBQS": "城市商业银行资金清算中心",
////    "HBRCU": "河北省农村信用社"
////}
////";
//}

+ (NSString *)md5:(NSString *)string{
    if (!string) return nil;
    
    const char *cStr = string.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    
    return md5Str;
}

+ (void)pasteWithText:(NSString *)text{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}

/**
 *  System Size
 */
+ (CGRect)statusBarFrame {
    
    return [self keyWindow].rootViewController.view.window.windowScene.statusBarManager.statusBarFrame;
}

+ (CGFloat)safeAreaInsetsBottom {
    
    return [self keyWindow].safeAreaInsets.bottom;
}

+ (CGFloat)safeAreaInsetsTop {
    
    return [self keyWindow].safeAreaInsets.top;
}

+ (UIWindow *)keyWindow {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        
        if ([scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]) {
            UIWindow *window = [(id<UIWindowSceneDelegate>)scene.delegate window];
            
            keyWindow = window;
        }
    }
    
    return keyWindow;
}

/**
 * APP
 */
+ (NSString *)checkCircleInfo:(NSString *)userNum {
    
    if([NSString isNotEmptyAndValid:userNum]) {
        
        CGFloat userNumInt = [userNum floatValue];
        if(userNumInt >= 1000) {
            
            return [NSString stringWithFormat:@"%@k圈友", @(userNumInt / 1000)];
        }
        else if(userNumInt >= 10000) {
            
            return [NSString stringWithFormat:@"%@w圈友", @(userNumInt / 10000)];
        }
        else {
            return [NSString stringWithFormat:@"%@圈友", @(userNumInt)];
        }
    }
    else {
        
        return @"";
    }
}

+ (NSString *)checkNumberInfo:(NSString *)userNum {
    
    if([NSString isNotEmptyAndValid:userNum]) {
        
        CGFloat userNumInt = [userNum floatValue];
        if(userNumInt >= 1000) {
            
            return [NSString stringWithFormat:@"%@k", @(userNumInt / 1000)];
        }
        else if(userNumInt >= 10000) {
            
            return [NSString stringWithFormat:@"%@w", @(userNumInt / 10000)];
        }
        else {
            return [NSString stringWithFormat:@"%@", @(userNumInt)];
        }
    }
    else {
        
        return @"0";
    }
}

+ (NSString *)checkNumberInfo:(NSString *)userNum plus:(NSInteger)plus {
    
    if([NSString isNotEmptyAndValid:userNum]) {
        
        CGFloat userNumInt = [userNum floatValue];
        
        return [NSString stringWithFormat:@"%@", @(userNumInt + plus)];
    }
    else {
        return [NSString stringWithFormat:@"%@", @((plus < 0 ? 0 : plus))];
    }
}


+ (NSString *)urlencode:(NSString *)url {
    
    NSMutableString *output = [NSMutableString string];
        const unsigned char *source = (const unsigned char *)[url UTF8String];
        int sourceLen = strlen((const char *)source);
        for (int i = 0; i < sourceLen; ++i) {
            const unsigned char thisChar = source[i];
            if (thisChar == ' '){
                [output appendString:@"+"];
            } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                       (thisChar >= 'a' && thisChar <= 'z') ||
                       (thisChar >= 'A' && thisChar <= 'Z') ||
                       (thisChar >= '0' && thisChar <= '9')) {
                [output appendFormat:@"%c", thisChar];
            } else {
                [output appendFormat:@"%%%02X", thisChar];
            }
        }
        return output;
}

+ (void)savePlayRecordInfo:(NSDictionary *)dic {
    NSMutableArray *temArr = [self getPlayRecordInfo];
    BOOL flag = NO;
    NSDictionary *temDic;
    for (NSDictionary *itemDic in temArr) {
        if([itemDic[@"id"] integerValue] == [dic[@"id"] integerValue]) {
            flag = YES;
            temDic = itemDic;
            break;
        }
    }
    if(flag) {
        [temArr removeObject:temDic];
        [temArr addObject:dic];
    } else {
        [temArr addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setValue:temArr forKey:@"kSavePlayRecordInfoKey"];
    
}
+ (NSMutableArray *)getPlayRecordInfo {
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"kSavePlayRecordInfoKey"]];
    return array;
}

@end
