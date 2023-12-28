//
//  QBBaseLoginViewController.m
//  QuickBase
//
//  Created by Abner on 2019/6/21.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBBaseLoginViewController.h"

@interface QBBaseLoginViewController ()

@end

@implementation QBBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backToParentViewAnimate:(BOOL)Animate{
    
    if([self.navigationController.viewControllers count] > 1){
        
        [self.navigationController popViewControllerAnimated:Animate];
    }
    else {
        [self dismissViewControllerAnimated:Animate completion:nil];
    }
    
    if(self.loginCancelHandle){
        
        self.loginCancelHandle();
    }
}

- (void)backToRootViewControllerAnimate:(BOOL)animate{
    
    if([self.navigationController.viewControllers count] > 1){
        
        [self.navigationController popToRootViewControllerAnimated:animate];
    }
    else {
        [self dismissViewControllerAnimated:animate completion:nil];
    }
}

- (void)backToPresentRootVCAnimate:(BOOL)animate{
    
    UIViewController *presentRootVC = self.presentingViewController;
    
    while (presentRootVC.presentingViewController) {
        
        presentRootVC = presentRootVC.presentingViewController;
    }
    
    [presentRootVC dismissViewControllerAnimated:animate completion:nil];
}

@end
