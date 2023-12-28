//
//  AppSingleton.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 Abner. All rights reserved.
//

#import "AppSingleton.h"

@implementation AppSingleton
@synthesize tokenString = _tokenString;
@synthesize hasRedPaperShow = _hasRedPaperShow;

- (NSString *)tokenString{
    if(!_tokenString){
        NSString *cacheTokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userTokenString"];
        if(cacheTokenStr){
            _tokenString = cacheTokenStr;
        }
        else {
            _tokenString = @"";
        }
    }
    
    return _tokenString;
}

- (void)setTokenString:(NSString *)tokenString{
    _tokenString = tokenString;
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"userTokenString"];
}

- (BOOL)isRefreshBackgroundImage{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isRefreshBackgroundImage"];
}

- (void)setIsRefreshBackgroundImage:(BOOL)isRefreshBackgroundImage{
    [[NSUserDefaults standardUserDefaults] setBool:isRefreshBackgroundImage forKey:@"isRefreshBackgroundImage"];
}

- (NSDictionary *)userSessionDic{
    if(!_userSessionDic){
        NSDictionary *sessionDic = [HelpTools getUserSessionObject];
        if(!sessionDic){
            sessionDic = @{};
        }
        
        return sessionDic;
    }
    
    return _userSessionDic;
}

- (BOOL)isLogin{
    return [HelpTools isLogin];
}

- (BOOL)hasRedPaperShow{
    
    [self.showDataLock lock];
    BOOL result = _hasRedPaperShow;
    [self.showDataLock unlock];
    
    return result;
}

- (void)setHasRedPaperShow:(BOOL)hasRedPaperShow{
    
    [self.showDataLock lock];
    _hasRedPaperShow = hasRedPaperShow;
    [self.showDataLock unlock];
}

- (NSLock *)showDataLock{
    
    if(!_showDataLock){
        _showDataLock = [NSLock new];
    }
    
    return _showDataLock;
}

#pragma mark - isShowLeadPageView

- (void)setIsShowedLeadPageView:(BOOL)isShowedLeadPageView{
    
    [[NSUserDefaults standardUserDefaults] setBool:isShowedLeadPageView forKey:@"666_isShowedLeadPageView"];
}

- (BOOL)isShowedLeadPageView{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"666_isShowedLeadPageView"];
}

- (void)setIsShowedIntoductionView:(BOOL)isShowedIntoductionView{
    
    [[NSUserDefaults standardUserDefaults] setObject:APP_VERSION forKey:@"666_appLastVersion"];
    [[NSUserDefaults standardUserDefaults] setBool:isShowedIntoductionView forKey:@"666_isShowedIntoductionView"];
}

- (BOOL)isShowedIntoductionView{
    
    BOOL resultValue = [[NSUserDefaults standardUserDefaults] boolForKey:@"666_isShowedIntoductionView"];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"666_appLastVersion"];
    
    // 是否比本地版号低
    if([HelpTools versionCompareWithServerVersion:lastVersion] == 2){
        
        resultValue = NO;
    }
    
    return resultValue;
}

- (void)setIsShowedPlayerTeach:(BOOL)isShowedPlayerTeach {
    [[NSUserDefaults standardUserDefaults] setBool:isShowedPlayerTeach forKey:@"666_isShowedPlayerTeach"];
}

- (BOOL)isShowedPlayerTeach {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"666_isShowedPlayerTeach"];
}

@end
