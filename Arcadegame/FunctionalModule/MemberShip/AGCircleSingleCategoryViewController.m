//
//  AGCircleSingleCategoryViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCircleSingleCategoryViewController.h"
#import "AGCircleSingleCategoryTableViewCell.h"
#import "AGFuncMoreReportViewController.h"
#import "AGCircleSingleCategoryHeadView.h"
#import "AGCirclePublishViewController.h"
#import "AGUserHomeViewController.h"

#import "AGCircleFunctionHttp.h"
#import "AGCircleHttp.h"

static const CGFloat kCSCTableOffsetHeight = 20.f;

@interface AGCircleSingleCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UIView *mTableContainerView;
@property (strong, nonatomic) CarouselImageView *mHeadBackImageView;
@property (strong, nonatomic) AGCircleSingleCategoryHeadView *mCSCHeadView;
@property (strong, nonatomic) UIButton *mCirclePublishButton;

@property (strong, nonatomic) AGCircleLaterListHttp *mCLLHttp;
@property (strong, nonatomic) AGCircleUnFollowHttp *mCUFHttp;
@property (strong, nonatomic) AGCircleFollowHttp *mCFHttp;
@property (strong, nonatomic) AGCircleREPORTHttp *mCRHttp;

@end

@implementation AGCircleSingleCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = [NSString stringSafeChecking:self.chodData.name];
    
    CGFloat viewHeight = 299.f / 375.f * self.view.width;
    self.mHeadBackImageView.frame = (CGRect){CGPointMake(0.f, -viewHeight + kCSCTableOffsetHeight), CGSizeMake(self.view.width, viewHeight)};
    [self.mHeadBackImageView setImageWithObject:[NSString stringSafeChecking:self.chodData.bgImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    [self.mHeadBackImageView addSubview:self.mCSCHeadView];
    
    /*
    [self.view addSubview:self.mTableContainerView];
    [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(kCSCTableOffsetHeight, kCSCTableOffsetHeight) forView:self.mTableContainerView];
    self.mTableContainerView.hidden = YES;
     */
    
    [self.mTableView addSubview:self.mHeadBackImageView];
    self.mTableView.contentInset = UIEdgeInsetsMake((CGRectGetHeight(self.mHeadBackImageView.frame)) - kCSCTableOffsetHeight, 0.f, 0.f, 0.f);
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[AGCircleSingleCategoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCircleSingleCategoryTableViewCell class])];
    
    self.mCirclePublishButton.left = self.view.width - self.mCirclePublishButton.width - 40.f;
    self.mCirclePublishButton.top = self.view.height - self.mCirclePublishButton.height - 20.f - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f);
    [self.view addSubview:self.mCirclePublishButton];
    
    [self addRefreshControlWithScrollView:self.mTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    [self requestCircleListData];
    
    [self.mAGNavigateView bringToFront];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadCSCHeadViewData];
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key {
    
    [self requestCircleListData];
}

- (void)checkDataIsEmptyOrError:(BOOL)isError {
    
    if(self.mCLLHttp.mBase && self.mCLLHttp.mBase.data.data.count) {
        
        [self.mEmptyNoticeLabel removeFromSuperview];
    }
    else {
        self.mEmptyNoticeLabel.center = CGPointMake(self.mTableView.width / 2.f, self.mTableView.height / 2.f - self.mHeadBackImageView.height);
        [self.mTableView addSubview:self.mEmptyNoticeLabel];
    }
}

- (void)reloadCSCHeadViewData {
    
    [self.mCSCHeadView setData:self.chodData];
}

- (void)reloadFollowStatus:(BOOL)isFollowed {
    
    self.chodData.hasFocus = (isFollowed ? 1 : 0);
    [self reloadCSCHeadViewData];
    
    if(self.noticeReloadListData) {
        
        self.noticeReloadListData();
    }
}

#pragma mark - Selector
- (void)mCirclePublishButtonAction:(UIButton *)button {
    
    [self gotoPublishVC];
}

#pragma mark - Goto
- (void)gotoPublishVC {
    
    AGCirclePublishViewController *AGCPVC = [AGCirclePublishViewController new];
    AGCPVC.chodData = self.chodData;
    
    [self.navigationController pushViewController:AGCPVC animated:YES];
}

- (void)gotoUserHomeVCWithMemberID:(NSString *)memberID {
    
    AGUserHomeViewController *AGUHVC = [AGUserHomeViewController new];
    AGUHVC.memberId = memberID;
    
    [self.navigationController pushViewController:AGUHVC animated:YES];
}

- (void)gotoMoreFunctionVCWithIndexPath:(NSIndexPath *)indexPath {
    
    AGFuncMoreReportViewController *AGFMRVC = [AGFuncMoreReportViewController new];
    AGFMRVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:AGFMRVC animated:YES completion:nil];
    
    __WeakObject(self);
    __weak __typeof(indexPath)__weakIndexPath = indexPath;
    AGFMRVC.didSelectedReportHandle = ^(NSString * _Nonnull reson) {
        __WeakStrongObject();
        
        [__strongObject requestCircleREPORTDataWithContent:reson withIndexPath:__weakIndexPath];
    };
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mCLLHttp.mBase.data.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleFollowLastData *circleData = self.mCLLHttp.mBase.data.data[indexPath.row];
    
    return [AGCircleSingleCategoryTableViewCell getAGCircleSingleCategoryTableViewCellHeight:circleData withContainerWidth:tableView.width withIndex:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleSingleCategoryTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCircleSingleCategoryTableViewCell class]) forIndexPath:indexPath];
    tableCell.backgroundColor = UIColorFromRGB(0x151A28);
    
    tableCell.indexPath = indexPath;
    tableCell.data = self.mCLLHttp.mBase.data.data[indexPath.row];
    
    __WeakObject(self);
    tableCell.didHeadIconSelectedHandle = ^(NSIndexPath * _Nonnull indexPath) {
        __WeakStrongObject();
        
        AGCircleFollowLastData *data = __strongObject.mCLLHttp.mBase.data.data[indexPath.row];
        
        [__strongObject gotoUserHomeVCWithMemberID:data.memberId];
    };
    
    tableCell.didFuncBtnSelectedHandle = ^(NSIndexPath * _Nonnull indexPath) {
        __WeakStrongObject();
        
        [__strongObject gotoMoreFunctionVCWithIndexPath:indexPath];
    };
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.mHeadBackImageView sendToBack];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Request
- (void)requestCircleListData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCLLHttp.groupId = self.chodData.ID;
    [self.mCLLHttp requestCircleLaterListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        [__strongObject checkDataIsEmptyOrError:!isSuccess];
        
        if(isSuccess){
            
            __strongObject.mTableContainerView.hidden = NO;
            [__strongObject.mTableView reloadData];
        }
        else {
            if(!__strongObject.mCLLHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleFollowData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCFHttp.groupId = self.chodData.ID;
    [self.mCFHttp requestCircleFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
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

- (void)requestCircleUnFollowData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCUFHttp.groupId = self.chodData.ID;
    [self.mCUFHttp requestCircleUnFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
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

- (void)requestCircleREPORTDataWithContent:(NSString *)content withIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleFollowLastData *circleData = [self.mCLLHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    if(!circleData) return;
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCRHttp.content = content;
    self.mCRHttp.dynamicId = circleData.ID;
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

- (AGCircleFollowHttp *)mCFHttp {
    
    if(!_mCFHttp) {
        
        _mCFHttp = [AGCircleFollowHttp new];
    }
    
    return _mCFHttp;
}

- (AGCircleUnFollowHttp *)mCUFHttp {
    
    if(!_mCUFHttp) {
        
        _mCUFHttp = [AGCircleUnFollowHttp new];
    }
    
    return _mCUFHttp;
}

- (AGCircleLaterListHttp *)mCLLHttp {
    
    if(!_mCLLHttp) {
        
        _mCLLHttp = [AGCircleLaterListHttp new];
    }
    
    return _mCLLHttp;
}

- (AGCircleREPORTHttp *)mCRHttp {
    
    if(!_mCRHttp) {
        
        _mCRHttp = [AGCircleREPORTHttp new];
    }
    
    return _mCRHttp;
}

#pragma mark - Getter
- (UIView *)mTableContainerView {
    
    if(!_mTableContainerView) {
        
        _mTableContainerView = [UIView new];
        _mTableContainerView.backgroundColor = UIColorFromRGB(0x151A28);
        _mTableContainerView.frame = CGRectMake(0.f, CGRectGetMaxY(self.mHeadBackImageView.frame) - kCSCTableOffsetHeight, self.view.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mHeadBackImageView.frame) + kCSCTableOffsetHeight);
        _mTableContainerView.clipsToBounds = YES;
    }
    
    return _mTableContainerView;
}

- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, CGRectGetHeight(self.view.frame))];
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){
            _mTableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mTableView;
}

- (CarouselImageView *)mHeadBackImageView {
    
    if(!_mHeadBackImageView) {
        // 375 * 299
        _mHeadBackImageView = [CarouselImageView new];
        _mHeadBackImageView.backgroundColor = [UIColor clearColor];
        _mHeadBackImageView.userInteractionEnabled = YES;
        _mHeadBackImageView.clipsToBounds = YES;
        _mHeadBackImageView.ignoreCache = YES;
    }
    
    return _mHeadBackImageView;
}

- (AGCircleSingleCategoryHeadView *)mCSCHeadView {
    
    if(!_mCSCHeadView) {
        
        _mCSCHeadView = [[AGCircleSingleCategoryHeadView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.mHeadBackImageView.width, self.mHeadBackImageView.height - CGRectGetHeight(self.mAGNavigateView.frame))];
        
        __WeakObject(self);
        _mCSCHeadView.didFollowSelectedHandle = ^(BOOL isFollowed) {
            __WeakStrongObject();
            
            if(isFollowed) {
                
                [__strongObject requestCircleUnFollowData];
            }
            else {
                [__strongObject requestCircleFollowData];
            }
        };
    }
    
    return _mCSCHeadView;
}

- (UIButton *)mCirclePublishButton {
    
    if(!_mCirclePublishButton) {
        
        _mCirclePublishButton = [UIButton new];
        _mCirclePublishButton.size = CGSizeMake(98.f, 34.f);
        _mCirclePublishButton.layer.cornerRadius = _mCirclePublishButton.height / 2.f;
        _mCirclePublishButton.clipsToBounds = YES;
        
        [_mCirclePublishButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mCirclePublishButton.size colors:@[UIColorFromRGB(0xD6814C), UIColorFromRGB(0xF5736E)] gradientType:1] forState:UIControlStateNormal];
        [_mCirclePublishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mCirclePublishButton setTitle:@"发布动态" forState:UIControlStateNormal];
        _mCirclePublishButton.titleLabel.font = [UIFont font16Bold];
        
        [_mCirclePublishButton addTarget:self action:@selector(mCirclePublishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mCirclePublishButton;
}

@end
