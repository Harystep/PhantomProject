//
//  AGGradientView.m
//  Arcadegame
//
//  Created by rrj on 2023/6/7.
//

#import "AGGradientView.h"

@implementation AGGradientView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors) {
        [array addObject:(id)color.CGColor];
    }
    
    self.gradientLayer.colors = array;
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    self.gradientLayer.locations = locations;
}

- (void)setStartPoint:(CGPoint)startPoint {
    self.gradientLayer.startPoint = startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint {
    self.gradientLayer.endPoint = endPoint;
}

@end
