//
//  AGIAPManager.m
//  Arcadegame
//
//  Created by Abner on 2023/7/21.
//

#import "AGIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "AGChargeHttp.h"

#import "AFNetworking.h"

@interface AGIAPManager() <SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property (strong, nonatomic) NSString *mOwnerOrderSn;
@property (strong, nonatomic) NSString *currentPurchasedID;
@property (copy, nonatomic) IAPCompletionHandle iAPCompletionHandle;

@property (strong, nonatomic) AGChargeIOSPayHttp *mCIOSPayHttp;
@property (assign, nonatomic) IAPPurchType mLastPurchType;

@end

@implementation AGIAPManager

+ (instancetype)shareIAPManager{
     
    static AGIAPManager *iAPManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        iAPManager = [[AGIAPManager alloc] init];
    });
    return iAPManager;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
 
- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)startPurchaseWithID:(NSString *)purchID withOwnOederSn:orderSn completeHandle:(IAPCompletionHandle)handle {
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            self.mOwnerOrderSn = orderSn;
            self.currentPurchasedID = purchID;
            self.iAPCompletionHandle = handle;
            
            //从App Store中检索关于指定产品列表的本地化信息
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }
        else{
            [self handleActionWithType:IAPPurchNotArrow data:nil];
        }
    }
}

- (void)handleActionWithType:(IAPPurchType)type data:(NSData *)data{
    
    NSString *message = @"";
    switch (type) {
        case IAPPurchSuccess:
            message = @"购买成功";
            DLOG(@"购买成功");
            break;
        case IAPPurchFailed:
            message = @"购买失败";
            DLOG(@"购买失败");
            break;
        case IAPPurchCancel:
            message = @"用户取消购买";
            DLOG(@"用户取消购买");
            break;
        case IAPPurchVerIng:
            message = @"订单校验中";
            DLOG(@"订单校验中");
            break;
        case IAPPurchVerFailed:
            message = @"订单校验失败";
            DLOG(@"订单校验失败");
            break;
        case IAPPurchVerSuccess:
            message = @"订单校验成功";
            DLOG(@"订单校验成功");
            break;
        case IAPPurchNotArrow:
            message = @"不允许程序内付费";
            DLOG(@"不允许程序内付费");
            break;
        case IAPPurchNoProduct:
            message = @"没有对应的商品";
            DLOG(@"没有对应的商品");
            break;
        case IAPPurchProReqFail:
            message = @"Store中商品本地化信息错误";
            DLOG(@"Store中商品本地化信息错误");
            break;
        case IAPPurchProReqSuc:
            message = @"请求完成";
            DLOG(@"请求完成");
            break;
        case IAPPurchProNoRestored:
            message = @"已经购买过商品";
            DLOG(@"已经购买过商品");
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.iAPCompletionHandle){
            self.iAPCompletionHandle(type, data, message);
        }
    });
}
 
- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction{
    //交易验证
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
     
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:IAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
    [self handleActionWithType:IAPPurchSuccess data:receipt];
     
    NSError *error;
    NSDictionary *requestContents = @{ @"receipt-data": [receipt base64EncodedStringWithOptions:0] };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
     
    if (!requestData) { // 交易凭证为空验证失败
        [self handleActionWithType:IAPPurchVerFailed data:nil];
        return;
    }
    
    [self requestWithReceipt:[receipt base64EncodedStringWithOptions:0]];
    //[self requestChargeIOSPayResultDataWithReceipt:[receipt base64EncodedStringWithOptions:0]];
    /*
    NSString *serverString = @"https:xxxx";
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
     
    [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            // 无法连接服务器,购买校验失败
            [self handleActionWithType:IAPPurchVerFailed data:nil];
        }
        else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 服务器校验数据返回为空校验失败
                [self handleActionWithType:IAPPurchVerFailed data:nil];
            }
             
            NSString *status = [NSString stringWithFormat:@"%@", jsonResponse[@"status"]];
            if(status && [status isEqualToString:@"0"]){
                [self handleActionWithType:IAPPurchVerSuccess data:nil];
            }
            else {
                [self handleActionWithType:IAPPurchVerFailed data:nil];
            }
            
            DLOG(@"----验证结果 %@", jsonResponse);
        }
    }];
     */
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
 
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
        
        self.mLastPurchType = IAPPurchNoProduct;
        [self handleActionWithType:IAPPurchNoProduct data:nil];
        DLOG(@"--------------没有商品------------------");
        return;
    }
     
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:self.currentPurchasedID]){
            p = pro;
            break;
        }
    }
    
    DLOG(@"productID:%@", response.invalidProductIdentifiers);
    DLOG(@"产品付费数量:%lu",(unsigned long)[product count]);
    DLOG(@"产品描述:%@",[p description]);
    DLOG(@"产品标题%@",[p localizedTitle]);
    DLOG(@"产品本地化描述%@",[p localizedDescription]);
    DLOG(@"产品价格：%@",[p price]);
    DLOG(@"产品productIdentifier：%@",[p productIdentifier]);
     
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
 
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    DLOG(@"------------------从App Store中检索关于指定产品列表的本地化信息错误-----------------:%@", error);
    [self handleActionWithType:IAPPurchProReqFail data:nil];
}
 
- (void)requestDidFinish:(SKRequest *)request{
    
    DLOG(@"------------requestDidFinish-----------------");
    if(IAPPurchNoProduct == self.mLastPurchType) {
        
        self.mLastPurchType = IAPPurchProReqSuc;
    }
    else {
        [self handleActionWithType:IAPPurchProReqSuc data:nil];
    }
}
 
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self verifyPurchaseWithPaymentTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                DLOG(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                DLOG(@"已经购买过商品");
                // 消耗型不支持恢复购买
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self handleActionWithType:IAPPurchProNoRestored data:nil];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
}

// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:IAPPurchFailed data:nil];
    }
    else {
        [self handleActionWithType:IAPPurchCancel data:nil];
    }
     
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - Request
- (void)requestChargeIOSPayResultDataWithReceipt:(NSString *)receipt {
    
    __WeakObject(self);
    self.mCIOSPayHttp.receipt = receipt;
    self.mCIOSPayHttp.orderSn = self.mOwnerOrderSn;
    
    [self.mCIOSPayHttp requestChargeIOSPayResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        
        if(isSuccess){
            [__strongObject handleActionWithType:IAPPurchVerSuccess data:nil];
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
            [__strongObject handleActionWithType:IAPPurchVerFailed data:nil];
        }
    }];
}

- (AGChargeIOSPayHttp *)mCIOSPayHttp {
    
    if(!_mCIOSPayHttp) {
        
        _mCIOSPayHttp = [AGChargeIOSPayHttp new];
    }
    
    return _mCIOSPayHttp;
}

#pragma mark - Request
- (void)requestWithReceipt:(NSString *)receipt {
    
    NSString *paramUrl = @"https://hyjjq-api.5iwanquan.com/api/charge/ios/pay/v3";
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *headers = @{@"accessToken": [NSString stringSafeChecking:[HelpTools userDataForToken]], @"channelKey": CHANNEL_KEY};
    
    [self handleActionWithType:IAPPurchVerIng data:nil];
    
    __WeakObject(self);
    NSURLSessionDataTask *task = [sessionManager POST:paramUrl parameters:nil headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFormData:[receipt dataUsingEncoding:NSUTF8StringEncoding] name:@"receipt"];
        [formData appendPartWithFormData:[[NSString stringSafeChecking:self.mOwnerOrderSn] dataUsingEncoding:NSUTF8StringEncoding] name:@"orderSn"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __WeakStrongObject();
        [__strongObject handleActionWithType:IAPPurchVerSuccess data:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __WeakStrongObject();
        [__strongObject handleActionWithType:IAPPurchVerFailed data:nil];
    }];
    [task resume];
}

@end
