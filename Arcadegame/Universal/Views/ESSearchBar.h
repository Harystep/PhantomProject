//
//  ESSearchBar.h
//  EShopClient
//
//  Created by Abner on 2019/6/13.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESSearchBar : UISearchBar

- (instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString *)placeholder tintColor:(UIColor *)tintColor isShowCancelButton:(BOOL)isShowCancelButton;

- (void)setPlaceholderLeft;

@property (strong, nonatomic) UIColor *textFieldTextColor;
@property (nonatomic, strong) UIColor *textFieldBackColor;
@property (strong, nonatomic) UIFont *textFieldTextFont;

@property (assign, nonatomic) CGFloat textFieldCornerRadius;

@end

NS_ASSUME_NONNULL_END
