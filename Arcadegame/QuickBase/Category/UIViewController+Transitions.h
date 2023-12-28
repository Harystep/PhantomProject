//
//  UIViewController+Transitions.h
//  Abner
//
//  Created by Abner on 15/3/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transitions)

- (void)showLoginViewControllerHandle:(void(^)(BOOL isLoginSuccsee))handle;

- (void)presentViewController:(UIViewController *)viewController withPushDirection:(NSString *)direction;

- (void)dismissViewControllerWithPushDirection:(NSString *)direction;

@end
