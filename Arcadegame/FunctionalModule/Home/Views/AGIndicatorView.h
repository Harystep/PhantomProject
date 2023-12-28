//
//  AGIndicatorView.h
//  Arcadegame
//
//  Created by rrj on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGIndicatorView : UIView

- (instancetype)initWithCount:(NSUInteger)count;

@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSUInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
