//
//  BaseViewController.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+Transitions.h"
#import "UIScrollView+ABProgressRefresh.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>

#define VIEWCONTROLLER_COUNT [self.navigationController.viewControllers count]
#define NAVIBACKBTN_TAG 111100
#define TITLELABEL_TAG  111111
#define NAVIMENU_TAG    111122
static CGFloat correctPosition = 4;//10;

@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MBProgressHUD *progress;
@property (nonatomic, assign) BOOL pushDirectionFlag;

@end

@implementation BaseViewController

- (void)dealloc{
    
    [NotificationCenterHelper removeNotifiction:NotificationCenterRefreshData observer:self];
    DLOG(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)loadView{
    [super loadView];
    
    [UIView setAnimationsEnabled:YES];
    
    if(@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else {
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //解决pop手势中断后tableView偏移问题
    self.extendedLayoutIncludesOpaqueBars = YES;
    
#ifdef SUPPORTBEFOREIOS9
    if(isIOS7_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        /*
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:FONT_BOLD_SYSTEM(18.f)}];
         */
    }
#endif
    /*
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor], UITextAttributeFont:FONT_BOLD_SYSTEM(20.f)}];
#pragma clang diagnostic pop
    }
    self.navigationController.navigationBar.translucent = NO;
    */
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"app_back_image")];
    backgroundView.width = self.view.width;
    backgroundView.height = self.view.height;
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundView];
    
    [self.view addSubview:self.mAGNavigateView];
    
    self.view.backgroundColor = [UIColor mainBackColor];
    //[self setNormalLeftNaviButton];
    //[self changeNaviBarBack];
    
    [NotificationCenterHelper addNotifiction:NotificationCenterRefreshData observer:self selector:@selector(didReloadViewData)];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self setAGLeftNaviButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    DLOG(@"%@ retaincount:%ld", NSStringFromClass([self class]), CFGetRetainCount((__bridge CFTypeRef)self));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeNaviBarBack{
    /*
    NSArray *notChangeControllerArray = @[@"SubscribeViewController",
                                          @"InfomationViewController",
                                          @"LuxuryViewController"];
    
    for(NSString *controllerString in notChangeControllerArray){
        if([NSStringFromClass([self class]) isEqualToString:controllerString]){
            [[UINavigationBar appearance] setBackgroundImage:[HelpTools createImageWithColor:RGB_COLOR_ALPHA(168, 32, 38, 1.f)] forBarMetrics:UIBarMetricsDefault];
            
            return;
        }
    }
    [[UINavigationBar appearance] setBarTintColor:RGB_COLOR_ALPHA(0, 0, 0, 1.f)];
//    [[UINavigationBar appearance] setBackgroundImage:[HelpTools createImageWithColor:RGB_COLOR_ALPHA(0, 0, 0, 1.f)] forBarMetrics:UIBarMetricsDefault];
     */
}

#pragma mark -
- (void)setAGNavibarHide:(BOOL)isHide {
    
    self.mAGNavigateView.hidden = isHide;
}

- (void)setAGLeftNaviButton {
    
    [self.mAGNavigateView setAGLeftNaviButtonHide:!([self.navigationController.viewControllers count] > 1)];
}

#pragma mark -

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    
    [self.mAGNavigateView setAGNaviTitle:titleString];
    //self.navigationItem.title = [NSString stringSafeChecking:titleString];
}

#pragma mark -
- (void)setNormalLeftNaviButton{
    if([self.navigationController.viewControllers count] > 1){
        [self setLeftNaviBarButton];
    }
}

#pragma mark - ScrollViewPullToRefresh
- (void)addRefreshControlWithScrollView:(UIScrollView *)scrollView isInitialRefresh:(BOOL)isRefresh shouldInsert:(BOOL)shouldInsert forKey:(const void *)key{
    objc_setAssociatedObject(self, key, scrollView, OBJC_ASSOCIATION_ASSIGN);
    
    __weak typeof(self) __SCBlockSelf = self;
    __block __typeof(key) __blockKey = key;
    [scrollView addPullToRefreshActionHandler:^{
        [__SCBlockSelf shouldInsertMore:YES key:__blockKey];
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

CGFloat SStime_wait = 2.0f;
- (void)dropViewDidBeginRefresh:(const void *)key{
    int64_t delayInSeconds = SStime_wait;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    __block __typeof(key) __blockKey = key;
    __weak typeof(self) __SCBlockSelf = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [__SCBlockSelf dropViewDidFinishRefresh:__blockKey];
    });
}

- (void)dropViewDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopPullRefreshAnimation];
}

- (void)loadInsertDidBeginRefresh:(const void *)key{
    int64_t delayInSeconds = SStime_wait;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    __block __typeof(key) __blockKey = key;
    __weak typeof(self) __SCBlockSelf = self;

    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [__SCBlockSelf loadInsertDidFinishRefresh:__blockKey];
    });
}

- (void)loadInsertDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopInsertRefreshAnimation];
}

- (void)refreshDidFinishRefresh:(const void *)key{
    [objc_getAssociatedObject(self, key) stopPullRefreshAnimation];
    [objc_getAssociatedObject(self, key) stopInsertRefreshAnimation];
}

- (void)shouldInsertMore:(BOOL)shouldMore key:(const void *)key{
    
    [objc_getAssociatedObject(self, key) setInsertMore:shouldMore];
}

- (BOOL)isInsertRefreshingWitKkey:(const void *)key{
    
    return YES;//[objc_getAssociatedObject(self, key) isInsertRefreshing];
}

- (void)setMoreInfoString:(NSString *)moreInfoString withKey:(const void *)key{
    
    [objc_getAssociatedObject(self, key) setMoreInfoString:moreInfoString];
}

#pragma mark - SetNavigationBar
- (void)setLeftNaviBarButton{
    //添加自定义返回按钮的同时隐藏系统返回按钮
    //self.navigationItem.hidesBackButton = YES;
    [self setLeftNaviBarButton:[UIImage imageNamed:@"navi_back_normal"] highImage:[UIImage imageNamed:@"navi_back_normal"] selector:@selector(leftBtnAction:)];
}

- (void)hideLeftNaviBarButton{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
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
    
    UIButton *leftButton = [self setNaviBarButton:normalImage highImage:highImage buttonHeight:44.f selector:btnAction];
    if(isIOS7_LATER){
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -(correctPosition), 0, (correctPosition));
    }
    [leftButton setExclusiveTouch:YES];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    //self.navigationItem.backBarButtonItem = leftButtonItem;
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.hidesBackButton = NO;
}

- (UIButton *)setRightNaviBarButton:(UIImage *)normalImage
                          highImage:(UIImage *)highImage
                           selector:(SEL)btnAction{
    
    UIButton *rightButton = [self setNaviBarButton:normalImage highImage:highImage buttonHeight:45.f selector:btnAction];
    if(isIOS7_LATER){
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -0);
    }
    [rightButton setExclusiveTouch:YES];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    return rightButton;
}

- (NSArray *)setRightNaviBarButtons:(NSArray *)normalImages
                         highImages:(NSArray *)highImages
                     selectedImages:(NSArray *)selectedImages
                       buttonHeight:(CGFloat)buttonHeight
                           selector:(SEL)btnAction{
    
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:normalImages.count];
    NSMutableArray *buttonItemArray = [NSMutableArray arrayWithCapacity:normalImages.count];
    for(int i = 0; i < normalImages.count; ++i){
        UIButton *rightButton = [self setNaviBarButton:[normalImages objectAtIndexForSafe:i] highImage:[highImages objectAtIndexForSafe:i] buttonHeight:buttonHeight selector:btnAction];
        [rightButton setExclusiveTouch:YES];
        rightButton.tag = i;
        
        NSString *selectedImageName = [selectedImages objectAtIndexForSafe:i];
        if([NSString isNotEmptyAndValid:selectedImageName]){
            
            UIImage *selectedImage = IMAGE_NAMED(selectedImageName);
            if(selectedImage){
                
                [rightButton setImage:selectedImage forState:UIControlStateSelected];
            }
        }
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        [buttonArray addObject:rightButton];
        [buttonItemArray addObject:rightButtonItem];
    }
    
    self.navigationItem.rightBarButtonItems = buttonItemArray;
    return buttonArray;
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
    else if(self.pushDirectionFlag){
        [self dismissViewControllerWithPushDirection:kCATransitionFromLeft];
    }
    else {
        [self dismissViewControllerAnimated:Animate completion:nil];
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

- (void)setPushDirectionFlag{
    self.pushDirectionFlag = YES;
}

- (void)didReloadViewData{
    
    
}

- (void)networkChanged:(NSNotification *)notification {
    
    ZYNetworkAccessibleState state = ZYNetworkAccessibility.currentState;

    if (state == ZYNetworkAccessible) {
        
        [self didReloadViewData];
    }
}

#pragma mark - DeviceOrientation
- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - reload data
- (void)reloadDataFromServer:(id)sender{
    
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
        [_progress showAnimated:NO];
        [_progress removeFromSuperview];
        _progress = nil;
    }
}

#pragma mark -

- (void)addClickCloseKeyboardForObserver:(id)observer{
    
    UITapGestureRecognizer *clickCloseKeyboardGC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHandle:)];
    clickCloseKeyboardGC.cancelsTouchesInView = NO;
    clickCloseKeyboardGC.delegate = self;
    
    [observer addGestureRecognizer:clickCloseKeyboardGC];
}

- (void)didClickHandle:(id)recognizer{
    
    [self hideKeyBoard];
}

- (void)hideKeyBoard{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"] ||
        [NSStringFromClass([touch.view class]) isEqual:@"QBStarView"] ||
        [NSStringFromClass([touch.view class]) isEqual:@"UIButton"]){
        return NO;
    }

    return YES;
}
 */

- (ZJErrorView *)mZJErrorViewEmpty{
    
    if(!_mZJErrorViewEmpty){
        
        _mZJErrorViewEmpty = [[ZJErrorView alloc] initWithKey:@"ERROR_Empty_ES"];
    }
    
    return _mZJErrorViewEmpty;
}

- (ZJErrorView *)mZJErrorViewError{
    
    if(!_mZJErrorViewError){
        
        _mZJErrorViewError = [[ZJErrorView alloc] initWithKey:@"ERROR_Network_ES"];
    }
    
    return _mZJErrorViewError;
}

- (AGNavigateView *)mAGNavigateView{
    
    if(!_mAGNavigateView){
        
        _mAGNavigateView = [[AGNavigateView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, CGRectGetHeight([HelpTools statusBarFrame]) + kNaviBarHeight)];
        
        __WeakObject(self);
        _mAGNavigateView.navigateLeftDidSelected = ^{
            __WeakStrongObject();
            
            [__strongObject backToParentView];
        };
    }
    
    return _mAGNavigateView;
}

- (UILabel *)mEmptyNoticeLabel {
    
    if(!_mEmptyNoticeLabel) {
        
        _mEmptyNoticeLabel = [UILabel new];
        _mEmptyNoticeLabel.font = [UIFont font14];
        _mEmptyNoticeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        _mEmptyNoticeLabel.text = @"暂时没有内容~";
        [_mEmptyNoticeLabel sizeToFit];
    }
    
    return _mEmptyNoticeLabel;
}

- (UILabel *)mErroNoticeLabel {
    
    if(!_mErroNoticeLabel) {
        
        _mErroNoticeLabel = [UILabel new];
        _mErroNoticeLabel.font = [UIFont font14];
        _mErroNoticeLabel.textColor = [UIColor whiteColor];
        _mErroNoticeLabel.text = @"网络错误，请稍后再试~";
        [_mErroNoticeLabel sizeToFit];
    }
    
    return _mErroNoticeLabel;
}

@end
