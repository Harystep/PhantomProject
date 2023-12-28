//
//  UIViewController+EmptyView.h
//  Interactive
//
//  Created by Abner on 2016/11/8.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (EmptyView)

- (void)replaseEmptyNotice:(NSString *)noticeString;
- (void)setEmptyView:(NSString *)noticeString;
- (void)removeEmptyView;

@end
