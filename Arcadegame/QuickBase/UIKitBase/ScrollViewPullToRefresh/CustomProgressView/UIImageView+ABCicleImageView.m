//
//  UIImageView+ABCicleImageView.m
//
//  Created by Abner on 16/8/5.
//  Copyright © 2016年 Abner. All rights reserved.
//

#import "UIImageView+ABCicleImageView.h"

@implementation UIImageView (ABCicleImageView)

- (void)startCicleAnimation{
    
    self.alpha = 1.0;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 0.60;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatDuration = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopCicleAnimation{
    
    self.alpha = 0.0;
    [self.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)hidesWhenStopped{
    
    self.alpha = 0.0;
}

@end
