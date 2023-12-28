//
//  AGHomePostDetailViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/24.
//

#import "AGHomePostDetailViewController.h"
#import "AGFuncMoreReportViewController.h"
#import "AGHomePostDetailTableViewCell.h"
#import "AGHomePostDetailBottomView.h"
#import "AGRechargeViewController.h"
#import "AGUserHomeViewController.h"
#import "CarouselPictureView.h"
#import "AGAlertSheetPopView.h"

#import "AGCircleFunctionHttp.h"
#import "AGCircleCommentHttp.h"
#import "AGCircleMemberHttp.h"
#import "AGCircleHttp.h"
#import "AGMemberHttp.h"

#import "AGRechargeView.h"

static const NSInteger kHPDTableStaticCount = 5;
static const CGFloat kHPDTableOffsetHeight = 20.f;

@interface AGHomePostDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UIView *mTableContainerView;
@property (strong, nonatomic) CarouselPictureView *mHeadBackImageView;
@property (strong, nonatomic) AGHomePostDetailBottomView *mHPDBottomView;

@property (strong, nonatomic) AGMemberUserInfoHttp *mMUIHttp;

@property (strong, nonatomic) AGCircleLikeHttp *mCLHttp;
@property (strong, nonatomic) AGCircleDetailHttp *mCDHttp;

@property (strong, nonatomic) AGMemberRewardHttp *mMRHttp;
@property (strong, nonatomic) AGCircleREPORTHttp *mCRHttp;
@property (strong, nonatomic) AGCircleMemberFollowHttp *mCMFHttp;
@property (strong, nonatomic) AGCircleMemberUnFollowHttp *mCMUFHttp;

@property (strong, nonatomic) AGCircleCommentUpHttp *mCCUHttp;
@property (strong, nonatomic) AGCircleCommentListHttp *mCCLHttp;
@property (strong, nonatomic) AGCircleMemberBlackUserHttp *mCMBUHttp;

@end

@implementation AGHomePostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = [NSString stringSafeChecking:self.postTitle];
    
    //self.mHeadBackImageView.size = CGSizeMake(self.view.width, 299.f / 375.f * self.view.width);
    
    [self.view addSubview:self.mHPDBottomView];
    
    //[self.view addSubview:self.mTableContainerView];
    //[HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(kHPDTableOffsetHeight, kHPDTableOffsetHeight) forView:self.mTableContainerView];
    
    [self.mTableView addSubview:self.mHeadBackImageView];
    self.mTableView.contentInset = UIEdgeInsetsMake((CGRectGetHeight(self.mHeadBackImageView.frame)) - kHPDTableOffsetHeight, 0.f, 0.f, 0.f);
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableHeadViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableHeadViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableContentViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableContentViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableRewardViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableRewardViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableFunctionViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableFunctionViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableCommentViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableCommentViewCell class])];
    [self.mTableView registerClass:[AGHomePostDetailTableCommentHeadViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostDetailTableCommentHeadViewCell class])];
    
    [self addClickCloseKeyboardForObserver:self.mTableView];
    
    [self requestCircleDetailData];
    [self requestCircleCommentListData];
    
    [self.mAGNavigateView bringToFront];
}

#pragma mark -
- (void)reloadPostDetailData {
    
    if(self.mCDHttp.mBase) {
        
        NSArray *mediaArray = [[NSString stringSafeChecking:self.mCDHttp.mBase.data.media] componentsSeparatedByString:@";"];
        if(!mediaArray || !mediaArray.count) {
            
            if([NSString isNotEmptyAndValid:self.mCDHttp.mBase.data.media]) {
                
                mediaArray = @[self.mCDHttp.mBase.data.media];
            }
        }
        mediaArray = [NSArray filterEmptyStringFromArray:mediaArray];
        
        [self.mHeadBackImageView setPictureData:mediaArray];
        
        [self.mTableView reloadData];
    }
}

- (void)reloadPostCommentListData {
    
    [self.mTableView reloadData];
}

- (void)reloadFollowStatus:(BOOL)isFollowed {
    
    self.mCDHttp.mBase.data.hasFocus = (isFollowed ? 1 : 0);
    //[self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadLikeStatus:(BOOL)isLiked {
    
    self.mCDHttp.mBase.data.hasLike = (isLiked ? 1 : 0);
    self.mCDHttp.mBase.data.likeNum = [HelpTools checkNumberInfo:self.mCDHttp.mBase.data.likeNum plus:1];
    [self.mTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - GOTO
- (void)gotoUserHomeVCWithMemberID:(NSString *)memberID {
    
    AGUserHomeViewController *AGUHVC = [AGUserHomeViewController new];
    AGUHVC.memberId = memberID;
    
    [self.navigationController pushViewController:AGUHVC animated:YES];
}

- (void)gotoMoreFunctionVC {
    
    AGFuncMoreReportViewController *AGFMRVC = [AGFuncMoreReportViewController new];
    AGFMRVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:AGFMRVC animated:YES completion:nil];
    
    __WeakObject(self);
    AGFMRVC.didSelectedReportHandle = ^(NSString * _Nonnull reson) {
        __WeakStrongObject();
        
        [__strongObject requestCircleREPORTDataWithContent:reson];
    };
}

- (void)gotoMemberFunctionAlertWithID:(NSString *)memberID hasFollow:(BOOL)hasFollow isFollowed:(BOOL)isFollowed {
    
    __WeakObject(self);
    UIAlertController *alertPopVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIView *subView = alertPopVC.view.subviews.firstObject;
    if(subView) {
        
        UIView *subSubView = subView.subviews.firstObject;
        if(subSubView) subSubView.backgroundColor = UIColorFromRGB(0x262D42);
    }
    
    if(hasFollow) {
        
        NSString *alertString = isFollowed ? @"取消关注" : @"关注";
        [alertPopVC addAction:[UIAlertAction actionWithTitle:alertString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __WeakStrongObject();
            
            if(isFollowed) {
                
                [__strongObject requestCircleMemberUnFollowDataWithMemberID:memberID];
            }
            else {
                [__strongObject requestCircleMemberFollowDataWithMemberID:memberID];
            }
        }]];
    }
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __WeakStrongObject();
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"拉黑账号您的关注也会同步取消关联！请确认！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [__strongObject requestMemberBlackUserDataWithMemberID:memberID];
        }]];
        [__strongObject presentViewController:alert animated:YES completion:nil];
    }]];
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __WeakStrongObject();
        
        [__strongObject gotoMoreFunctionVC];
    }]];
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertPopVC animated:YES completion:nil];
}

- (void)gotoRewardChargeCheck {
    
    [self requestMemberUserInfoData];
}

- (void)gotoRewardViewWithData:(AGMemberUserInfoData *)data {
    
    AGRechargeValueItem *item = [AGRechargeValueItem new];
    item.goldCoin = data.data.member.goldCoin;
    item.diamond = data.data.member.money;
    item.Points = data.data.member.points;
    
    AGRechargeView *rechargeView = [[AGRechargeView alloc] initWithUserName:self.mCDHttp.mBase.data.memberBaseDto.nickname withValue:item];
    [rechargeView show];
    
    __WeakObject(self);
    __weak __typeof(rechargeView)__weakRechargeView = rechargeView;
    rechargeView.didPaySelectedHandle = ^(AGRechargePayType type, NSString * _Nonnull value) {
        __WeakStrongObject();
        
        if(kAGRechargePayType_Charge == type) {
            
            [__strongObject gotoRechargeViewWithData:data];
            [__weakRechargeView hide];
        }
        else {
            
            [__strongObject requestMemberRewardDataWithDiamond:value resultHandle:^{
                
                [__weakRechargeView hide];
            }];
            /*
            [HelpTools showLoadingForView:__strongObject.view.window];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [__weakRechargeView hide];
                [HelpTools hideLoadingForView:__strongObject.view.window];
                [HelpTools showHUDOnlyWithText:@"稍后会从您的余额中扣除" toView:__strongObject.view.window];
            });
             */
        }
    };
}

- (void)gotoRechargeViewWithData:(AGMemberUserInfoData *)data {
    
    AGRechargeViewController *rechargeVC = [AGRechargeViewController new];
    rechargeVC.mMUserInfoData = data;
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return kHPDTableStaticCount + self.mCCLHttp.mBase.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        
        return 87.f;
    }
    else if(indexPath.row == 1) {
        
        return [AGHomePostDetailTableContentViewCell getAGCircleCategoryTableViewCellHeight:self.mCDHttp.mBase.data.content withContainerWidth:tableView.width withIndex:indexPath];
    }
    else if(indexPath.row == 2) {
        
        return 60.f;
    }
    else if(indexPath.row == 3) {
        
        return 160.f;
    }
    else if(indexPath.row == 4) {
        
        return 40.f;
    }
    
    return [AGHomePostDetailTableCommentViewCell getAGHomePostDetailTableCommentCellHeight:self.mCCLHttp.mBase.data[indexPath.row - kHPDTableStaticCount] withContainerWidth:tableView.width withIndex:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        
        AGHomePostDetailTableHeadViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableHeadViewCell class]) forIndexPath:indexPath];
        tableCell.backgroundColor = UIColorFromRGB(0x151A28);
        
        tableCell.data = self.mCDHttp.mBase.data;
        
        __WeakObject(self);
        tableCell.didFollowSelectedHandle = ^(BOOL isFollowed) {
            __WeakStrongObject();
            
            [__strongObject gotoMemberFunctionAlertWithID:__strongObject.mCDHttp.mBase.data.memberBaseDto.memberId hasFollow:YES isFollowed:isFollowed];
        };
        
        tableCell.didHeadIconSelectedHandle = ^{
            __WeakStrongObject();
            
            [__strongObject gotoUserHomeVCWithMemberID:self.mCDHttp.mBase.data.memberId];
        };
        
        return tableCell;
    }
    else if(indexPath.row == 1) {
        
        AGHomePostDetailTableContentViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableContentViewCell class]) forIndexPath:indexPath];
        tableCell.backgroundColor = UIColorFromRGB(0x151A28);
        tableCell.data = self.mCDHttp.mBase.data.content;
        
        return tableCell;
    }
    else if(indexPath.row == 2) {
        
        AGHomePostDetailTableRewardViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableRewardViewCell class]) forIndexPath:indexPath];
        tableCell.backgroundColor = UIColorFromRGB(0x151A28);
        
        __WeakObject(self);
        tableCell.didSelectedRewardHandle = ^{
            __WeakStrongObject();
            
            [__strongObject gotoRewardChargeCheck];
        };
        
        return tableCell;
    }
    else if(indexPath.row == 3) {
        
        AGHomePostDetailTableFunctionViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableFunctionViewCell class]) forIndexPath:indexPath];
        tableCell.data = self.mCDHttp.mBase.data;
        tableCell.backgroundColor = UIColorFromRGB(0x151A28);
        
        __WeakObject(self);
        tableCell.didLikeSelectedHandle = ^(BOOL isLiked) {
            __WeakStrongObject();
            
            if(!isLiked) {
                
                [__strongObject requestCircleLikeData];
            }
        };
        
        tableCell.didMoreSelectedHandle = ^{
            __WeakStrongObject();
            
            [__strongObject gotoMoreFunctionVC];
        };
        
        return tableCell;
    }
    else if(indexPath.row == 4) {
        
        AGHomePostDetailTableCommentHeadViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableCommentHeadViewCell class]) forIndexPath:indexPath];
        tableCell.backgroundColor = UIColorFromRGB(0x151A28);
        tableCell.data = self.mCDHttp.mBase.data.commentNum;
        
        return tableCell;
    }
    
    AGHomePostDetailTableCommentViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostDetailTableCommentViewCell class]) forIndexPath:indexPath];
    tableCell.backgroundColor = UIColorFromRGB(0x151A28);
    tableCell.data = self.mCCLHttp.mBase.data[indexPath.row - kHPDTableStaticCount];
    
    __WeakObject(self);
    tableCell.didHeadIconSelectedHandle = ^(AGCircleCommentData * _Nonnull data) {
        __WeakStrongObject();
        
        [__strongObject gotoUserHomeVCWithMemberID:data.memberBaseDto.memberId];
    };
    
    tableCell.didComplainButtonSelectedHandle = ^(AGCircleCommentData * _Nonnull data) {
        __WeakStrongObject();
        
        [__strongObject gotoMemberFunctionAlertWithID:data.memberBaseDto.memberId hasFollow:NO isFollowed:NO];
    };
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.mHeadBackImageView sendToBack];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Request
- (void)requestCircleDetailData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCDHttp.dynamicId = self.postDynamicId;
    [self.mCDHttp requestCircleDetailDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadPostDetailData];
        }
        else {
            if(!__strongObject.mCDHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleCommentListData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCCLHttp.dynamicId = self.postDynamicId;
    [self.mCCLHttp requestCircleCommentListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadPostCommentListData];
        }
        else {
            if(!__strongObject.mCCLHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleCommentUpData {
    
    NSString *content = self.mHPDBottomView.inputContent;
    
    if(![NSString isNotEmptyAndValid:content]) {
        
        [HelpTools showHUDOnlyWithText:@"请输入内容" toView:self.view];
        return;
    }
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCCUHttp.content = content;
    self.mCCUHttp.dynamicId = self.postDynamicId;
    [self.mCCUHttp requestCircleCommentUpDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"评论成功" toView:__strongObject.view];
            [__strongObject.mHPDBottomView cleanContent];
            [__strongObject hideKeyBoard];
            
            [__strongObject requestCircleCommentListData];
        }
        else {
            if(!__strongObject.mCCUHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleMemberFollowDataWithMemberID:(NSString *)memberID {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMFHttp.memberId = self.mCDHttp.mBase.data.memberBaseDto.memberId;
    [self.mCMFHttp requestCircleMemberFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            [__strongObject reloadFollowStatus:YES];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleMemberUnFollowDataWithMemberID:(NSString *)memberID {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMUFHttp.memberId = self.mCDHttp.mBase.data.memberBaseDto.memberId;
    [self.mCMUFHttp requestCircleMemberUnFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadFollowStatus:NO];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleLikeData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCLHttp.dynamicId = self.postDynamicId;
    [self.mCLHttp requestCircleLikeDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadLikeStatus:YES];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleREPORTDataWithContent:(NSString *)content {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCRHttp.content = content;
    self.mCRHttp.dynamicId = self.postDynamicId;
    [self.mCRHttp requestCircleAGCircleREPORTHttpDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"感谢您的反馈，我们将尽快处理。" toView:__strongObject.view];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestMemberBlackUserDataWithMemberID:(NSString *)memberID {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMBUHttp.memberId = memberID;
    [self.mCMBUHttp requestCircleMemberBlackUserDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"在您之后的内容中将不再出现该用户。" toView:__strongObject.view];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestMemberUserInfoData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    [self.mMUIHttp requestMemberUserInfoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject gotoRewardViewWithData:__strongObject.mMUIHttp.mBase];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestMemberRewardDataWithDiamond:(NSString *)diamond resultHandle:(void(^)(void))resultHandle{
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mMRHttp.diamondNum = diamond;
    self.mMRHttp.memberId = [NSString stringSafeChecking:self.mCDHttp.mBase.data.memberBaseDto.memberId];
    [self.mMRHttp requestMemberRewardResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"感谢您的赞赏!" toView:__strongObject.view];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
        
        if(resultHandle) {
            
            resultHandle();
        }
    }];
}

- (AGCircleDetailHttp *)mCDHttp {
    
    if(!_mCDHttp) {
         
        _mCDHttp = [AGCircleDetailHttp new];
    }
    
    return _mCDHttp;
}

- (AGCircleCommentListHttp *)mCCLHttp {
    
    if(!_mCCLHttp) {
        
        _mCCLHttp = [AGCircleCommentListHttp new];
    }
    
    return _mCCLHttp;
}

- (AGCircleCommentUpHttp *)mCCUHttp {
    
    if(!_mCCUHttp) {
        
        _mCCUHttp = [AGCircleCommentUpHttp new];
    }
    
    return _mCCUHttp;
}

- (AGCircleMemberFollowHttp *)mCMFHttp {
    
    if(!_mCMFHttp) {
        
        _mCMFHttp = [AGCircleMemberFollowHttp new];
    }
    
    return _mCMFHttp;
}

- (AGCircleMemberUnFollowHttp *)mCMUFHttp {
    
    if(!_mCMUFHttp) {
        
        _mCMUFHttp = [AGCircleMemberUnFollowHttp new];
    }
    
    return _mCMUFHttp;
}

- (AGCircleLikeHttp *)mCLHttp {
    
    if(!_mCLHttp) {
        
        _mCLHttp = [AGCircleLikeHttp new];
    }
    
    return _mCLHttp;
}

- (AGCircleREPORTHttp *)mCRHttp {
    
    if(!_mCRHttp) {
        
        _mCRHttp = [AGCircleREPORTHttp new];
    }
    
    return _mCRHttp;
}

- (AGCircleMemberBlackUserHttp *)mCMBUHttp {
    
    if(!_mCMBUHttp) {
        
        _mCMBUHttp =  [AGCircleMemberBlackUserHttp new];
    }
    
    return _mCMBUHttp;
}

- (AGMemberUserInfoHttp *)mMUIHttp {
    
    if(!_mMUIHttp) {
        
        _mMUIHttp = [AGMemberUserInfoHttp new];
    }
    
    return _mMUIHttp;
}

- (AGMemberRewardHttp *)mMRHttp {
    
    if(!_mMRHttp) {
         
        _mMRHttp = [AGMemberRewardHttp new];
    }
    
    return _mMRHttp;
}

#pragma mark - Getter
- (UIView *)mTableContainerView {
    
    if(!_mTableContainerView) {
        
        _mTableContainerView = [UIView new];
        _mTableContainerView.backgroundColor = UIColorFromRGB(0x151A28);
        _mTableContainerView.frame = CGRectMake(0.f, CGRectGetMaxY(self.mHeadBackImageView.frame) - kHPDTableOffsetHeight, self.view.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mHeadBackImageView.frame) - CGRectGetHeight(self.mHPDBottomView.frame) + kHPDTableOffsetHeight);
        _mTableContainerView.clipsToBounds = YES;
    }
    
    return _mTableContainerView;
}

- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, CGRectGetHeight(self.view.frame) -  CGRectGetHeight(self.mHPDBottomView.frame))];
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        //if([HelpTools iPhoneNotchScreen]){
        //    _mTableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        //}
    }
    
    return _mTableView;
}

- (CarouselPictureView *)mHeadBackImageView {
    
    if(!_mHeadBackImageView) {
        // 375 * 299
        CGFloat viewHeight = 299.f / 375.f * self.view.width;
        _mHeadBackImageView = [[CarouselPictureView alloc] initWithFrame:((CGRect){CGPointMake(0.f, -viewHeight + kHPDTableOffsetHeight), CGSizeMake(self.view.width, viewHeight)}) picturesData:nil];
        _mHeadBackImageView.pageControlStyle = PAGECONTROL_STYLE_NOD;
        _mHeadBackImageView.isAutoCarousel = NO;
        _mHeadBackImageView.cacheKey = @"AGGameHeadViewBackScroll";
        
        _mHeadBackImageView.pageIndicatorTintColor = [UIColor whiteColorffffffAlpha:0.6];
        _mHeadBackImageView.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        _mHeadBackImageView.defaultImage = IMAGE_NAMED(@"default_goodsDetail_top_image");
    }
    
    return _mHeadBackImageView;
}

- (AGHomePostDetailBottomView *)mHPDBottomView {
    
    if(!_mHPDBottomView) {
        
        _mHPDBottomView = [[AGHomePostDetailBottomView alloc] initWithFrame:CGRectMake(0.f, self.view.height - 46.f - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f), self.view.width, 46.f + ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f))];
        
        __WeakObject(self);
        _mHPDBottomView.didConfirmHandle = ^{
            __WeakStrongObject();
            
            [__strongObject requestCircleCommentUpData];
        };
    }
    
    return _mHPDBottomView;
}

@end
