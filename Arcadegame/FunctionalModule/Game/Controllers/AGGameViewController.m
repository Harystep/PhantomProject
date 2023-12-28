//
//  AGGameViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/7.
//

#import "AGGameViewController.h"

#import "ABMultiContainerTableView.h"
#import "AGGameMultiBaseView.h"
#import "AGSegmentControl.h"
#import "AGGameHeadView.h"

#import "AGGameHttp.h"

@interface AGGameViewController () <ABMultiContainerViewCustomDataSource, ABMultiContainerViewCustomDelegate, ABMultiContentBaseViewDelegate>

@property (strong, nonatomic) AGGameHeadView *mAGGameHeadView;

@property (nonatomic, strong) ABMultiContainerTableView *mMultiContainerTableView;
@property (strong, nonatomic) AGGameMultiBaseView *mGameThreeView;
@property (strong, nonatomic) AGGameMultiBaseView *mGameFourView;
@property (strong, nonatomic) AGGameMultiBaseView *mGameOneView;
@property (strong, nonatomic) AGGameMultiBaseView *mGameTwoView;
@property (strong, nonatomic) AGSegmentControl *segControl;

@property (strong, nonatomic) NSMutableArray *mContentViews;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) AGGameRoomGroupListHttp *mAGGRGLHttp;
@property (strong, nonatomic) AGGameRoomListHttp *mAGGRLHttp;

@end

@implementation AGGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self setAGNavibarHide:YES];
    
    [self.mMultiContainerTableView setTableHeaderView:({
        UIView *headContentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height)];
        
        self.mAGGameHeadView.frame = CGRectMake(0.f, 0.f, headContentView.width, self.mAGGameHeadView.height);
        [headContentView addSubview:self.mAGGameHeadView];
        
        __WeakObject(self);
        self.segControl = [[AGSegmentControl alloc] initWithSegments:@[]];     
        
        self.segControl.left = 5.f;
        self.segControl.size = CGSizeMake(headContentView.width - self.segControl.left * 2, self.mAGNavigateView.fixedHeight);
        self.segControl.top = self.mAGGameHeadView.bottom + 20.f;
        [headContentView addSubview:self.segControl];
        
        UIImageView *segBackImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"game_seg_back")];
        segBackImageView.top = -16.f;
        segBackImageView.left = 5.f;
        [self.segControl addSubview:segBackImageView];
        [segBackImageView sendToBack];
        
        headContentView.height = self.segControl.bottom;
        
        headContentView;
    })];
    
    self.mMultiContainerTableView.frame = CGRectMake(0.f, 0.f, self.view.width, self.view.height - self.tabBarController.tabBar.height);
    [self.view addSubview:self.mMultiContainerTableView];
    self.mMultiContainerTableView.contentViewsArray = @[self.mGameOneView, self.mGameTwoView, self.mGameThreeView, self.mGameFourView];
    
    [self addRefreshControlWithScrollView:self.mMultiContainerTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    
    self.currentIndex = 0;
    [self reqeustRoomGroupList];
    
    self.mAGGameHeadView.data = [NSData new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key{
    
    self.currentIndex = 0;
    [self reqeustRoomGroupList];
}

- (void)resetSegControlSegment {
    
    if(self.mAGGRGLHttp.mBase &&
       self.mAGGRGLHttp.mBase.data) {
        
        [self.mContentViews removeAllObjects];
        NSMutableArray *items = [NSMutableArray new];
        
        NSInteger maxSegmentCount = 4;
        maxSegmentCount = (self.mAGGRGLHttp.mBase.data.count > maxSegmentCount) ? maxSegmentCount : self.mAGGRGLHttp.mBase.data.count;
        
        for (int i = 0; i < maxSegmentCount; ++i) {
            
            AGGameRoomGroupData *object = self.mAGGRGLHttp.mBase.data[i];
            
            __WeakObject(self);
            AGSegmentItem *item = [[AGSegmentItem alloc] initWithTitle:object.name callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
                __WeakStrongObject();
                
                __strongObject.currentIndex = index;
                [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
                [__strongObject requestRoomListDataWithIndex:index isRefresh:NO];
            }];
            [items addObject:item];
            
            
            AGGameMultiBaseView *gameView = [[AGGameMultiBaseView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height - [self getContentFixedOffsetY])];
            gameView.delegate = self;
            [self.mContentViews addObject:gameView];
        }
        
        [self.segControl resetSegments:items];
        [self requestRoomListDataWithIndex:self.currentIndex isRefresh:YES];
        
        self.mMultiContainerTableView.contentViewsArray = self.mContentViews;
    }
}

- (void)resetGameViewData {
    
    if(self.mContentViews &&
       self.mContentViews.count) {
        
        AGGameMultiBaseView *gameView = [self.mContentViews objectAtIndexForSafe:self.currentIndex];
        if(gameView) {
            
            gameView.data = self.mAGGRLHttp.mBase.data.data;
        }
    }
}

#pragma mark - ABMultiContainerViewCustomDelegate && ABMultiContainerViewCustomDataSource
- (void)containerViewContentDidScrollToIndex:(NSInteger)index{
    
    self.segControl.selectedIndex = index;
}

- (void)containerViewContentWillScrollToIndex:(NSInteger)index{
    
    //[self requestDataForOrderType:index isWillShow:YES];
}

- (CGFloat)containerTableViewContentFixedOffsetY:(ABMultiContainerTableView *)containerView {
    
    return [self getContentFixedOffsetY];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
}

- (void)containerViewContentShouldScroll:(BOOL)shouldScroll {
    
    self.mGameOneView.scrollView.scrollEnabled = shouldScroll; self.mGameTwoView.scrollView.scrollEnabled = shouldScroll;
    self.mGameThreeView.scrollView.scrollEnabled = shouldScroll;
    self.mGameFourView.scrollView.scrollEnabled = shouldScroll;
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

#pragma mark -
- (CGFloat)getContentFixedOffsetY {
    
    if([HelpTools iPhoneNotchScreen]) {
        
        return 126.f;
    }
    
    return 90.f;
}

#pragma mark - Requet
- (void)reqeustRoomGroupList {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    [self.mAGGRGLHttp requestGameRoomGroupListResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [self resetSegControlSegment];
        }
        else {
            if(!__strongObject.mAGGRGLHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestRoomListDataWithIndex:(NSInteger)index isRefresh:(BOOL)isRefresh{
    
    AGGameMultiBaseView *gameView = [self.mContentViews objectAtIndexForSafe:self.currentIndex];
    if(!isRefresh && gameView && gameView.data) {
        
        return;
    }
    
    AGGameRoomGroupData *groupData = [self.mAGGRGLHttp.mBase.data objectAtIndexForSafe:index];
    if(!groupData) return;
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mAGGRLHttp.groupId = groupData.ID;
    self.mAGGRLHttp.categoryId = (groupData.roomGroupList && groupData.roomGroupList.count) ? [groupData.roomGroupList.firstObject categoryId] : @"";
    
    [self.mAGGRLHttp requestGameRoomListResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject resetGameViewData];
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGGameRoomListHttp *)mAGGRLHttp {
    
    if(!_mAGGRLHttp) {
        
        _mAGGRLHttp = [AGGameRoomListHttp new];
    }
    
    return _mAGGRLHttp;
}

- (AGGameRoomGroupListHttp *)mAGGRGLHttp {
    
    if(!_mAGGRGLHttp) {
        
        _mAGGRGLHttp =  [AGGameRoomGroupListHttp new];
    }
    
    return _mAGGRGLHttp;
}

#pragma mark - Getter
- (ABMultiContainerTableView *)mMultiContainerTableView{
    
    if(!_mMultiContainerTableView){
        
        _mMultiContainerTableView = [[ABMultiContainerTableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height - self.tabBarController.tabBar.height)];
        
        _mMultiContainerTableView.backgroundColor = [UIColor clearColor];
        _mMultiContainerTableView.showsHorizontalScrollIndicator = NO;
        _mMultiContainerTableView.showsVerticalScrollIndicator = YES;
        _mMultiContainerTableView.canContainerScroll = YES;
        _mMultiContainerTableView.customDataSource = self;
        _mMultiContainerTableView.customDelegate = self;
    }
    
    return _mMultiContainerTableView;
}

- (AGGameHeadView *)mAGGameHeadView {
    
    if(!_mAGGameHeadView) {
        
        _mAGGameHeadView = [AGGameHeadView new];
    }
    
    return _mAGGameHeadView;
}

- (AGGameMultiBaseView *)mGameOneView {
    
    if(!_mGameOneView) {
        
        _mGameOneView = [[AGGameMultiBaseView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height - [self getContentFixedOffsetY])];
        _mGameOneView.delegate = self;
    }
    
    return _mGameOneView;
}

- (AGGameMultiBaseView *)mGameTwoView {
    
    if(!_mGameTwoView) {
        
        _mGameTwoView = [[AGGameMultiBaseView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height - [self getContentFixedOffsetY])];
        _mGameTwoView.delegate = self;
    }
    
    return _mGameTwoView;
}

- (AGGameMultiBaseView *)mGameThreeView {
    
    if(!_mGameThreeView) {
        
        _mGameThreeView = [[AGGameMultiBaseView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height - [self getContentFixedOffsetY])];
        _mGameThreeView.delegate = self;
    }
    
    return _mGameThreeView;
}

- (AGGameMultiBaseView *)mGameFourView {
    
    if(!_mGameFourView) {
        
        _mGameFourView = [[AGGameMultiBaseView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height - [self getContentFixedOffsetY])];
        _mGameFourView.delegate = self;
    }
    
    return _mGameFourView;
}

- (NSMutableArray *)mContentViews {
    
    if(!_mContentViews) {
        
        _mContentViews = [NSMutableArray new];
    }
    
    return _mContentViews;
}

@end
