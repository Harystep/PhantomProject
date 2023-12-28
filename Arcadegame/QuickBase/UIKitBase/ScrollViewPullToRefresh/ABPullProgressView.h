//
//  ABPullProgressView.h
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import <UIKit/UIKit.h>
#import "ABProgressRefreshConfig.h"

@interface ABPullProgressView : UIView

@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign) double progress;
@property (nonatomic, assign) CGFloat originalTopInset;
@property (nonatomic, assign) ABProgressRefreshState state;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) void(^beginRefreshingHandle)(void);

- (instancetype)initWithFrame:(CGRect)frame
                  animateType:(ABProgressAnimateStyle)style
                  withObjects:(id)objects;

- (void)setProgress:(double)progress;

- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;
@end
