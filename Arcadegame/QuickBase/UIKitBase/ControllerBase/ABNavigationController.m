//
//  ABNavigationController.m
//  KuaiDaiMarket
//
//  Created by Abner on 2019/3/29.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABNavigationController.h"

@interface ABNavigationController ()

@end

@implementation ABNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}

- (BOOL)shouldAutorotate {
    
    //return self.topViewController.shouldAutorotate;
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        // push的时候隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer == self.interactivePopGestureRecognizer){
        
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if(self.viewControllers.count < 2 ||
           self.visibleViewController == [self.viewControllers objectAtIndex:0]){
            
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

@end
