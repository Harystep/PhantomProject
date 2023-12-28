//
//  AGHomeViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/7.
//

#import "AGHomeViewController.h"
#import "AGGuideViewController.h"

#import "AGSegmentControl.h"
#import "ABMultiContainerTableView.h"
#import "AGHomeArcadeView.h"
#import "AGHomeBoardGameView.h"
#import "AGHomeGamingView.h"
#import "AGHomeMobilegameView.h"
#import "AGHomeRecommendView.h"
#import "AGHomeSearchViewController.h"
#import "AGHomePostDetailViewController.h"
#import "AGCircleCategoryViewController.h"
#import "AGCircleALLCategoryViewController.h"
#import "AGCircleSingleCategoryViewController.h"
#import "AGVideoPlayerViewController.h"

#import "AGCicleHomeRecommendHttp.h"
#import "AGCicleHomeOtherHttp.h"
#import "AGGameHttp.h"


@interface AGHomeViewController ()<ABMultiContainerViewCustomDelegate, ABMultiContentBaseViewDelegate, ABMultiContainerViewCustomDataSource>

@property (strong, nonatomic) AGCicleHomeRecommendHttp *mAGCHRHttp;
@property (strong, nonatomic) AGCicleHomeClassifyHttp *mAGCHCHttp;
@property (strong, nonatomic) AGGameRoomEnterHttp *mAGGREHttp;
@property (strong, nonatomic) AGGameVideoHttp *mAGGVHttp;

@property (nonatomic, strong) ABMultiContainerTableView *mMultiContainerTableView;
@property (strong, nonatomic) AGHomeRecommendView *mAGHRecommendView;
@property (strong, nonatomic) AGSegmentControl *segControl;
@property (strong, nonatomic) UIButton *searchButton;

@property (strong, nonatomic) NSMutableArray *mContentViewHttps;
@property (strong, nonatomic) NSMutableArray *mContentViews;
@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation AGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.mAGNavigateView addSubview:self.searchButton];
    self.searchButton.origin = CGPointMake(self.mAGNavigateView.width - self.searchButton.width - 15.f, self.mAGNavigateView.fixedTop + (self.mAGNavigateView.fixedHeight - self.searchButton.height) / 2.f);
    
    __WeakObject(self);
    self.segControl = [[AGSegmentControl alloc] initWithSegments:@[
        [[AGSegmentItem alloc] initWithTitle:@"推荐" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        __strongObject.currentIndex = index;
        [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
    }]] style:AGSegmentControlStyleColorful];
    
    self.segControl.size = CGSizeMake(self.searchButton.left - 15.f * 2, self.mAGNavigateView.fixedHeight);
    self.segControl.top = self.mAGNavigateView.fixedTop + (self.mAGNavigateView.fixedHeight - self.segControl.height) / 2.f;
    self.segControl.left = 15.f;
    [self.mAGNavigateView addSubview:self.segControl];
    
    [self.view addSubview:self.mMultiContainerTableView];
    
    self.currentIndex = 0;
    [self.mContentViews addObject:self.mAGHRecommendView];
    self.mMultiContainerTableView.contentViewsArray = self.mContentViews;
    [self addRefreshControlWithScrollView:self.mMultiContainerTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    
    [self requestHomeClassifyData];
    [self requestHomeDataWithIndex:self.currentIndex isRefresh:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key{
    
    if(self.mAGCHCHttp.mBase &&
       self.mAGCHCHttp.mBase.list) {
        
        [self requestHomeDataWithIndex:self.currentIndex isRefresh:YES];
    }
    else {
        [self requestHomeClassifyData];
    }
}

- (void)didReloadViewData{
    
    if(self.mAGCHCHttp.mBase &&
       self.mAGCHCHttp.mBase.list) {
        
        [self requestHomeDataWithIndex:self.currentIndex isRefresh:YES];
    }
    else {
        [self requestHomeClassifyData];
    }
}

- (void)resetSegControlSegment {
    
    [self.mAGCHCHttp.mBase resortHomeClassifyList];
    
    if(self.mAGCHCHttp.mBase &&
       self.mAGCHCHttp.mBase.list) {
        
        [self.mContentViews removeAllObjects];
        [self.mContentViewHttps removeAllObjects];
        NSMutableArray *items = [NSMutableArray new];
        
        __WeakObject(self);
        AGSegmentItem *item0 = [[AGSegmentItem alloc] initWithTitle:@"推荐" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
            __WeakStrongObject();
        
            __strongObject.currentIndex = index;
            [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
            [__strongObject requestHomeDataWithIndex:__strongObject.currentIndex isRefresh:NO];
        }];
        
        [items addObject:item0];
        
        NSInteger maxSegmentCount = 5;
        maxSegmentCount = (self.mAGCHCHttp.mBase.list.count > maxSegmentCount) ? maxSegmentCount : self.mAGCHCHttp.mBase.list.count;
        
        for (int i = 0; i < maxSegmentCount; ++i) {
            
            AGHomeClassifyData *object = self.mAGCHCHttp.mBase.list[i];
            
            AGSegmentItem *item = [[AGSegmentItem alloc] initWithTitle:object.name callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
                __WeakStrongObject();
                
                __strongObject.currentIndex = index;
                [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
                [__strongObject requestHomeDataWithIndex:__strongObject.currentIndex isRefresh:NO];
            }];
            [items addObject:item];
            
            AGHomeBaseView *contentView;
            
            if([object.name isEqualToString:@"街机"]) {
                
                contentView = [[AGHomeArcadeView alloc] initWithFrame:self.mMultiContainerTableView.bounds];
                
                __WeakObject(self);
                ((AGHomeArcadeView *)contentView).didHeadSelectedLeftHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleSingleCategoryVCWithData:data];
                };
                
                ((AGHomeArcadeView *)contentView).didHeadSelectedRightCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleSingleCategoryVCWithData:data];
                };
                
                ((AGHomeArcadeView *)contentView).didHeadSelectedRightHeadHandle = ^{
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleALLCategoryVC];
                };
            }
            else if([object.name isEqualToString:@"手游"]) {
                
                contentView = [[AGHomeMobilegameView alloc] initWithFrame:self.mMultiContainerTableView.bounds];
                
                __WeakObject(self);
                ((AGHomeMobilegameView *)contentView).didHeadSelectedCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleSingleCategoryVCWithData:data];
                };
                
                ((AGHomeMobilegameView *)contentView).didHeadSelectedRightHeadHandle = ^{
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleCategoryVCWithData];
                };
                
                ((AGHomeMobilegameView *)contentView).didHeadSelectedLeftHeadHandle = ^{
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleALLCategoryVC];
                };
            }
            else if([object.name isEqualToString:@"电竞"]) {
                
                contentView = [[AGHomeGamingView alloc] initWithFrame:self.mMultiContainerTableView.bounds];
                
                __WeakObject(self);
                ((AGHomeGamingView *)contentView).headContentDidSelectedHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleSingleCategoryVCWithData:data];
                };
                
                ((AGHomeGamingView *)contentView).headBottomDidSelectedHandle = ^{
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleTab];
                };
            }
            else {
                //桌游
                contentView = [[AGHomeBoardGameView alloc] initWithFrame:self.mMultiContainerTableView.bounds];
                
                __WeakObject(self);
                ((AGHomeBoardGameView *)contentView).headContentDidSelectedHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleSingleCategoryVCWithData:data];
                };
                
                ((AGHomeBoardGameView *)contentView).headBottomDidSelectedHandle = ^{
                    __WeakStrongObject();
                    
                    [__strongObject gotoCircleTab];
                };
            }
            
            contentView.delegate = self;
            [self.mContentViews addObject:contentView];
            
            __block NSInteger reqeustIndex = i;
            __WeakObject(self);
            
            contentView.didSelectedTableCellHandle = ^(NSIndexPath * _Nonnull indexPath) {
                __WeakStrongObject();
                
                [__strongObject gotoPostDetailVCWithIndexPath:indexPath withRequestIndex:reqeustIndex];
            };
            
            [self.mContentViewHttps addObject:[AGCicleHomeOtherHttp new]];
        }
        
        [self.segControl resetSegments:items];
        
        [self.mContentViews insertObject:self.mAGHRecommendView atIndex:0];
        self.mMultiContainerTableView.contentViewsArray = self.mContentViews;
    }
}

- (void)reloadRecommendData {
    
    self.mAGHRecommendView.data = self.mAGCHRHttp.mBase.data;
}

- (void)reloadOtherDataWithIndex:(NSInteger)index {
    
    AGCicleHomeOtherHttp *otherHttp = [self.mContentViewHttps objectAtIndexForSafe:index];
    UIView *contentView = [self.mContentViews objectAtIndexForSafe:(index + 1)];
    
    if(otherHttp &&
       otherHttp.mBase &&
       contentView) {
        
        if([contentView isKindOfClass:[AGHomeArcadeView class]]) {
            
            ((AGHomeArcadeView *)contentView).data = otherHttp.mBase.data;
        }
        else if([contentView isKindOfClass:[AGHomeMobilegameView class]]) {
            
            ((AGHomeMobilegameView *)contentView).data = otherHttp.mBase.data;
        }
        else if([contentView isKindOfClass:[AGHomeGamingView class]]) {
            
            ((AGHomeGamingView *)contentView).data = otherHttp.mBase.data;
        }
        else if([contentView isKindOfClass:[AGHomeBoardGameView class]]) {
            
            ((AGHomeBoardGameView *)contentView).data = otherHttp.mBase.data;
        }
    }
}

#pragma mark -
- (void)gotoPostDetailVCWithIndexPath:(NSIndexPath *)indexPath withRequestIndex:(NSInteger)index{
    
    NSString *postTitle = nil;
    NSString *postDynamicId = nil;
    
    if(index == -1) {
        
        AGCicleHomeRGroupDynamicData *DData =  [self.mAGCHRHttp.mBase.data.groupDynamicList objectAtIndexForSafe:indexPath.row];
        
        if(DData) {
            
            postTitle = DData.title;
            postDynamicId = DData.ID;
        }
    }
    else {
        AGCicleHomeOtherHttp *otherHttp = [self.mContentViewHttps objectAtIndexForSafe:index];
        
        if(otherHttp && otherHttp.mBase) {
            
            AGCicleHomeRGroupDynamicData *DData =  [otherHttp.mBase.data.groupDynamicList objectAtIndexForSafe:indexPath.row];
            
            if(DData) {
                
                postTitle = DData.title;
                postDynamicId = DData.ID;
            }
        }
    }
    
    if(postTitle && postDynamicId) {
        
        AGHomePostDetailViewController *AGHPDVC = [AGHomePostDetailViewController new];
        AGHPDVC.postDynamicId = postDynamicId;
        AGHPDVC.postTitle = postTitle;
        
        [self.navigationController pushViewController:AGHPDVC animated:YES];
    }
}

- (void)gotoCircleSingleCategoryVCWithData:(AGCicleHomeOtherDtoData *)data {
    
    if(!data) return;
    
    AGCircleSingleCategoryViewController *AGCSCVC = [AGCircleSingleCategoryViewController new];
    AGCSCVC.chodData = data;
    
    [self.navigationController pushViewController:AGCSCVC animated:YES];
}

- (void)gotoCircleCategoryVCWithData {
    
    /*
    AGCircleCategoryViewController *AGCCVC = [AGCircleCategoryViewController new];
    [self.navigationController pushViewController:AGCCVC animated:YES];
     */
    [self gotoCircleALLCategoryVC];
}

- (void)gotoCircleALLCategoryVC {
    
    AGCircleALLCategoryViewController *AGCALLCVC = [AGCircleALLCategoryViewController new];
    [self.navigationController pushViewController:AGCALLCVC animated:YES];
}

- (void)gotoCircleTab {
    
    [self.tabBarController setSelectedIndex:TABKEY_CIRCLE];
}

- (void)gotoSearchVC {
    
    AGHomeSearchViewController *AGHSVC = [AGHomeSearchViewController new];
    [self.navigationController pushViewController:AGHSVC animated:YES];
}

- (void)gotoGameWithMachineSn:(NSString *)machineSn withMachineType:(NSString *)machineType withRoomID:(NSString *)roomID {
    
    __WeakObject(self);
    [self requestGameVideoDataWithRoomID:roomID resultHandle:^(AGGameVideoData *gvData) {
        __WeakStrongObject();
        if(gvData) {
            
            if(gvData.data.count) {
                AGVideoPlayerViewController *AGVPVC = [AGVideoPlayerViewController new];
                AGVPVC.videoURLStr = gvData.data.firstObject;
                
                [__strongObject.navigationController pushViewController:AGVPVC animated:YES];
            }
        }
    }];
    
    return;
    
    if([NSString isNotEmptyAndValid:machineSn] &&
       [NSString isNotEmptyAndValid:machineType] &&
       [NSString isNotEmptyAndValid:roomID]) {
        
        DLOG(@"gotoGameWithMachineSn:%@<>%@<>%@", machineSn, roomID, @(machineType.intValue));
        
        __WeakObject(self);
        [self requestGameRoomEnterDataWithRoomID:roomID resultHandle:^(BOOL shouldEnter) {
            __WeakStrongObject();
            if(shouldEnter) {
                
//                [[AGGameManage sharedAGGameManage] startGameWithController:__strongObject withSN:machineSn withRoomId:roomID andType:machineType.intValue];
            }
        }];
    }
}

#pragma mark - Selector
- (void)searchButtonAction:(UIButton *)button {
     
    //[self gotoSearchVC];
    [self gotoCircleALLCategoryVC];
}

#pragma mark - Request
- (void)requestHomeClassifyData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mAGCHCHttp requestHomeClassifyDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject resetSegControlSegment];
        }
        else {
            if(!__strongObject.mAGCHCHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestHomeDataWithIndex:(NSInteger)index isRefresh:(BOOL)isRefresh{
    
    if(index == 0) {
        
        if(!self.mAGCHRHttp.mBase ||
           isRefresh) {
            
            [self requestHomeData];
        }
    }
    else {
        
        if(self.mAGCHCHttp.mBase &&
           self.mAGCHCHttp.mBase.list) {
            
            index -= 1;
            AGHomeClassifyData *hcData = [self.mAGCHCHttp.mBase.list objectAtIndexForSafe:index];
            AGCicleHomeOtherHttp *otherHttp = [self.mContentViewHttps objectAtIndexForSafe:index];
            if(hcData && otherHttp) {
                
                if(otherHttp.mBase && !isRefresh) { return; }
                
                __WeakObject(self);
                __weak __typeof(otherHttp)__weakOtherHttp = otherHttp;
                [HelpTools showLoadingForView:self.view];
                
                otherHttp.categoryId = hcData.ID;
                [otherHttp requestHomeOtherDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
                    __WeakStrongObject();
                    __strong __typeof(__weakOtherHttp)__strongOtherHttp = __weakOtherHttp;
                    
                    [__strongObject refreshDidFinishRefresh:nil];
                    [HelpTools hideLoadingForView:__strongObject.view];
                    
                    if(isSuccess){
                        
                        [__strongObject reloadOtherDataWithIndex:index];
                    }
                    else {
                        if(!__strongOtherHttp.mBase){
                            
                        }
                        
                        [HelpTools showHttpError:responseObject complete:nil];
                    }
                }];
            }
        }
    }
}

- (void)requestHomeData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mAGCHRHttp requestHomeRecommendDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadRecommendData];
        }
        else {
            if(!__strongObject.mAGCHRHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestGameRoomEnterDataWithRoomID:(NSString *)roomID resultHandle:(void(^)(BOOL shouldEnter))resultHandle{
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mAGGREHttp.roomID = roomID;
    [self.mAGGREHttp requestGameRoomEnterResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if([__strongObject.mAGGREHttp.mBase.errCode isEqualToString:@"0"]) {
                
                if(resultHandle) {
                    
                    resultHandle(YES);
                }
            }
            else {
                [HelpTools showHUDOnlyWithText:__strongObject.mAGGREHttp.mBase.errMsg toView:__strongObject.view.window];
            }
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestGameVideoDataWithRoomID:(NSString *)roomID resultHandle:(void(^)(AGGameVideoData *gvData))resultHandle {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mAGGVHttp.roomID = roomID;
    [self.mAGGVHttp requestGameVideoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if([__strongObject.mAGGVHttp.mBase.errCode isEqualToString:@"0"]) {
                
                if(resultHandle) {
                    
                    resultHandle(__strongObject.mAGGVHttp.mBase);
                }
            }
            else {
                [HelpTools showHUDOnlyWithText:__strongObject.mAGGVHttp.mBase.errMsg toView:__strongObject.view.window];
            }
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGGameRoomEnterHttp *)mAGGREHttp {
    
    if(!_mAGGREHttp) {
        
        _mAGGREHttp = [AGGameRoomEnterHttp new];
    }
    
    return _mAGGREHttp;
}

- (AGGameVideoHttp *)mAGGVHttp {
    
    if(!_mAGGVHttp) {
        
        _mAGGVHttp = [AGGameVideoHttp new];
    }
    
    return _mAGGVHttp;
}

#pragma mark - ABMultiContainerViewCustomDelegate
- (void)containerViewContentDidScrollToIndex:(NSInteger)index{
    
    self.currentIndex = index;
    self.segControl.selectedIndex = index;
}

- (void)containerViewContentWillScrollToIndex:(NSInteger)index{
    
    [self requestHomeDataWithIndex:index isRefresh:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.mMultiContainerTableView.canContentScroll) {
        
        scrollView.contentOffset = CGPointZero;
    }
    else if (scrollView.contentOffset.y < 0) {
        
        self.mMultiContainerTableView.canContentScroll = NO;
        self.mMultiContainerTableView.canContainerScroll = YES;
    }
    
    scrollView.showsVerticalScrollIndicator = self.mMultiContainerTableView.canContentScroll;
}

#pragma mark Request Getter
- (AGCicleHomeRecommendHttp *)mAGCHRHttp {
    
    if(!_mAGCHRHttp) {
        
        _mAGCHRHttp = [AGCicleHomeRecommendHttp new];
    }
    
    return _mAGCHRHttp;
}

- (AGCicleHomeClassifyHttp *)mAGCHCHttp {
    
    if(!_mAGCHCHttp) {
        
        _mAGCHCHttp = [AGCicleHomeClassifyHttp new];
    }
    
    return _mAGCHCHttp;
}

#pragma mark - Getter
- (ABMultiContainerTableView *)mMultiContainerTableView{
    
    if(!_mMultiContainerTableView){
        
        _mMultiContainerTableView = [[ABMultiContainerTableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.mAGNavigateView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mAGNavigateView.frame) - CGRectGetHeight(self.tabBarController.tabBar.bounds))];
        
        _mMultiContainerTableView.backgroundColor = [UIColor clearColor];
        _mMultiContainerTableView.showsHorizontalScrollIndicator = NO;
        _mMultiContainerTableView.showsVerticalScrollIndicator = NO;
        _mMultiContainerTableView.canContainerScroll = NO;
        _mMultiContainerTableView.customDataSource = self;
        _mMultiContainerTableView.customDelegate = self;
    }
    
    return _mMultiContainerTableView;
}

- (AGHomeRecommendView *)mAGHRecommendView {
    
    if(!_mAGHRecommendView) {
        
        _mAGHRecommendView = [[AGHomeRecommendView alloc] initWithFrame:self.mMultiContainerTableView.bounds];
        _mAGHRecommendView.delegate = self;
        
        __WeakObject(self);
        _mAGHRecommendView.didSelectedTableCellHandle = ^(NSIndexPath * _Nonnull indexPath) {
            __WeakStrongObject();
            
            [__strongObject gotoPostDetailVCWithIndexPath:indexPath withRequestIndex:-1];
        };
        
        _mAGHRecommendView.headSegaDidSelectedHandle = ^(AGCicleHomeRSegaData * _Nonnull data) {
            __WeakStrongObject();
            
            [__strongObject gotoGameWithMachineSn:data.machineSn withMachineType:data.machineType withRoomID:data.roomId];
        };
        
        _mAGHRecommendView.headArcadeDidSelectedHandle = ^(AGCicleHomeRArcadeData * _Nonnull data) {
            __WeakStrongObject();
            
            [__strongObject gotoGameWithMachineSn:data.machineSn withMachineType:data.machineType withRoomID:data.roomId];
        };
    }
    
    return _mAGHRecommendView;
}

- (UIButton *)searchButton {
    
    if(!_searchButton) {
        
        _searchButton = [UIButton new];
        [_searchButton setImage:IMAGE_NAMED(@"home_search") forState:UIControlStateNormal];
        [_searchButton sizeToFit];
        
        [_searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _searchButton;
}

- (NSMutableArray *)mContentViews {
    
    if(!_mContentViews) {
        
        _mContentViews = @[].mutableCopy;
    }
    
    return _mContentViews;
}

- (NSMutableArray *)mContentViewHttps {
    
    if(!_mContentViewHttps) {
        
        _mContentViewHttps = @[].mutableCopy;
    }
    
    return _mContentViewHttps;
}

@end
