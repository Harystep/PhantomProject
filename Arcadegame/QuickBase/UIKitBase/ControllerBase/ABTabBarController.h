//
//  ABTabBarController.h
//  KuaiDaiMarket
//
//  Created by Abner on 2019/3/29.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildVCData;

NS_ASSUME_NONNULL_BEGIN

@interface ABTabBarController : UITabBarController

- (instancetype)initWithChildVCArray:(NSArray <ChildVCData *> *)dataArray;

// 设置TabBar顶部分割线的颜色
- (void)setTopSeparateLineColor:(UIColor *)color;
// 设置Badge
- (void)setBadgeValue:(NSInteger)badgeValue forIndex:(NSInteger)index;

@end

/*
 *  ABTabBadgeView
 */
@interface ABTabBadgeView : UIView

@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, assign) NSInteger badgeValue;

@end

/*
 *  ChildVCData
 */
@interface ChildVCData : NSObject

@property (nonatomic, strong) NSString *className;

@property (nonatomic, strong) NSString *tabTitle;
@property (nonatomic, strong) NSString *tabImageNormal;
@property (nonatomic, strong) NSString *tabImageSelected;
@property (nonatomic, assign) BOOL shouldCloseAnimating;

+ (ChildVCData *)dataWithClassName:(NSString *)className
                          tabTitle:(NSString *)tabTitle
                    tabImageNormal:(NSString *)normalImageName
                  tabImageSelected:(NSString *)selectedImageName
              shouldCloseAnimating:(BOOL)shouldCloseAnimating;

@end

NS_ASSUME_NONNULL_END
