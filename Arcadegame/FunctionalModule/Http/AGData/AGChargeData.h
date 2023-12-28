//
//  AGChargeData.h
//  Arcadegame
//
//  Created by Abner on 2023/7/20.
//

#import "AGBaseData.h"

NS_ASSUME_NONNULL_BEGIN
@class AGChargeOrderListListData;
@class AGChargeIOSCreateOrderDataData;

@interface AGChargeData : NSObject

@end

/**
 * AGChargeOrderListData
 */
@interface AGChargeOrderListData : AGBaseData

@property (strong, nonatomic) AGChargeOrderListListData *data;

@end

/**
 * AGChargeOrderListListData
 */
@interface AGChargeOrderListListData : AGBaseData

@property (strong, nonatomic) NSArray *optionList;
//@property (strong, nonatomic) NSArray *paySupport;

@end

/**
 * AGChargeOrderListOptionData
 */
@interface AGChargeOrderListOptionData : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *iosOption;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *detail;
@property (strong, nonatomic) NSString *mark;
@property (strong, nonatomic) NSString *dayMoney;

@end

/**
 * AGChargeOrderListPaySupportData
 */
@interface AGChargeOrderListPaySupportData : NSObject

@property (strong, nonatomic) NSString *payMode;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *isCheck;

@end

/**
 * AGChargeIOSCreateOrderData
 */
@interface AGChargeIOSCreateOrderData : AGBaseData

@property (strong, nonatomic) AGChargeIOSCreateOrderDataData *data;

@end

/**
 * AGChargeIOSCreateOrderDataData
 */
@interface AGChargeIOSCreateOrderDataData : AGBaseData

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *money;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *buyType;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *orderSn;
@property (strong, nonatomic) NSString *optionId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *profitRate;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *invoiceStatus;

@end

/**
 * AGChargeAliCreateOrderData
 */
@interface AGChargeAliCreateOrderData : AGBaseData

@property (strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
