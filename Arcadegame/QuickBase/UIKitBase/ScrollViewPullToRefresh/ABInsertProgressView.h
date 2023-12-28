//
//  ABInsterProgressView.h
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import <UIKit/UIKit.h>
#import "ABProgressRefreshConfig.h"

@interface ABInsertProgressView : UIView

@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign) BOOL insertMore;
@property (nonatomic, assign) BOOL isScrollDecelerating;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat originalTopInset;
@property (nonatomic, assign) CGFloat originalBottomInset;
@property (nonatomic, assign) ABProgressRefreshState state;
@property (nonatomic, copy) void(^beginRefreshingHandle)(void);
@property (nonatomic, strong) NSString *moreInfoString;

- (void)stopIndicatorAnimation;

@end
