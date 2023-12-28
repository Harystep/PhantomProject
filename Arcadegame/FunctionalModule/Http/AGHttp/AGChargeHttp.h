//
//  AGChargeHttp.h
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "BaseManage.h"
#import "AGChargeData.h"

NS_ASSUME_NONNULL_BEGIN

static const NSString *AG_CHARGE_LIST_URLAPI = @"/charge/list/channel/v3";
static const NSString *AG_CHARGE_ALIPAY_URLAPI = @"/charge/ali/buy/v2";
static const NSString *AG_CHARGE_IOSCREATEORDER_URLAPI = @"/charge/ios/create/order";
static const NSString *AG_CHARGE_IOSPAY_URLAPI = @"/charge/ios/pay/v3";

typedef NS_ENUM(NSInteger, AGChargeOrderListType) {
    
    kChargeOrderListType_Diamond = 1, // 钻石
    kChargeOrderListType_Gold = 2, // 金币
};

@interface AGChargeHttp : BaseManage

@end

/**
 * AGChargeOrderListHttp
 */
@interface AGChargeOrderListHttp : BaseManage

- (void)requestChargeOrderListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGChargeOrderListData *mBase;
@property (assign, nonatomic) AGChargeOrderListType orderType;

@end

/**
 * AGChargeAliPayHttp
 */
@interface AGChargeAliPayHttp : BaseManage

- (void)requestChargeAliPayResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGChargeAliCreateOrderData *mBase;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *returnUrl;

@end

/**
 * AGChargeIOSCreateOrderHttp
 */
@interface AGChargeIOSCreateOrderHttp : BaseManage

- (void)requestChargeIOSCreateOrderResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) AGChargeIOSCreateOrderData *mBase;
@property (strong, nonatomic) NSString *productId;

@end

/**
 * AGChargeIOSPayHttp
 */
@interface AGChargeIOSPayHttp : BaseManage

- (void)requestChargeIOSPayResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle;

@property (nonatomic, strong) NSData *mBase;
@property (strong, nonatomic) NSString *orderSn;
@property (strong, nonatomic) NSString *receipt;

@end

NS_ASSUME_NONNULL_END
