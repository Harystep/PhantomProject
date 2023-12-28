//
//  AGIAPManager.h
//  Arcadegame
//
//  Created by Abner on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    IAPPurchSuccess = 0,       // 购买成功
    IAPPurchFailed = 1,        // 购买失败
    IAPPurchCancel = 2,        // 取消购买
    IAPPurchVerIng = 3,        // 订单校验中
    IAPPurchVerFailed = 4,     // 订单校验失败
    IAPPurchVerSuccess = 5,    // 订单校验成功
    IAPPurchNotArrow = 6,      // 不允许内购
    IAPPurchNoProduct = 7,     // 没有商品
    IAPPurchProReqFail = 8,    //App Store中检索关于指定产品列表的本地化信息错误
    IAPPurchProReqSuc = 9,     //App Store中检索关于指定产品列表的本地化信息完成
    IAPPurchProNoRestored = 10, //消耗型不支持恢复购买"已经购买过商品"
}IAPPurchType;

typedef void (^IAPCompletionHandle)(IAPPurchType type, NSData *data, NSString *message);

@interface AGIAPManager : NSObject

+ (instancetype)shareIAPManager;
- (void)startPurchaseWithID:(NSString *)purchID withOwnOederSn:orderSn completeHandle:(IAPCompletionHandle)handle;

@end

NS_ASSUME_NONNULL_END
