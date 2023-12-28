//
//  AGRechargeViewController.h
//  Arcadegame
//
//  Created by Abner on 2023/7/19.
//

#import "BaseViewController.h"
#import "AGChargeHttp.h"
#import "AGMemberData.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGRechargeViewController : BaseViewController

@property (strong, nonatomic) AGMemberUserInfoData *mMUserInfoData;

@end

/**
 * AGRechargeHeadView
 */
@interface AGRechargeHeadView : UIView

@property (strong, nonatomic) AGMemberUserInfoData *mMUserInfoData;
@property (copy, nonatomic) void(^didSegSelectedHandle)(AGChargeOrderListType type);

@end

/**
 * AGRechargeHeadButton
 */
@interface AGRechargeHeadButton : UIControl

- (void)setImageName:(NSString *)icon value:(NSString *)value;

@end

/**
 * AGRechargeHeadLevelView
 */
@interface AGRechargeHeadLevelView : UIView

@property (assign, nonatomic) NSInteger level;

@end

/**
 * AGRechargeHeadSegmentView
 */
@interface AGRechargeHeadSegmentView : UIView

@property (copy, nonatomic) void(^didSelectedHandle)(AGChargeOrderListType type);

@end

NS_ASSUME_NONNULL_END
