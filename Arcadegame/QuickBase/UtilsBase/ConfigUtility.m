//
//  ConfigUtility.m
//  Abner
//
//  Created by Abner on 15/3/6.
//  Copyright © 2015年 Abner. All rights reserved.
//

#import "ConfigUtility.h"
#import <WebKit/WebKit.h>

@implementation ConfigUtility

+ (void)initUIAppearance{
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
}

+ (void)setHttpRequestUserAgent{
    
    WKWebView *webView = [WKWebView new];
    
    //get the original user-agent of webview
    NSString *oldAgent = webView.customUserAgent;
    
    //add my info to the new agent
    NSString *identifierString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    NSString *newAgent = [oldAgent stringByAppendingString:[NSString stringWithFormat:@" %@",identifierString]];
    
    //regist the new agent
    NSDictionary *dictionnary = @{@"UserAgent":newAgent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

+ (void)setHttpRequestUserAgentWithNewAgent:(NSString *)agent{
    
    WKWebView *webView = [WKWebView new];
    //get the original user-agent of webview
    NSString *oldAgent = webView.customUserAgent;
    
    //add my info to the new agent
    //NSString *identifierString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    NSString *newAgent = [oldAgent stringByAppendingString:[NSString stringWithFormat:@" %@", [NSString stringSafeChecking:agent]]];
    
    //regist the new agent
    NSDictionary *dictionnary = @{@"UserAgent":newAgent};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

+ (void)initRongClound{
    
    //[[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
}

+ (void)rongCloundDeviceToken:(NSData *)deviceToken{
    
//    NSString *tokenString = [[[[deviceToken description]
//                        stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                       stringByReplacingOccurrencesOfString:@">" withString:@""]
//                      stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //[[RCIMClient sharedRCIMClient] setDeviceToken:tokenString];
}

@end
