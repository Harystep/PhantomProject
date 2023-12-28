//
//  RootViewController.h
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TABKEY) {
    
    TABKEY_HOME = 0,
    TABKEY_CIRCLE,
    /*
    TABKEY_GAME,
    */
    TABKEY_MINE,
};

@interface RootViewController : UIViewController

- (void)setHiddenTabBarWhenPush:(BOOL)hiddenBarWhenPush;
- (void)showViewAtIndex:(NSInteger)index;
- (BOOL)tabBarIsHiddened;

+ (RootViewController *)sharedRootVC;

@end

/**
 *  LanuchView
 */
@interface LanuchView : UIView

@end

/**
 *  IntroductionView
 */
@interface IntroductionView : UIView

@end
