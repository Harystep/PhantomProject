//
//  AGCoinButton.h
//  Arcadegame
//
//  Created by Abner on 2023/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, kAGCoinButtonType) {
    AGCoinButtonTypePoint = 0,
    AGCoinButtonTypeGold = 1,
    AGCoinButtonTypeDiamond = 2
};

@interface AGCoinButton : UIControl

- (instancetype)initWithWealthType:(kAGCoinButtonType)wealthType;

@property (strong, nonatomic) NSString *value;

@end

NS_ASSUME_NONNULL_END
