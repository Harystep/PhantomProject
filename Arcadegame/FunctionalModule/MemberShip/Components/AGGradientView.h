//
//  AGGradientView.h
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGGradientView : UIView

@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, copy) NSArray<NSNumber *> *locations;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;

@end

NS_ASSUME_NONNULL_END
