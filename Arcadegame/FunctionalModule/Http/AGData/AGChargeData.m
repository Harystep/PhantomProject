//
//  AGChargeData.m
//  Arcadegame
//
//  Created by Abner on 2023/7/20.
//

#import "AGChargeData.h"

@implementation AGChargeData

@end

/**
 * AGChargeOrderListData
 */
@implementation AGChargeOrderListData

@end

/**
 * AGChargeOrderListListData
 */
@implementation AGChargeOrderListListData

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"optionList":@"AGChargeOrderListOptionData"};
//    return @{@"optionList":@"AGChargeOrderListOptionData",
//             @"paySupport":@"AGChargeOrderListPaySupportData"};
}

@end

/**
 * AGChargeOrderListOptionData
 */
@implementation AGChargeOrderListOptionData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGChargeOrderListPaySupportData
 */
@implementation AGChargeOrderListPaySupportData

@end

/**
 * AGChargeIOSCreateOrderData
 */
@implementation AGChargeIOSCreateOrderData

@end

/**
 * AGChargeIOSCreateOrderDataData
 */
@implementation AGChargeIOSCreateOrderDataData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID": @"id"};
}

@end

/**
 * AGChargeAliCreateOrderData
 */
@implementation AGChargeAliCreateOrderData

@end
