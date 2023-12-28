//
//  UIImageView+ABCicleImageView.h
//
//  Created by Abner on 16/8/5.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  ABCicleImageView
 */

@interface UIImageView (ABCicleImageView)

- (void)startCicleAnimation;
- (void)stopCicleAnimation;
- (void)hidesWhenStopped;

@end
