//
//  AGRechargeViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/7/19.
//

#import "AGRechargeViewController.h"

#import "AGRechargeCardCollectionViewCell.h"
#import "AGRechargeCollectionViewCell.h"
#import "AGSegmentControl.h"
#import "AGCoinButton.h"
#import "AGIAPManager.h"
#import "AGMemberHttp.h"
//#import <SDRechargeWebViewController.h>

const static CGFloat kAGRechargeHeadSegHeight = 55.f;
const static CGFloat kAGRechargeHeadHeight = 218.f + kAGRechargeHeadSegHeight - 20.f;

@interface AGRechargeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *maskBackView;
@property (strong, nonatomic) AGRechargeHeadView *mHeadView;
@property (strong, nonatomic) UIView *mPurchaseNoticeView;
@property (strong, nonatomic) UICollectionView *mCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *mCollectionViewFlowLayout;

@property (strong, nonatomic) AGChargeIOSCreateOrderHttp *mCICIHttp;
@property (strong, nonatomic) AGChargeOrderListHttp *mCOLHttp;
@property (strong, nonatomic) AGMemberUserInfoHttp *mMUIHttp;
@property (strong, nonatomic) AGUserInfoHttp *mGlobalUIHttp;
@property (strong, nonatomic) AGChargeAliPayHttp *mCAPHttp;
@property (strong, nonatomic) AGIAPManager *mIAPManager;

@property (assign, nonatomic) AGChargeOrderListType mCurrentChargeType;

@end

@implementation AGRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"充值";
    
    self.mCollectionView.contentInset = UIEdgeInsetsMake(kAGRechargeHeadHeight, 0.f, 0.f, 0.f);
    [self.mCollectionView addSubview:self.mHeadView];
    
    [self.view addSubview:self.mCollectionView];
    [self.mCollectionView registerClass:[AGRechargeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AGRechargeCollectionViewCell class])];
    [self.mCollectionView registerClass:[AGRechargeCardCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AGRechargeCardCollectionViewCell class])];
    
    if(self.mMUserInfoData) {
        
        self.mHeadView.mMUserInfoData = self.mMUserInfoData;
    }
    [self requestGlobalUserInfoData];
    
    self.mCurrentChargeType = kChargeOrderListType_Diamond;
    [self requestChargeOrderListDataWithType:kChargeOrderListType_Diamond];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestMemberUserInfoData];
}

#pragma mark -
- (void)showPurchaseNoticeView {
    
    self.mPurchaseNoticeView.centerX = self.view.width / 2.f;
    self.mPurchaseNoticeView.top = self.view.height - 260.f - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f);
    
    if(![self.maskBackView isDescendantOfView:self.view]) {
        
        [self.view addSubview:self.maskBackView];
        self.maskBackView.alpha = 0.f;
        
        [UIView animateWithDuration:0.15f animations:^{
            
            self.maskBackView.alpha = 0.5f;
        }];
    }
    
    if(![self.mPurchaseNoticeView isDescendantOfView:self.view]) {
        
        [self.view addSubview:self.mPurchaseNoticeView];
    }
}

- (void)hidePurchaseNoticeView {
    
    [self.mPurchaseNoticeView removeFromSuperview];
    [self.maskBackView removeFromSuperview];
}

- (void)tapGestureRecognizerAction:(id)sender {
    
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(kChargeOrderListType_Gold == self.mCurrentChargeType) {
        
        AGChargeOrderListOptionData *data = [self.mCOLHttp.mBase.data.optionList objectAtIndexForSafe:indexPath.item];
        
        if(data && data.title &&
           ([data.title isEqualToString:@"周卡"] || [data.title isEqualToString:@"月卡"])) {
            //170 * 246
            CGFloat cellWidth = (collectionView.width - 12.f * 3) / 2.f;
            CGFloat cellHeight = cellWidth * 246.f / 170.f;
            return CGSizeMake(cellWidth, cellHeight);
        }
        
        //170 * 134+12
        CGFloat cellWidth = (collectionView.width - 12.f * 3) / 2.f;
        CGFloat cellHeight = cellWidth * 146.f / 170.f;
        return CGSizeMake(cellWidth, cellHeight);
    }
    
    //170 * 106+12
    CGFloat cellWidth = (collectionView.width - 12.f * 3) / 2.f;
    CGFloat cellHeight = cellWidth * 118.f / 170.f;
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.mCOLHttp.mBase.data.optionList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AGChargeOrderListOptionData *data = [self.mCOLHttp.mBase.data.optionList objectAtIndexForSafe:indexPath.item];
    
    if(kChargeOrderListType_Gold == self.mCurrentChargeType && data && data.title &&
       ([data.title isEqualToString:@"周卡"] || [data.title isEqualToString:@"月卡"])) {
        
        AGRechargeCardCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AGRechargeCardCollectionViewCell class]) forIndexPath:indexPath];
        
        collectionCell.data = data;
        
        __WeakObject(self);
        collectionCell.didPriceButtonSelectedHandle = ^(AGChargeOrderListOptionData * _Nonnull data) {
            __WeakStrongObject();
            
            [__strongObject gotoChargeWithData:data];
        };
        
        return collectionCell;
    }
    
    AGRechargeCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AGRechargeCollectionViewCell class]) forIndexPath:indexPath];
    
    collectionCell.type = self.mCurrentChargeType;
    collectionCell.data = data;
    
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AGChargeOrderListOptionData *data = [self.mCOLHttp.mBase.data.optionList objectAtIndexForSafe:indexPath.item];
    if(data && data.title &&
       ([data.title isEqualToString:@"周卡"] || [data.title isEqualToString:@"月卡"])) {
        
    }
    else {
        [self gotoChargeWithData:data];
    }
}

#pragma mark - GOTO
- (void)gotoChargeWithData:(AGChargeOrderListOptionData *)data {
    
    [self gotoApplePayWithData:data];
    
    /*
    __WeakObject(self);
    UIAlertController *alertPopVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if(self.mCOLHttp.mBase.data.paySupport.count) {
        
        for (AGChargeOrderListPaySupportData *paySupportData in self.mCOLHttp.mBase.data.paySupport) {
            
            [alertPopVC addAction:[UIAlertAction actionWithTitle:[NSString stringSafeChecking:paySupportData.title] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __WeakStrongObject();
                
                if(paySupportData.payMode.integerValue == 1) {
                    
                }
                else if(paySupportData.payMode.integerValue == 2) {
                    
                    [__strongObject gotoAliPayWithData:data];
                }
                else if(paySupportData.payMode.integerValue == 3) {
                    
                    [__strongObject gotoApplePayWithData:data];
                }
            }]];
        }
    }
    else {
        [alertPopVC addAction:[UIAlertAction actionWithTitle:@"APP 内购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __WeakStrongObject();
            
            [__strongObject gotoApplePayWithData:data];
        }]];
    }
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertPopVC animated:YES completion:nil];
     */
}

- (void)gotoApplePayWithData:(AGChargeOrderListOptionData *)data {
    
    if(data) {

        if([NSString isNotEmptyAndValid:data.iosOption]) {
            // iOS 内购
            
            __WeakObject(self);
            [self requestChargeCreateAppleOrderWithID:data.ID complete:^(NSString *orderSn) {
                __WeakStrongObject();
                
                if([NSString isNotEmptyAndValid:orderSn]) {
                    
                    [HelpTools showLoadingForView:__strongObject.view];
                    
                    [__strongObject.mIAPManager startPurchaseWithID:data.iosOption withOwnOederSn:orderSn completeHandle:^(IAPPurchType type, NSData * _Nonnull data, NSString * _Nonnull message) {
                        
                        if(IAPPurchProReqSuc == type) {
                            
                            [__strongObject showPurchaseNoticeView];
                        }
                        else {
                            [__strongObject hidePurchaseNoticeView];
                            [HelpTools showHUDOnlyWithText:message toView:__strongObject.view];
                        }
                        
                        if(IAPPurchVerSuccess == type) {
                            
                            [__strongObject requestMemberUserInfoData];
                        }
                        
                        [HelpTools hideLoadingForView:__strongObject.view];
                        if(IAPPurchVerIng == type) {
                            
                            [HelpTools showLoadingForView:__strongObject.view];
                        }
                    }];
                }
                else {
                    [HelpTools showHUDOnlyWithText:@"创建订单失败" toView:__strongObject.view];
                }
            }];
        }
        else {
            [HelpTools showHUDOnlyWithText:@"没有内购码" toView:self.view];
        }
    }
}

/*
- (void)gotoAliPayWithData:(AGChargeOrderListOptionData *)data {
    
    if(!data) return;
    
    NSString *productID = @"";
    if(data && data.title &&
       ([data.title isEqualToString:@"周卡"] || [data.title isEqualToString:@"月卡"])) {
        
        productID = [NSString stringWithFormat:@"card:%@", data.ID];
    }
    else {
        productID = [NSString stringWithFormat:@"option:%@", data.ID];
    }
    
    __WeakObject(self);
    [self requestChargeCreateAlipayOrderWithID:productID complete:^(NSString *data) {
        __WeakStrongObject();
                
        /*
         "<form name=\"punchout_form\" method=\"post\" action=\"https://openapi.alipay.com/gateway.do?charset=utf-8&method=alipay.trade.wap.pay&sign=QtEGIgHlGbvOrmimV%2B2ZKRIPgXe7Dl1KdJ3kFiH2G7%2FdxdvcqSfx1pX4ls6QU7eu6qgml%2ByKbR%2BjggiGhBUIJ7H1xCaoMY3xgBw21EDjyfr20m072iW4RCyPUCLb7bC6GoLm8MQlKLwuvRUvv%2F8bzfeHMsG9EVyYpSc%2BvJm7irAZ1N%2F72gNx9TgocG7Ccjseb1SYSAYj%2Bp5uAuYYr1%2BouiMfcrph2cRUN3zGA%2BD7h9IHzT4%2B8mIq%2BBE%2BjVRKFWtO9Fh1zgNLGxy6k0swPdMxbknAst%2BSRx1haFJIUZ%2F9sVJyu6SOGuqL0H8y6Ka8EKRLcKZRaMQkNHigdoU1sr0u1g%3D%3D&return_url=https%3A%2F%2Fapi.ssjww100.com%2Fwawaji&notify_url=https%3A%2F%2Fwwj-whn.yilaimi.cn%2Fapi%2Fpay%2Falipay%2Fnotify&version=1.0&app_id=2021003174673167&sign_type=RSA2&timestamp=2023-08-16+07%3A05%3A11&alipay_sdk=alipay-sdk-java-3.4.49.ALL&format=json\">\n<input type=\"hidden\" name=\"biz_content\" value=\"{ &quot;out_trade_no&quot;:&quot;230816070511000051&quot;, &quot;total_amount&quot;:&quot;6.00&quot;, &quot;subject&quot;:&quot;\U670d\U52a1\U8d39&quot;, &quot;product_code&quot;:&quot;QUICK_WAP_PAY&quot; }\">\n<input type=\"submit\" value=\"\U7acb\U5373\U652f\U4ed8\" style=\"display:none\" >\n</form>\n<script>document.forms[0].submit();</script>"
         
        if(([NSString isNotEmptyAndValid:data])) {
            
//            SDRechargeWebViewController * webViewController = [[SDRechargeWebViewController alloc] initWithData:data];
//            [__strongObject presentViewController:webViewController animated:true completion:nil];
            [HelpTools showHUDOnlyWithText:@"支付失败" toView:__strongObject.view];
        }
        else {
            [HelpTools showHUDOnlyWithText:@"创建订单失败" toView:__strongObject.view];
        }
    }];
}
*/

#pragma mark - Request
- (void)requestChargeOrderListDataWithType:(AGChargeOrderListType)type {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCOLHttp.orderType = type;
    [self.mCOLHttp requestChargeOrderListResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.mCollectionView reloadData];
        }
        else {
            __strongObject.mCOLHttp.mBase.data.optionList = @[];
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestChargeCreateAppleOrderWithID:(NSString *)option complete:(void(^)(NSString *orderSn))complete{
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCICIHttp.productId = option;
    [self.mCICIHttp requestChargeIOSCreateOrderResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if(complete) {
                
                complete(self.mCICIHttp.mBase.data.orderSn);
            }
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

/*
- (void)requestChargeCreateAlipayOrderWithID:(NSString *)productId complete:(void(^)(NSString *data))complete{
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCAPHttp.productId = productId;
    [self.mCAPHttp requestChargeAliPayResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if(complete) {
                
                complete(self.mCAPHttp.mBase.data);
            }
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}
 */

- (void)requestMemberUserInfoData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mMUIHttp requestMemberUserInfoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            __strongObject.mMUserInfoData = __strongObject.mMUIHttp.mBase;
            __strongObject.mHeadView.mMUserInfoData = __strongObject.mMUserInfoData;
        }
        else {
            if(!__strongObject.mMUIHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestGlobalUserInfoData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mGlobalUIHttp requestUserInfoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGChargeOrderListHttp *)mCOLHttp {
    
    if(!_mCOLHttp) {
        
        _mCOLHttp = [AGChargeOrderListHttp new];
    }
    
    return _mCOLHttp;
}

- (AGChargeIOSCreateOrderHttp *)mCICIHttp {
    
    if(!_mCICIHttp) {
        
        _mCICIHttp = [AGChargeIOSCreateOrderHttp new];
    }
    
    return _mCICIHttp;
}

- (AGMemberUserInfoHttp *)mMUIHttp {
    
    if(!_mMUIHttp) {
        
        _mMUIHttp = [AGMemberUserInfoHttp new];
    }
    
    return _mMUIHttp;
}

- (AGUserInfoHttp *)mGlobalUIHttp {
    
    if(!_mGlobalUIHttp) {
        
        _mGlobalUIHttp = [AGUserInfoHttp new];
    }
    
    return _mGlobalUIHttp;
}

- (AGChargeAliPayHttp *)mCAPHttp {
    
    if(!_mCAPHttp) {
        
        _mCAPHttp = [AGChargeAliPayHttp new];
    }
    
    return _mCAPHttp;
}

#pragma mark - Getter
- (UICollectionView *)mCollectionView{
    
    if(!_mCollectionView){
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.frame)) collectionViewLayout:self.mCollectionViewFlowLayout];
        
        _mCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mCollectionView.backgroundColor = [UIColor clearColor];
        _mCollectionView.showsVerticalScrollIndicator = NO;
        _mCollectionView.scrollsToTop = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){
            _mCollectionView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mCollectionView;
}

- (UICollectionViewFlowLayout *)mCollectionViewFlowLayout{
    
    if(!_mCollectionViewFlowLayout){
        
        _mCollectionViewFlowLayout = [UICollectionViewFlowLayout new];
        _mCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _mCollectionViewFlowLayout.minimumInteritemSpacing = 12.f;
        _mCollectionViewFlowLayout.minimumLineSpacing = 12.f;
    }
    
    return _mCollectionViewFlowLayout;
}

- (AGIAPManager *)mIAPManager {
    
    if(!_mIAPManager) {
        
        _mIAPManager = [AGIAPManager new];
    }
    
    return _mIAPManager;
}

- (UIView *)mPurchaseNoticeView {
    
    if(!_mPurchaseNoticeView) {
        
        _mPurchaseNoticeView = ({
            UIView *purchaseNoticeView = [UIView new];
            purchaseNoticeView.size = CGSizeMake([HelpTools getKeyWindow].width - 40.f * 2, 40.f);
            purchaseNoticeView.backgroundColor = UIColorFromRGB_ALPHA(0x000000, 0.6f);
            purchaseNoticeView.layer.cornerRadius = 10.f;
            
            UILabel *noticeLabel = [UILabel new];
            noticeLabel.backgroundColor = [UIColor clearColor];
            noticeLabel.textColor = [UIColor whiteColor];
            noticeLabel.text = @"订单创建中，请稍等... ...";
            noticeLabel.font = [UIFont font16];
            [noticeLabel sizeToFit];
            
            [purchaseNoticeView addSubview:noticeLabel];
            noticeLabel.center = CGPointMake(purchaseNoticeView.size.width / 2.f, purchaseNoticeView.size.height / 2.f);
            
            purchaseNoticeView;
        });
    }
    
    return _mPurchaseNoticeView;
}

- (UIView *)maskBackView{
    
    if(!_maskBackView){
        
        _maskBackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskBackView.backgroundColor = [UIColor blackColor];
        _maskBackView.alpha = 0.3f;
        
        _maskBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [_maskBackView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _maskBackView;
}

- (AGRechargeHeadView *)mHeadView {
    
    if(!_mHeadView) {
        
        _mHeadView = [[AGRechargeHeadView alloc] initWithFrame:CGRectMake(0.f, -kAGRechargeHeadHeight, self.mCollectionView.width, kAGRechargeHeadHeight)];
        
        __WeakObject(self);
        _mHeadView.didSegSelectedHandle = ^(AGChargeOrderListType type) {
            __WeakStrongObject();
            
            __strongObject.mCurrentChargeType = type;
            [__strongObject requestChargeOrderListDataWithType:type];
        };
    }
    
    return _mHeadView;
}

@end

/**
 * AGRechargeHeadView
 */
@interface AGRechargeHeadView ()

@property (strong, nonatomic) CarouselImageView *mIconImageView;
@property (strong, nonatomic) AGCoinButton *mDiamondButton;
@property (strong, nonatomic) AGCoinButton *mIntegralButton;
@property (strong, nonatomic) AGCoinButton *mGoldCoinButton;
@property (strong, nonatomic) AGRechargeHeadLevelView *mHeadLevelView;
@property (strong, nonatomic) AGRechargeHeadSegmentView *mHeadSegmentView;

@end

@implementation AGRechargeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mIconImageView];
        [self addSubview:self.mHeadLevelView];
        [self addSubview:self.mDiamondButton];
        [self addSubview:self.mGoldCoinButton];
        [self addSubview:self.mIntegralButton];
        [self addSubview:self.mHeadSegmentView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.mIconImageView.origin = CGPointMake(20.f, 12.f);
    
    self.mIntegralButton.hidden = YES;
    self.mIntegralButton.width = 0.f;
    
    self.mGoldCoinButton.hidden = YES;
    self.mGoldCoinButton.width = 0.f;
    
    self.mDiamondButton.left = self.mIconImageView.right + 10.f;
    self.mGoldCoinButton.left = self.mDiamondButton.right + 10.f;
    self.mIntegralButton.left = self.mGoldCoinButton.right + 10.f;
    
    self.mDiamondButton.centerY = self.mGoldCoinButton.centerY = self.mIntegralButton.centerY = self.mIconImageView.centerY;
    
    self.mHeadLevelView.top = self.mIconImageView.bottom + 20.f;
    self.mHeadSegmentView.frame = CGRectMake(0.f, self.height - kAGRechargeHeadSegHeight - 20.f, self.width, kAGRechargeHeadSegHeight);
}

- (void)setMMUserInfoData:(AGMemberUserInfoData *)mMUserInfoData {
    _mMUserInfoData = mMUserInfoData;
    
    [self.mIconImageView setImageWithObject:[NSString stringSafeChecking:mMUserInfoData.data.member.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mHeadLevelView.level = [mMUserInfoData.data.member.level integerValue];
    [self.mDiamondButton setValue:[HelpTools checkNumberInfo:mMUserInfoData.data.member.money]];
    [self.mGoldCoinButton setValue:[HelpTools checkNumberInfo:mMUserInfoData.data.member.goldCoin]];
    
    //[self.mDiamondButton setImageName:@"" value:mMUserInfoData.data.member.money];
    //[self.mGoldCoinButton setImageName:@"game_head_btn_gold" value:mMUserInfoData.data.member.goldCoin];
    //[self.mIntegralButton setImageName:@"game_head_btn_glory" value:mMUserInfoData.data.member.points];
    
    self.mGoldCoinButton.left = self.mDiamondButton.right + 10.f;
    self.mIntegralButton.left = self.mGoldCoinButton.right + 10.f;
}

#pragma mark - Getter
- (CarouselImageView *)mIconImageView {
    
    if(!_mIconImageView) {
        
        _mIconImageView = [CarouselImageView new];
        _mIconImageView.size = CGSizeMake(46.f, 46.f);
        _mIconImageView.userInteractionEnabled = YES;
        _mIconImageView.clipsToBounds = YES;
        _mIconImageView.ignoreCache = YES;
        
        _mIconImageView.layer.cornerRadius = _mIconImageView.height / 2.f;
    }
    
    return _mIconImageView;
}

- (AGRechargeHeadLevelView *)mHeadLevelView {
    
    if(!_mHeadLevelView) {
        
        _mHeadLevelView = [[AGRechargeHeadLevelView alloc] initWithFrame:self.bounds];
    }
    
    return _mHeadLevelView;
}

- (AGCoinButton *)mDiamondButton {
    
    if(!_mDiamondButton) {
        
        _mDiamondButton = [[AGCoinButton alloc] initWithWealthType:AGCoinButtonTypeDiamond];
    }
    
    return _mDiamondButton;
}

- (AGCoinButton *)mIntegralButton {
    
    if(!_mIntegralButton) {
        
        _mIntegralButton = [[AGCoinButton alloc] initWithWealthType:AGCoinButtonTypePoint];
    }
    
    return _mIntegralButton;
}

- (AGCoinButton *)mGoldCoinButton {
    
    if(!_mGoldCoinButton) {
        
        _mGoldCoinButton = [[AGCoinButton alloc] initWithWealthType:AGCoinButtonTypeGold];
    }
    
    return _mGoldCoinButton;
}

- (AGRechargeHeadSegmentView *)mHeadSegmentView {
    
    if(!_mHeadSegmentView) {
        
        _mHeadSegmentView = [AGRechargeHeadSegmentView new];
        
        __WeakObject(self);
        _mHeadSegmentView.didSelectedHandle = ^(AGChargeOrderListType type) {
            __WeakStrongObject();
            
            if(__strongObject.didSegSelectedHandle) {
                
                __strongObject.didSegSelectedHandle(type);
            }
        };
    }
    
    return _mHeadSegmentView;
}

@end

/**
 * AGRechargeHeadButton
 */
@interface AGRechargeHeadButton ()

@property (strong, nonatomic) UIImageView *mBackImageView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *valueLabel;

@end

@implementation AGRechargeHeadButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self addSubview:self.mBackImageView];
        [self.mBackImageView addSubview:self.valueLabel];
        [self.mBackImageView addSubview:self.iconImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mBackImageView.frame = self.bounds;
    
    self.iconImageView.left = 3.f;
    self.valueLabel.left = self.iconImageView.right + 2.f;
    self.valueLabel.width = self.width - self.valueLabel.left - 2.f;
    
    self.iconImageView.centerY = self.valueLabel.centerY = self.mBackImageView.height / 2.f - 2.f;
}

- (void)setImageName:(NSString *)icon value:(NSString *)value {
    
    if([NSString isNotEmptyAndValid:icon]) {
        
        self.iconImageView.image = IMAGE_NAMED(icon);
    }
    else {
        self.iconImageView.image = IMAGE_NAMED(@"game_head_btn_gem");
    }
    
    self.valueLabel.text = [HelpTools checkNumberInfo:value];
}

#pragma mark - Getter
- (UIImageView *)mBackImageView {
    
    if(!_mBackImageView) {
        
        _mBackImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_head_btn_back")];
    }
    
    return _mBackImageView;
}

- (UIImageView *)iconImageView {
    
    if(!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_head_btn_gem")];
    }
    
    return _iconImageView;
}

- (UILabel *)valueLabel {
    
    if(!_valueLabel) {
        
        _valueLabel = [UILabel new];
        
        _valueLabel.font = [UIFont fontWithName:@"Alfa Slab One" size:15];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = UIColorFromRGB(0x692626);
        _valueLabel.height = _valueLabel.font.lineHeight;
    }
    
    return _valueLabel;
}

@end

/**
 * AGRechargeHeadLevelView
 */
@interface AGRechargeHeadLevelView ()

@property (strong, nonatomic) UIImageView *mLevelImageView;
@property (strong, nonatomic) UIImageView *mBackImageView;
@property (strong, nonatomic) UILabel *mStaticLabel;

@end

@implementation AGRechargeHeadLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self addSubview:self.mBackImageView];
        [self.mBackImageView addSubview:self.mStaticLabel];
        [self.mBackImageView addSubview:self.mLevelImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImage *backImage = IMAGE_NAMED(@"user_level_back_1");
    
    CGFloat backWidth = CGRectGetWidth(self.frame) - 20.f * 2;
    CGFloat backHeight = backWidth * (backImage.size.height / backImage.size.width);
    self.mBackImageView.frame = CGRectMake(20.f, 0.f, backWidth, backHeight);
    self.mBackImageView.image = backImage;
    
    self.mStaticLabel.origin = CGPointMake(20.f, 12.f);
    self.mLevelImageView.left = self.mStaticLabel.right + 5.f;
    self.mLevelImageView.centerY = self.mStaticLabel.centerY;
    
    self.height = backHeight;
}

- (void)setLevel:(NSInteger)level {
    _level = level;
    
    self.mBackImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_back_%@", @(level)]];
    
    self.mLevelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", @(level)]];
}

#pragma mark - Getter
- (UIImageView *)mBackImageView {
    
    if(!_mBackImageView) {
        
        _mBackImageView = [UIImageView new];
    }
    
    return _mBackImageView;
}

- (UIImageView *)mLevelImageView {
    
    if(!_mLevelImageView) {
        
        _mLevelImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"user_level_1")];
    }
    
    return _mLevelImageView;
}

- (UILabel *)mStaticLabel {
    
    if(!_mStaticLabel) {
        
        _mStaticLabel = [UILabel new];
        _mStaticLabel.font = [UIFont font15];
        _mStaticLabel.textColor = UIColorFromRGB(0x692626);
        _mStaticLabel.height = _mStaticLabel.font.lineHeight;
        
        _mStaticLabel.text = @"当前等级";
        [_mStaticLabel sizeToFit];
    }
    
    return _mStaticLabel;
}

@end

/**
 * AGRechargeHeadSegmentView
 */
@interface AGRechargeHeadSegmentView ()

@property (strong, nonatomic) AGSegmentControl *mSeg;
@property (strong, nonatomic) UIView *mBackContainerView;

@end

@implementation AGRechargeHeadSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        __WeakObject(self);
        self.mSeg = [[AGSegmentControl alloc] initWithSegments:@[[[AGSegmentItem alloc] initWithTitle:@"钻石" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
            __WeakStrongObject();
            
            if(__strongObject.didSelectedHandle) {
                
                __strongObject.didSelectedHandle(kChargeOrderListType_Diamond);
            }
        }]] style:AGSegmentControlStyleColorful];
        /*
         [[AGSegmentItem alloc] initWithTitle:@"金币" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
             __WeakStrongObject();
             
             if(__strongObject.didSelectedHandle) {
                 
                 __strongObject.didSelectedHandle(kChargeOrderListType_Gold);
             }
         }],
         */
        
        [self addSubview:self.mBackContainerView];
        [self addSubview:self.mSeg];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mSeg.frame = CGRectMake((self.width - 160.f) / 2.f, 0.f, 160.f, self.height);
    
    self.mBackContainerView.frame = self.bounds;
    if(!self.mBackContainerView.backgroundColor) {
        
        self.mBackContainerView.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mBackContainerView.size colors:@[UIColorFromRGB(0x242B3F), UIColorFromRGB(0x293146)] gradientType:0]];
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(20.f, 20.f) forView:self.mBackContainerView];
    }
}

- (UIView *)mBackContainerView {
    
    if(!_mBackContainerView) {
        
        _mBackContainerView = [UIView new];
        _mBackContainerView.backgroundColor = nil;
    }
    
    return _mBackContainerView;
}

@end
