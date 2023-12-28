//
//  AGWealthButton.h
//  Arcadegame
//
//  Created by rrj on 2023/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AGWealthButtonType) {
    AGWealthButtonTypePoint = 0,
    AGWealthButtonTypeGold = 1,
    AGWealthButtonTypeDiamond = 2
};

@interface AGWealthButton : UIControl

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithWealthType:(AGWealthButtonType)wealthType;

- (void)setAmount:(NSString *)amount;

@end

NS_ASSUME_NONNULL_END
