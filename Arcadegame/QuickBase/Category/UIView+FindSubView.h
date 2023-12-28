//
//  UIView+FindSubView.h
//  QuickBase
//
//  Created by Abner on 2019/9/20.
//  Copyright © 2019 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FindSubView)

- (UIView *)findSubview:(NSString *)name resursion:(BOOL)resursion;

@end

NS_ASSUME_NONNULL_END
