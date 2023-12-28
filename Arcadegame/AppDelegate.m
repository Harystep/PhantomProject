//
//  AppDelegate.m
//  Arcadegame
//
//  Created by Abner on 2023/6/10.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/*
 域名：https://qmjjc-api.5iwanquan.com/api
 channelKey：quanmingjiejicheng
 accessToken：123456789
 */


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    ESUserData *userData = [ESUserData new];
//    userData.token = @"123456789";
//    [HelpTools saveUserData:userData];
    
    [HelpTools sharedAppSingleton].baseUrlString = WSURL;
    [HelpTools sharedAppSingleton].currentAPISalt = kAPISalt;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:[RootViewController new]];
    
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:PNSATAUTHSDKINFO
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        DLOG(@"TXCommonHandler setAuthSDKInfo：%@", resultDic);
    }];
    
    return YES;
}

@end
