//
//  UIViewController+Transitions.m
//  Abner
//
//  Created by Abner on 15/3/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "UIViewController+Transitions.h"
#import <QuartzCore/QuartzCore.h>

#import "QBBaseLoginViewController.h"

@implementation UIViewController (Transitions)

- (void)presentViewController:(UIViewController *)viewController withPushDirection:(NSString *)direction{
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.fillMode = kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.duration = 0.35f;
    transition.removedOnCompletion = YES;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    [self presentViewController:viewController animated:NO completion:nil];
    
    [CATransaction commit];
}

- (void)dismissViewControllerWithPushDirection:(NSString *)direction{
    [CATransaction begin];
    
    CATransition *transition = [CATransition animation];
    transition.fillMode = kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype = direction;
    transition.duration = 0.35f;
    transition.removedOnCompletion = YES;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [CATransaction setCompletionBlock: ^ {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [CATransaction commit];
}

- (void)showLoginViewControllerHandle:(void(^)(BOOL isLoginSuccsee))handle{
    /*
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    __weak __typeof(loginVC)__blockLoginVC = loginVC;
    loginVC.loginSuccess = ^(){
        if(handle){
            handle(NO);
        }
        
        [__blockLoginVC backToRootViewControllerAnimate:YES];
    };
    
    loginVC.backToParent = ^(){
        if(handle){
            handle(YES);
        }
        
        [__blockLoginVC backToParentViewAnimate:YES];
    };
    
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:naviVC animated:YES completion:nil];
    */
    
    QBBaseLoginViewController *VC = (QBBaseLoginViewController *)[HelpTools getLoginVCInfoFromConfig];
    
    if(!self.presentingViewController &&
       VC){
        
         __WeakObject(self);
        if(self.navigationController.isNavigationBarHidden &&
           [self respondsToSelector:NSSelectorFromString(@"setNaviBarHiddenDismissAnimation:")]){
            
            [self setValue:[NSNumber numberWithBool:NO] forKey:@"naviBarHiddenDismissAnimation"];
        }
        
        [self presentViewController:VC animated:YES completion:nil];
        
        VC.loginSuccessHandle = ^{

            if(handle) handle(YES);
        };

        VC.loginCancelHandle = ^{
            __WeakStrongObject();
            
            if([__strongObject checkLoginControlShouldGoRoot:[__strongObject class]]){
                
                [__strongObject.navigationController popToRootViewControllerAnimated:YES];
            }

            if(handle) handle(NO);
        };
    }
}

- (BOOL)checkLoginControlShouldGoRoot:(Class)controllerClass{
    
    __block BOOL resultValue = YES;
    NSArray *ignoreArray = [[HelpTools readBaseConfigData] objectForKey:@"QBLOGINIGNORETOROOT"];
    
    if(ignoreArray && ignoreArray.count){
        
        [ignoreArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([NSStringFromClass(controllerClass) isEqualToString:obj]){
                
                resultValue = NO;
                *stop = YES;
            }
        }];
    }
    
    return resultValue;
}

@end
