//
//  UIViewController+Activity.m
//  Interactive
//
//  Created by Abner on 16/6/17.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "UIViewController+Activity.h"

@implementation UIViewController (Activity)

- (UIViewController *)activityViewController{
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    
    UINavigationController *rootNaviVC = nil;
    
    if([topVC isKindOfClass:[UINavigationController class]]){
        
        rootNaviVC = (UINavigationController *)topVC;
    }
    else if([topVC isKindOfClass:[UIViewController class]]){
        
        rootNaviVC = [(UIViewController *)topVC navigationController];
    }
    
    UIViewController *viewController = [rootNaviVC.viewControllers lastObject];
    
    return viewController;
}

/*
- (UIViewController *)activityViewController{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0){
        
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]){
            activityViewController = nextResponder;
        }
        else {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}
 */

@end
