//
//  AGChargeHttp.m
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "AGChargeHttp.h"

@implementation AGChargeHttp

@end

/**
 * AGChargeOrderListHttp
 */
@implementation AGChargeOrderListHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?type=%@", AG_CHARGE_LIST_URLAPI, @(self.orderType)];
}

#pragma mark -
- (BOOL)isPost{
    return false;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestChargeOrderListResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGChargeOrderListData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGChargeAliPayHttp
 */
@implementation AGChargeAliPayHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?productId=%@", AG_CHARGE_ALIPAY_URLAPI, [NSString stringSafeChecking:self.productId]];
    //&returnUrl=%@
    //[NSString stringSafeChecking:self.returnUrl]
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestChargeAliPayResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGChargeAliCreateOrderData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGChargeIOSCreateOrderHttp
 */
@implementation AGChargeIOSCreateOrderHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{};
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@?productId=option:%@", AG_CHARGE_IOSCREATEORDER_URLAPI, [NSString stringSafeChecking:self.productId]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestChargeIOSCreateOrderResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [AGChargeIOSCreateOrderData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end

/**
 * AGChargeIOSPayHttp
 */
@implementation AGChargeIOSPayHttp

#pragma mark -
- (NSDictionary *)getUrlParam{
    NSDictionary *paramDic = @{@"orderSn": [NSString stringSafeChecking:self.orderSn],
                               @"receipt": [NSString stringSafeChecking:self.receipt]
    };
    return paramDic;
}

#pragma mark -
- (NSString *)getUrl{
    return [NSString stringWithFormat:@"%@", AG_CHARGE_IOSPAY_URLAPI];
    //[NSString stringWithFormat:@"%@?orderSn=%@&receipt=%@", AG_CHARGE_IOSPAY_URLAPI, [NSString stringSafeChecking:self.orderSn], [NSString stringSafeChecking:self.receipt]];
}

#pragma mark -
- (BOOL)isPost{
    return true;
}

#pragma mark -
- (BOOL)isCache{
    return false;
}

- (void)requestChargeIOSPayResultHandle:(void (^)(BOOL isSuccess, id responseObject))handle{
    
    [self requestResultHandle:^(BOOL isSuccess, id responseObject) {
        if(isSuccess){
            self.mBase = [NSData mj_objectWithKeyValues:responseObject];
        }
        if(handle){
            handle(isSuccess, responseObject);
        }
    }];
}

@end
