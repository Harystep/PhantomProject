//
//  RootViewController.m
//  Abner
//
//  Created by Abner on 15/3/4.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "RootViewController.h"
#import "ABTabBarController.h"
#import "QBBaseLoginViewController.h"

#import "SDImageCache.h"
#import "UIImage+GIF.h"

//#import "ESAddressHttp.h"
//#import "ESUserInfoHttp.h"
//#import "ESMessageHttp.h"

@class LanuchView;

@interface RootViewController ()

@property (nonatomic, strong) ABTabBarController *mTabBarController;

@property (strong, nonatomic) QBBaseLoginViewController *LOGINVC;
@property (strong, nonatomic) UIImageView *backgroundView;

@end

@implementation RootViewController

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationItem.leftBarButtonItems = nil;
    
    self.backgroundView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"app_back_image")];
    self.backgroundView.width = self.view.width;
    self.backgroundView.height = self.view.height;
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundView];
    
    NSString *cacheARLIST = [CacheHelpTools getCommonCacheFile:Cache_ArList];
    
    if(![NSString isNotEmptyAndValid:cacheARLIST]) {
        
        [CacheHelpTools saveCommonCacheFile:Cache_ArList withFile:@"1" result:nil];
        [ZYNetworkAccessibility setAlertEnable:YES];
        [ZYNetworkAccessibility start];
    }
    
    /*
     if (isIOS7_LATER) {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     }else{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }
     */
    //[HelpTools createGradientImageWithSize:CGSizeMake(CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), kNaviBarHeight + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)) colors:@[UIColorFromRGB(0x3FDA68), UIColorFromRGB(0x3EC662)] gradientType:1]
    //[[UINavigationBar appearance] setBackgroundImage:[HelpTools createImageWithColor:[UIColor eshopColor] withRect:(CGRect){CGPointZero, {CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), kNaviBarHeight + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)}}] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[HelpTools createImageWithColor:[UIColor cellLineColor]]];
    //[[UINavigationBar appearance] setBackgroundImage:[HelpTools createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setClipsToBounds:YES];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    // ios 7.0以上
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xF2FEFF), NSFontAttributeName:FONT_BOLD_SYSTEM(18.f)}];
    
    // ios 9.0以下使用
    // [[UIImageView appearanceWhenContainedIn:NSClassFromString(@"_UIParallaxDimmingView"), nil] setAlpha:0.0f];
    // 9.0 及以上使用
    // [[UIImageView appearanceWhenContainedInInstancesOfClasses:@[NSClassFromString(@"_UIParallaxDimmingView")]] setAlpha:0.0f];
    /*
     if([@"1.0.1" isEqualToString:[HelpTools lastVersion]]){
     
     [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
     }
     */
     
    __WeakObject(self);
    [HelpTools prereadUserDataHandle:^{
        // 预加载用户数据
        __WeakStrongObject();
        
        if([HelpTools isLoginWithoutVC]){
            
            [__strongObject gotoMainViewController];
        }
        else {
            
            QBBaseLoginViewController *LOGINVC = (QBBaseLoginViewController *)[HelpTools getLoginVCInfoFromConfig];
            __strongObject.LOGINVC = LOGINVC;
            
            LOGINVC.loginSuccessHandle = ^{
                [__strongObject didUserLoginedHandle:nil];
            };
            
            [__strongObject addChildViewController:LOGINVC];
            [__strongObject.view addSubview:LOGINVC.view];
        }
    }];
    
    BOOL isShowReview = NO;
    if(isShowReview){
        //加载APP介绍页面
    }
    else {
        //进入主页
        //[self gotoMainViewController];
    }
    
    //必须先登录再使用
    [NotificationCenterHelper addNotifiction:NotificationCenterLogined observer:self selector:@selector(didUserLoginedHandle:)];
    [NotificationCenterHelper addNotifiction:NotificationCenterRelogin observer:self selector:@selector(didUserReLoginHandle:)];
    
    // 加载广告页
    //[self addLaunchView];
    
    // 第一次进入或新版本第一进入 加载APP介绍页
    /*
    if(![HelpTools sharedAppSingleton].isShowedIntoductionView){
        
        [self addIntoductionView];
    }
    else {
        [self addLaunchView];
    }
     */
    
    //[ESMessageUnReadCountHttp requestMessageUnReadCountResultHandle:nil];
    //[self requestUserInfoData];
    //[self requstAddressData];
    
    [self registerNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//
//    return UIStatusBarStyleLightContent;
////     return UIStatusBarStyleDefault;
//}

- (void)registerNotification{
    
    [HelpTools addNotifiction:NOTIFICATIONRELOADUSERINFO observer:self selector:@selector(reloadUserInfoData)];
}

- (void)didUserLoginedHandle:(id)sender {
    
    [self gotoMainViewController];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.LOGINVC.view.height = self.view.height;
        
    } completion:^(BOOL finished) {
        
        [self.LOGINVC.view removeFromSuperview];
        [self.LOGINVC removeFromParentViewController];
        self.LOGINVC = nil;
    }];
}

- (void)didUserReLoginHandle:(id)sender {
    
    QBBaseLoginViewController *LOGINVC = (QBBaseLoginViewController *)[HelpTools getLoginVCInfoFromConfig];
    self.LOGINVC = LOGINVC;
    
    LOGINVC.loginSuccessHandle = ^{
        [self didUserLoginedHandle:nil];
    };
    
    LOGINVC.view.top = self.view.height;
    [self addChildViewController:LOGINVC];
    [self.view addSubview:LOGINVC.view];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.LOGINVC.view.top = 0.f;
    }];
}

#pragma mark - RequestUserData

- (void)reloadUserInfoData{
    
    //[ESMessageUnReadCountHttp requestMessageUnReadCountResultHandle:nil];
    //[self requestUserInfoData];
    //[self requstAddressData];
}

#pragma mark - Privated
- (void)addLaunchView{
    LanuchView *launchView = [[LanuchView alloc] initWithFrame:self.view.bounds];
    //[[UIApplication sharedApplication].keyWindow addSubview:launchView];
    
    [self.view addSubview:launchView];
}

- (void)addIntoductionView{
    
    IntroductionView *introductionView = [[IntroductionView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:introductionView];
}

- (void)gotoMainViewController{
    
    [self.mTabBarController setTopSeparateLineColor:[UIColor clearColor]];
    
    [self addChildViewController:self.mTabBarController];
    [self.view addSubview:self.mTabBarController.view];
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)gotoLoginViewController{
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:naviVC animated:NO completion:nil];
//    
//    __BlockObject(self);
//    __block __weak __typeof(loginVC) __blockLoginVC = loginVC;
//    loginVC.loginSuccess = ^(){
//        [__blockObject gotoMainViewController];
//        [__blockLoginVC backToParentViewAnimate:YES];
//    };
}

#pragma mark -
- (void)setHiddenTabBarWhenPush:(BOOL)hiddenBarWhenPush{
    //[self.tabBarViewController setHiddenTabBarWhenPush:hiddenBarWhenPush];
}

- (BOOL)tabBarIsHiddened{
    //return [self.tabBarViewController tabBarIsHiddened];
    return NO;
}

- (void)showViewAtIndex:(NSInteger)index{
    //[self.tabBarController setSelectedIndex:index];
}

- (ABTabBarController *)mTabBarController{
    
    if(!_mTabBarController){
        
        //tab_icon_spring_home_normal tab_icon_home_normal
        //tab_icon_spring_home_selected tab_icon_home_selected
        ChildVCData *childVCData1 = [ChildVCData dataWithClassName:@"AGHomeViewController" tabTitle:@"" tabImageNormal:@"tab_icon_home_default" tabImageSelected:@"tab_icon_home_selected" shouldCloseAnimating:YES];
        
        //tab_icon_message_normal
        //tab_icon_message_selected
        ChildVCData *childVCData2 = [ChildVCData dataWithClassName:@"AGCircleViewController" tabTitle:@"" tabImageNormal:@"tab_icon_circle_default" tabImageSelected:@"tab_icon_circle_selected" shouldCloseAnimating:NO];
        
        //tab_icon_category_normal
        //tab_icon_category_selected
        //SZFinessController  AGGameViewController
        ChildVCData *childVCData3 = [ChildVCData dataWithClassName:@"SZFinessController" tabTitle:@"" tabImageNormal:@"tab_icon_game_default" tabImageSelected:@"tab_icon_game_selected" shouldCloseAnimating:NO];
        
        //tab_icon_shoppingcart_normal
        //tab_icon_shoppingcart_selected
        ChildVCData *childVCData4 = [ChildVCData dataWithClassName:@"AGMineViewController" tabTitle:@"" tabImageNormal:@"tab_icon_mine_default" tabImageSelected:@"tab_icon_mine_selected" shouldCloseAnimating:NO];
//        _mTabBarController = [[ABTabBarController alloc] initWithChildVCArray:@[childVCData1, childVCData2, childVCData4]];
        _mTabBarController = [[ABTabBarController alloc] initWithChildVCArray:@[childVCData1, childVCData2, childVCData3, childVCData4]];
    }
    
    return _mTabBarController;
}

+ (RootViewController *)sharedRootVC{
    
    static RootViewController *sharedRootVC = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRootVC = [RootViewController new];
    });
    
    return sharedRootVC;
}

@end


/**
 *  LanuchView
 */
@implementation LanuchView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor orangeColor];
        
        CarouselImageView *backImageView = [[CarouselImageView alloc] initWithFrame:self.bounds];
        [backImageView setImageWithObject:IMAGE_NAMED(@"lanuchView_image") withPlaceholderImage:nil interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        //backImageView.image = [LanuchView getLaunchImage];
        backImageView.cacheKey = @"LanuchView_image";
        
        backImageView.center = CGPointMake(self.width / 2.f, self.height / 2.f);
        [self addSubview:backImageView];
        
        int64_t delayInSeconds = 3.7f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);

        __weak typeof(self) __SCBlockSelf = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.3f animations:^{
                __SCBlockSelf.alpha = 0.1f;
            } completion:^(BOOL finished) {
                [__SCBlockSelf removeFromSuperview];
            }];
        });
    }
    
    return self;
}

//获取启动图
+ (UIImage *)getLaunchImage{
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOr = @"Portrait";//垂直
    NSString *launchImage = nil;
    NSArray *launchImages =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in launchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(viewSize, imageSize) && [viewOr isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

#ifdef OTHER
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backImageView.image = IMAGE_NAMED(@"launchBack");
        [self addSubview:backImageView];
        
        //-----------------------------------
        NSString *gifLoadingName = @"launchLoading.gif";
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:gifLoadingName ofType:nil];
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.image = [UIImage sd_imageWithGIFData:imageData];
        //iconImageView.alpha = 1.f;
        [self addSubview:iconImageView];
        
        /*
        UIImage *tempImage = nil;
        
        if(iconImageView.image.images.count > 0){
            tempImage = iconImageView.image.images[0];
        }
         */
        
        CGFloat iconImageWidth = CGRectGetWidth(self.frame);
        CGFloat iconImageHeight = CGRectGetWidth(self.frame) * (iconImageView.image.size.height/iconImageView.image.size.width);
        
        iconImageView.frame = CGRectMake(0, 0, iconImageWidth, iconImageHeight);
        iconImageView.center = self.center;
        
        NSString *infoString = @"";
        UIFont *infoLabelFont = FONT_SYSTEM(14.f);
        CGFloat infoLabelWidth = [HelpTools sizeForString:infoString withFont:infoLabelFont viewWidth:CGRectGetWidth(self.frame)].width;
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - infoLabelWidth)/2, CGRectGetMaxY(iconImageView.frame) + 20, infoLabelWidth, infoLabelFont.lineHeight)];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.font = infoLabelFont;
        infoLabel.text = infoString;
        infoLabel.alpha = 0.f;
        //[self addSubview:infoLabel];
        
        CGFloat lineViewWidth = 70.f;
        UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(infoLabel.frame) - lineViewWidth - 10, CGRectGetMinY(infoLabel.frame) + infoLabelFont.lineHeight/2 - 1, lineViewWidth, 1)];
        leftLineView.backgroundColor = [UIColor whiteColor];
        leftLineView.alpha = 0.f;
        //[self addSubview:leftLineView];
        
        UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(infoLabel.frame) + 10, CGRectGetMinY(infoLabel.frame) + infoLabelFont.lineHeight/2 - 1, lineViewWidth, 1)];
        rightLineView.backgroundColor = [UIColor whiteColor];
        rightLineView.alpha = 0.f;
        //[self addSubview:rightLineView];
        
        /*
        [UIView animateWithDuration:0.1f animations:^{
            iconImage.alpha = 1.f;
            infoLabel.alpha = 1.f;
            leftLineView.alpha = 1.f;
            rightLineView.alpha = 1.f;
        }];
        */
        
        //-----------------------------------
        /*
        [UIView animateWithDuration:3.f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.3f, 1.3f);
            backImageView.transform = scaleTransform;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.5f animations:^{
                self.alpha = 0.f;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
         */
        int64_t delayInSeconds = 4.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        __weak typeof(self) __SCBlockSelf = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.2f animations:^{
                __SCBlockSelf.alpha = 0.f;
            } completion:^(BOOL finished) {
                [__SCBlockSelf removeFromSuperview];
            }];
        });
    }
    
    return self;
}
#endif

@end

/**
 *  IntroductionView
 */
@interface IntroductionView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *mPageControl;
@property (nonatomic, strong) UIScrollView *backScrollView;
@property (nonatomic, assign) BOOL isClose;

@end

@implementation IntroductionView{
    
    NSInteger _curPageIndex;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.backScrollView.frame = self.bounds;
        [self addSubview:self.backScrollView];
        
        NSArray *imagesTitleArray = @[@"introduction_1.jpg", @"introduction_2.jpg", @"introduction_3.jpg"];
        
        for (int i = 0; i < imagesTitleArray.count; ++i) {
            
            CarouselImageView *imageView = [[CarouselImageView alloc] initWithFrame:CGRectOffset(self.bounds, self.backScrollView.frame.size.width * i, 0)];
            imageView.userInteractionEnabled = YES;
            imageView.ignoreCache = YES;
            
            if(i == (imagesTitleArray.count - 1)){
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
                [imageView addGestureRecognizer:tapGesture];
            }
            
            __WeakObject(imageView);
            [imageView setImageWithObject:imagesTitleArray[i] withPlaceholderImage:nil interceptImageModel:INTERCEPT_FULL_SIZE correctRect:^(CGSize size) {
                __WeakStrongObject();
                __strongObject.frame = CGRectOffset(CGRectMake(0, (self.bounds.size.height - size.height) / 2.f, self.bounds.size.width, size.height), self.backScrollView.frame.size.width * i, 0);
            }];
            
            [self.backScrollView addSubview:imageView];
        }
        
         [self.backScrollView setContentSize:CGSizeMake(imagesTitleArray.count * self.backScrollView.frame.size.width,  self.backScrollView.frame.size.height)];
        
        self.mPageControl.origin = CGPointMake((CGRectGetWidth(self.frame) - CGRectGetWidth(self.mPageControl.frame)) / 2.f, CGRectGetHeight(self.frame) - CGRectGetHeight(self.mPageControl.frame) - 15.f);
        [self addSubview:self.mPageControl];
    }
    
    return self;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture{
    
    CGFloat minY = (540.f / 812.f * self.height) + ([HelpTools iPhoneNotchScreen] ? 0 : 100.f);
    CGFloat maxY = (610.f / 812.f * self.height) + ([HelpTools iPhoneNotchScreen] ? 0 : 100.f);
    
    CGPoint touchPoint = [gesture locationInView:gesture.view];
    if(touchPoint.y >= minY &&
       touchPoint.y <= maxY){
        
        [self closeView];
    }
}

- (void)closeView{
    
    if(!self.isClose){
        
        [UIView animateWithDuration:0.35 animations:^{
            
            self.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            [HelpTools sharedAppSingleton].isShowedIntoductionView = YES;
        }];
    }
    
    self.isClose = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if((scrollView.contentSize.width / 3.f * 2.f - scrollView.contentOffset.x) < -30.f){
        
        [self closeView];
    }
    
    _curPageIndex = floor(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.mPageControl.currentPage = _curPageIndex;
}

#pragma mark - Getter

- (UIScrollView *)backScrollView{
    
    if(!_backScrollView){
        
        _backScrollView = [UIScrollView new];
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.pagingEnabled = YES;
        _backScrollView.scrollEnabled = YES;
        _backScrollView.delegate = self;
    }
    
    return _backScrollView;
}

- (UIPageControl *)mPageControl{
    
    if(!_mPageControl){
        
        _mPageControl = [UIPageControl new];
        _mPageControl.backgroundColor = [UIColor clearColor];
        _mPageControl.currentPageIndicatorTintColor = [UIColor eshopColor];
        _mPageControl.pageIndicatorTintColor = [UIColor mainBackColor];
        
        CGSize pageControlSize = [_mPageControl sizeForNumberOfPages:3];
        _mPageControl.frame = CGRectMake(0, 0, pageControlSize.width, 15.f);
        _mPageControl.numberOfPages = 3;
    }
    
    return _mPageControl;
}

@end
