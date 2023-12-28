//
//  AGRechargeView.h
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "ESPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class AGRechargeValueItem;

typedef NS_ENUM(NSInteger, AGRechargePayType) {
    
    kAGRechargePayType_Pay,
    kAGRechargePayType_Charge,
};

@interface AGRechargeView : ESPopBaseView

- (instancetype)initWithUserName:(NSString *)userName withValue:(AGRechargeValueItem *)valueItem;

@property (copy, nonatomic) void(^didPaySelectedHandle)(AGRechargePayType type, NSString *value);

@end

/**
 * AGRechargeInputView
 */
@interface AGRechargeInputView : UIView

@property (copy, nonatomic) void(^textFieldDidEndHandle)(void);

@property (assign, nonatomic) BOOL shouldEnable;
@property (strong, nonatomic) NSString *initialValue;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *placeholderString;
@property (strong, nonatomic, readonly) NSString *value;

- (void)clear;

@end

/**
 * AGRechargePayMethodView
 */
@interface AGRechargePayMethodView : UIView

@property (strong, nonatomic) NSString *remainingValue;

@end

/**
 * AGRechargeValueItem
 */
@interface AGRechargeValueItem : NSObject

@property (strong, nonatomic) NSString *diamond;
@property (strong, nonatomic) NSString *goldCoin;
@property (strong, nonatomic) NSString *Points;

@end

NS_ASSUME_NONNULL_END
