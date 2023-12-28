//
//  BaseTableViewController.m
//  Abner
//
//  Created by Abner on 15/3/9.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIScrollView+ABProgressRefresh.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>

#define VIEWCONTROLLER_COUNT [self.navigationController.viewControllers count]
#define NAVIBACKBTN_TAG 111100
#define TITLELABEL_TAG  111111
#define NAVIMENU_TAG    111122
static CGFloat correctPosition = 18;

@interface BaseTableViewController ()

@property (nonatomic, strong) MBProgressHUD *progress;

@end

@implementation BaseTableViewController

- (void)loadView{
    [super loadView];
    
    if(isIOS7_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:FONT_BOLD_SYSTEM(20.f)}];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor], UITextAttributeFont:FONT_BOLD_SYSTEM(20.f)}];
#pragma clang diagnostic pop
    }
    
    [self setNormalLeftNaviButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[self tableViewCellClass] forCellReuseIdentifier:NSStringFromClass([self tableViewCellClass])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setNormalLeftNaviButton{
    if([self.navigationController.viewControllers count] > 1){
        [self setLeftNaviBarButton];
    }
}

- (Class)tableViewCellClass{
    return [UITableViewCell class];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ScrollViewPullToRefresh
- (void)addRefreshControlWithScrollView:(UIScrollView *)scrollView isInitialRefresh:(BOOL)isRefresh shouldInsert:(BOOL)shouldInsert forKey:(const void *)key{
    objc_setAssociatedObject(self, key, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    __block __typeof(self) __SCBlockSelf = self;
    __block __typeof(key) __blockKey = key;
    [scrollView addPullToRefreshActionHandler:^{
        [__SCBlockSelf dropViewDidBeginRefresh:__blockKey];
    }];
    
    if(shouldInsert){
        [scrollView addInsertToRefreshActionHandler:^{
            [__SCBlockSelf loadInsertDidBeginRefresh:__blockKey];
        }];
    }
    
    if(isRefresh){
        [self triggerPullToRefreshWithKey:key];
    }
}

- (void)triggerPullToRefreshWithKey:(const void *)key{
    [objc_getAssociatedObject(self, key) triggerPullToRefresh];
}

- (void)dropViewDidBeginRefresh:(const void *)key{
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    __block __typeof(key) __blockKey = key;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self dropViewDidFinishRefresh:__blockKey];
    });
}

- (void)dropViewDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopPullRefreshAnimation];
}

- (void)loadInsertDidBeginRefresh:(const void *)key{
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    __block __typeof(key) __blockKey = key;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self loadInsertDidFinishRefresh:__blockKey];
    });
}

- (void)loadInsertDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopInsertRefreshAnimation];
}

- (void)refreshDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopPullRefreshAnimation];
    [objc_getAssociatedObject(self, key) stopInsertRefreshAnimation];
}

#pragma mark - SetNavigationBar
- (void)setLeftNaviBarButton{
    //添加自定义返回按钮的同时隐藏系统返回按钮
    //self.navigationItem.hidesBackButton = YES;
    [self setLeftNaviBarButton:[UIImage imageNamed:@"nav_return_normal.png"] highImage:[UIImage imageNamed:@"nav_return_pressed.png"] selector:@selector(leftBtnAction:)];
}

- (void)hideLeftNaviBarButton{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)setRightNaviBarButton{
    [self setRightNaviBarButton:[UIImage imageNamed:@"nav_return_normal.png"] highImage:[UIImage imageNamed:@"nav_return_normal.png"] selector:@selector(rightBtnAction:)];
}

- (void)hideRightNaviBarButton{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)setLeftNaviBarButton:(UIImage *)normalImage
                   highImage:(UIImage *)highImage
                    selector:(SEL)btnAction{
    
    UIButton *leftButton = [self setNaviBarButton:normalImage highImage:highImage buttonHeight:45 selector:btnAction];
    if(isIOS7_LATER){
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -(correctPosition), 0, (correctPosition));
    }
    [leftButton setExclusiveTouch:YES];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    //self.navigationItem.backBarButtonItem = leftButtonItem;
    self.navigationItem.backBarButtonItem.title = @"";
}

- (UIButton *)setRightNaviBarButton:(UIImage *)normalImage
                          highImage:(UIImage *)highImage
                           selector:(SEL)btnAction{
    
    UIButton *rightButton = [self setNaviBarButton:normalImage highImage:highImage buttonHeight:28.f selector:btnAction];
    if(isIOS7_LATER){
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -0);
    }
    [rightButton setExclusiveTouch:YES];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    return rightButton;
}

- (UIButton*)setNaviBarButton:(UIImage *)normalImage
                    highImage:(UIImage *)highImage
                 buttonHeight:(CGFloat)buttonHeight
                     selector:(SEL)btnAction{
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalImage) {
        customButton.frame = CGRectMake(0, 0, buttonHeight*(normalImage.size.width/normalImage.size.height), buttonHeight);
        
        [customButton setImage:normalImage forState:UIControlStateNormal];
    }
    
    if (highImage) {
        [customButton setImage:highImage forState:UIControlStateHighlighted];
    }
    
    if(btnAction) {
        [customButton addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customButton;
}

- (UIButton *)setRightNaviBarTitle:(NSString *)titleString
                       normalColor:(UIColor *)normalColor
                         highColor:(UIColor *)highColor
                          selector:(SEL)btnAction{
    
    UIButton *rightButton = [self setNaviBarButtonTitle:titleString normalColor:normalColor highColor:highColor selector:btnAction];
    if(isIOS7_LATER){
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, correctPosition, 0, -correctPosition);
    }
    [rightButton setExclusiveTouch:YES];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    return rightButton;
}

- (UIButton *)setNaviBarButtonTitle:(NSString *)titleString
                        normalColor:(UIColor *)normalColor
                          highColor:(UIColor *)highColor
                           selector:(SEL)btnAction{
    
    CGFloat buttonHeight = 30.0;
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.titleLabel.font = titleFont;
    customButton.backgroundColor = [UIColor clearColor];
    [customButton setTitle:titleString forState:UIControlStateNormal];
    [customButton setTitleColor:normalColor forState:UIControlStateNormal];
    [customButton setTitleColor:highColor forState:UIControlStateHighlighted];
    
    CGSize stringSize = CGSizeZero;
    if(isIOS7_LATER){
        stringSize = [titleString boundingRectWithSize:CGSizeMake(MAXFLOAT, titleFont.lineHeight) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:titleFont} context:nil].size;
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        stringSize = [titleString sizeWithFont:titleFont constrainedToSize:CGSizeMake(MAXFLOAT, titleFont.lineHeight) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    
    customButton.frame = CGRectMake(0, 0, buttonHeight*(stringSize.width/stringSize.height), buttonHeight);
    
    if(btnAction) {
        [customButton addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    }
    [customButton setExclusiveTouch:YES];
    
    return customButton;
}

#define mark - Selector
- (void)leftBtnAction:(id)sender{
    [self backToParentView];
}

- (void)rightBtnAction:(id)sender{
    
}

- (void)backToParentView{
    [self backToParentViewAnimate:YES];
}

- (void)backToParentViewAnimate:(BOOL)Animate{
    if([self.navigationController.viewControllers count] > 1){
        [self.navigationController popViewControllerAnimated:Animate];
    }
    else {
        [self dismissViewControllerAnimated:Animate completion:nil];
    }
}

- (void)backToRootViewControllerAnimate:(BOOL)animate{
    if([self.navigationController.viewControllers count] > 1){
        [self.navigationController popToRootViewControllerAnimated:animate];
    }
}

#pragma mark - MBPLodingView
- (void)popLoadingView{
    if(!_progress){
        _progress = [[MBProgressHUD alloc] initWithView:self.view];
        //_progress.labelText = @"数据加载中...";
    }
    [_progress showAnimated:YES];
    [self.view addSubview:_progress];
}

- (void)removeLoadingView{
    if(_progress){
        [_progress removeFromSuperview];
        _progress = nil;
    }
}

@end
