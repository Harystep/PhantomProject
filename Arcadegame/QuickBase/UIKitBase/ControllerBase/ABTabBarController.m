//
//  ABTabBarController.m
//  KuaiDaiMarket
//
//  Created by Abner on 2019/3/29.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABTabBarController.h"
#import "ABNavigationController.h"

const static NSInteger kABTabBadgeViewTag = 3000;

@interface ABTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *childVCArray;

@end

@implementation ABTabBarController

- (instancetype)initWithChildVCArray:(NSArray <ChildVCData *> *)dataArray{
    
    if(self = [super init]){
        
        self.childVCArray = dataArray.copy;
        [self addChildVC];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.tabBar.translucent = NO;

//    UITabBarAppearance *tabBarAppearance = [UITabBarAppearance new];
//    tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSFontAttributeName: [UIFont font10], NSForegroundColorAttributeName:UIColorFromRGB(0x333333)};
//    tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSFontAttributeName: [UIFont font10], NSForegroundColorAttributeName:UIColorFromRGB(0xEE2727)};
//    tabBarAppearance.backgroundColor = [UIColor blueColor];
//    tabBarAppearance.shadowColor = [UIColor blueColor];
//    tabBarAppearance.shadowImage = [HelpTools createImageWithColor:[UIColor clearColor] withRect:CGRectMake(0.f, 0.f, 2000.f, 10.f)];
//    tabBarAppearance.backgroundImage = [HelpTools createImageWithColor:[UIColor clearColor] withRect:CGRectMake(0.f, 0.f, 2000.f, 10.f)];
//
////    self.tabBar.shadowImage = [UIImage new];
////    self.tabBar.backgroundImage = [UIImage new];
//
//    self.tabBar.standardAppearance = tabBarAppearance;
//    if(@available(iOS 15.0, *)) {
//        self.tabBar.scrollEdgeAppearance = tabBarAppearance;
//    }
    
    UITabBarAppearance *apperance = self.tabBar.standardAppearance;
    [apperance configureWithTransparentBackground];
    self.tabBar.standardAppearance = apperance;
    
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBar.backgroundImage = [HelpTools createImageWithColor:[UIColor clearColor]];
    
    
    UIView *newBackView = [[UIView alloc] initWithFrame:CGRectMake(20.f, 0.f, self.view.width - 20.f * 2, kTabBarHeight)];
    newBackView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:newBackView.size colors:@[UIColorFromRGB(0x2F3750), UIColorFromRGB(0x1B212E)] gradientType:0]];
    newBackView.layer.cornerRadius = 18.f;
    
    [self.tabBar insertSubview:newBackView atIndex:1];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    UIViewController *willSelectedController = [self.childViewControllers objectAtIndexForSafe:selectedIndex];
    
    if(willSelectedController){
        
        if([willSelectedController isKindOfClass:[UINavigationController class]]){
            
            willSelectedController = [(UINavigationController *)willSelectedController topViewController];
        }
        
        if([willSelectedController respondsToSelector:NSSelectorFromString(@"setCloseAnimating:")]){
            
            [willSelectedController setValue:@(YES) forKey:@"closeAnimating"];
        }
    }
    
    [super setSelectedIndex:selectedIndex];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *navigationController = (UINavigationController *)viewController;

    NSString *className = NSStringFromClass([navigationController.topViewController class]);

    [self.childVCArray enumerateObjectsUsingBlock:^(ChildVCData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        if([obj.className isEqualToString:className]){

            if(obj.shouldCloseAnimating){

                 // 点击TabBarItem进入“首页”、"我的"控制器 会关闭导航栏消失的动画
                
                if([navigationController.topViewController respondsToSelector:NSSelectorFromString(@"setCloseAnimating:")]){
                    
                    [navigationController.topViewController setValue:@(YES) forKey:@"closeAnimating"];
                }
            }

            *stop = YES;
        }
    }];
    
    return YES;
}

#pragma mark -

- (void)addChildVC{
    
    for (ChildVCData *data in self.childVCArray ) {
        
        [self addChildViewController:[NSClassFromString(data.className) new] itemTitle:data.tabTitle image:data.tabImageNormal selectedImage:data.tabImageSelected];
    }
}

- (void)addChildViewController:(UIViewController *)childVC itemTitle:(NSString *)itemTitle image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    childVC.tabBarItem.title = itemTitle;
    //[childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor eshopColor], NSFontAttributeName: [UIFont font10]} forState:UIControlStateSelected];
    //[childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xEE2727), NSFontAttributeName: [UIFont font10]} forState:UIControlStateSelected];
    //[childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x333333), NSFontAttributeName: [UIFont font10]} forState:UIControlStateNormal];
    
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    ABNavigationController *nav = [[ABNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

#pragma mark -
- (void)setTopSeparateLineColor:(UIColor *)color{
    
    if(!color)  return;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, CGRectGetWidth(self.tabBar.frame), 0.5)];
    lineView.backgroundColor = color;
    [self.tabBar insertSubview:lineView atIndex:0];
}

- (void)setBadgeValue:(NSInteger)badgeValue forIndex:(NSInteger)index{
    
    UIView *lBadgeView = [self.tabBar viewWithTag:(kABTabBadgeViewTag + index)];
    if(badgeValue <= 0 &&
       lBadgeView){
        
        [lBadgeView removeFromSuperview];
    }
    else if(badgeValue > 0){
        
        CGRect itemRect = [self getTabBarItemFrameWithIndex:index];
        CGFloat baseBadgeOriginX = itemRect.origin.x + itemRect.size.width / 2.f + 6.f;
        
        if(!lBadgeView){
            
            ABTabBadgeView *badgeView = [ABTabBadgeView new];
            badgeView.tag = kABTabBadgeViewTag + index;
            badgeView.badgeValue = badgeValue;
            
            badgeView.origin = CGPointMake(baseBadgeOriginX, itemRect.origin.y + 4.f);
            [self.tabBar addSubview:badgeView];
        }
        else {
            
            [((ABTabBadgeView *)lBadgeView) setBadgeValue:badgeValue];
            ((ABTabBadgeView *)lBadgeView).origin = CGPointMake(baseBadgeOriginX, itemRect.origin.y + 4.f);
        }
    }
}

- (CGRect)getTabBarItemFrameWithIndex:(NSInteger)index{
    
    NSMutableArray *tabBarItems = [NSMutableArray array];
    for(UIView *view in self.tabBar.subviews){
        
        if([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]){
            
            [tabBarItems addObject:view];
        }
    }
    
    NSArray *sortedTabBarItems = [tabBarItems sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2){
        
        return [@(view1.frame.origin.x) compare:@(view2.frame.origin.x)];
    }];
    
    CGRect itemFrame = CGRectZero;
    UIView *view = [sortedTabBarItems objectAtIndexForSafe:index];
    if(view){
        
        itemFrame = view.frame;
    }
    
    return itemFrame;
}

@end

/*
 *  ABTabBadgeView
 */

@implementation ABTabBadgeView

- (instancetype)init{
    
    if(self = [super init]){
        
        self.frame = CGRectMake(0, 0, self.badgeLabel.font.lineHeight + 6.f, self.badgeLabel.font.lineHeight + 6.f);
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.f;
        self.layer.borderColor = [UIColorFromRGB(0xDD3B45) CGColor];
        
        [self addSubview:self.badgeLabel];
    }
    
    return self;
}

- (void)setBadgeValue:(NSInteger)badgeValue{
    _badgeValue = badgeValue;
    
    NSString *badgeString = [NSString stringWithFormat:@"%@", @(badgeValue)];
    
    if(badgeValue <= 0){
        
        badgeString = @"";
    }
    else if(badgeValue > 999){
        
        badgeString = @"999...";
    }
    
    self.badgeLabel.text = badgeString;
    [self.badgeLabel sizeToFit];
    
    CGRect selfRect = self.bounds;
    if(CGRectGetWidth(self.badgeLabel.frame) > (self.badgeLabel.font.lineHeight + 6.f)){
        
        selfRect.size.width = CGRectGetWidth(self.badgeLabel.frame) + 6.f;
    }
    else {
        
        selfRect = CGRectMake(0, 0, self.badgeLabel.font.lineHeight + 6.f, self.badgeLabel.font.lineHeight + 6.f);
    }
    
    self.frame = selfRect;
    self.badgeLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2.f, CGRectGetHeight(self.frame) / 2.f);
}

- (UILabel *)badgeLabel{
    
    if(!_badgeLabel){
        
        _badgeLabel = [UILabel new];
        _badgeLabel.font = [UIFont font10];
        _badgeLabel.textColor = UIColorFromRGB(0xDD3B45);
    }
    
    return _badgeLabel;
}

@end

/*
 *  ChildVCData
 */
@implementation ChildVCData

+ (ChildVCData *)dataWithClassName:(NSString *)className
                          tabTitle:(NSString *)tabTitle
                    tabImageNormal:(NSString *)normalImageName
                  tabImageSelected:(NSString *)selectedImageName
              shouldCloseAnimating:(BOOL)shouldCloseAnimating{
    
    ChildVCData *data = [ChildVCData new];
    data.className = className;
    data.tabTitle = tabTitle;
    data.tabImageNormal = normalImageName;
    data.tabImageSelected = selectedImageName;
    data.shouldCloseAnimating = shouldCloseAnimating;
    
    return data;
}



@end
