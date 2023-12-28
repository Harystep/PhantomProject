//
//  AGUserHomeViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGUserHomeViewController.h"

#import "AGHomePostDetailViewController.h"
#import "ABMultiContainerTableView.h"
#import "AGUserHomeCircleView.h"
#import "AGUserHomeHeadView.h"
#import "AGUserHomePostView.h"
#import "AGUserHomeHomeView.h"
#import "AGSegmentControl.h"

#import "AGCircleMemberHttp.h"

@interface AGUserHomeViewController () <ABMultiContainerViewCustomDataSource, ABMultiContainerViewCustomDelegate, ABMultiContentBaseViewDelegate>

@property (strong, nonatomic) AGUserHomeHeadView *mAGUserHomeHeadView;

@property (nonatomic, strong) ABMultiContainerTableView *mMultiContainerTableView;
@property (strong, nonatomic) AGUserHomeCircleView *mUserHomeCircleView;
@property (strong, nonatomic) AGUserHomeHomeView *mUserHomeHomeView;
@property (strong, nonatomic) AGUserHomePostView *mUserHomePostView;
@property (strong, nonatomic) AGSegmentControl *segControl;

@property (strong, nonatomic) AGCircleMemberOthersHttp *mCMOHttp;
@property (strong, nonatomic) AGCircleMemberFollowHttp *mCMFHttp;
@property (strong, nonatomic) AGCircleMemberUnFollowHttp *mCMUFHttp;
@property (strong, nonatomic) AGCircleMemberBlackUserHttp *mCMBUHttp;

@end

@implementation AGUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    __WeakObject(self);
    self.segControl = [[AGSegmentControl alloc] initWithSegments:@[
        [[AGSegmentItem alloc] initWithTitle:@"主页" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
    }],
        [[AGSegmentItem alloc] initWithTitle:@"帖子" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
    }],
        [[AGSegmentItem alloc] initWithTitle:@"圈子" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        [__strongObject.mMultiContainerTableView contentScrollToIndex:index];
    }]]];
    self.segControl.size = CGSizeMake(self.view.width, 45.f);
    
    self.mMultiContainerTableView.segmentView = self.segControl;
    self.mMultiContainerTableView.tableHeaderView = self.mAGUserHomeHeadView;
    
    [self.view addSubview:self.mMultiContainerTableView];
    self.mMultiContainerTableView.contentViewsArray = @[self.mUserHomeHomeView, self.mUserHomePostView, self.mUserHomeCircleView];
    
    [self addRefreshControlWithScrollView:self.mMultiContainerTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    
    [self.mAGNavigateView bringToFront];
    
    [self requestCiircleMemberOthersData];
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key{
    
    [self requestCiircleMemberOthersData];
}

- (void)reloadCircleMemberData {
    
    if(self.mCMOHttp.mBase && self.mCMOHttp.mBase.data) {
        
        self.mAGUserHomeHeadView.data = self.mCMOHttp.mBase.data;
        self.mUserHomeHomeView.data = self.mCMOHttp.mBase.data.member;
        self.mUserHomeCircleView.data = self.mCMOHttp.mBase.data.groupList;
        self.mUserHomePostView.data = self.mCMOHttp.mBase.data.groupDynamics;
    }
}

- (void)resetCircleMemberDataIsFollowed:(BOOL)isFollowed {
    
    self.mCMOHttp.mBase.data.attention = (isFollowed ? 1 : 0);
    self.mAGUserHomeHeadView.data = self.mCMOHttp.mBase.data;
}

#pragma mark - GOTO
- (void)gotoMemberFunctionAlertISFollowed:(BOOL)isFollowed {
    
    __WeakObject(self);
    UIAlertController *alertPopVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIView *subView = alertPopVC.view.subviews.firstObject;
    if(subView) {
        
        UIView *subSubView = subView.subviews.firstObject;
        if(subSubView) subSubView.backgroundColor = UIColorFromRGB(0x262D42);
    }
    
    NSString *alertString = isFollowed ? @"取消关注" : @"关注";
    [alertPopVC addAction:[UIAlertAction actionWithTitle:alertString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __WeakStrongObject();
        
        if(isFollowed) {
            
            [__strongObject requestCircleMemberUnFollowData];
        }
        else {
            [__strongObject requestCircleMemberFollowData];
        }
    }]];
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __WeakStrongObject();
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"拉黑账号您的关注也会同步取消关联！请确认！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [__strongObject requestMemberBlackUserDataWithMemberID:__strongObject.memberId];
        }]];
        [__strongObject presentViewController:alert animated:YES completion:nil];
    }]];
    
    [alertPopVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
    }]];
    
    [self presentViewController:alertPopVC animated:YES completion:nil];
}

#pragma mark - ABMultiContainerViewCustomDelegate && ABMultiContainerViewCustomDataSource
- (void)containerViewContentDidScrollToIndex:(NSInteger)index{
    
    self.segControl.selectedIndex = index;
}

- (void)containerViewContentWillScrollToIndex:(NSInteger)index{
    
    //[self requestDataForOrderType:index isWillShow:YES];
}

- (void)containerViewContentShouldScroll:(BOOL)shouldScroll {
    
    self.mUserHomeHomeView.scrollView.scrollEnabled = shouldScroll;
    self.mUserHomePostView.scrollView.scrollEnabled = shouldScroll;
    self.mUserHomeCircleView.scrollView.scrollEnabled = shouldScroll;
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

#pragma mark - Request
- (void)requestCiircleMemberOthersData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMOHttp.memberId = self.memberId;
    [self.mCMOHttp requestCircleMemberOthersDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadCircleMemberData];
        }
        else {
            if(!__strongObject.mCMOHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleMemberFollowData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMFHttp.memberId = self.memberId;
    [self.mCMFHttp requestCircleMemberFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject resetCircleMemberDataIsFollowed:YES];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleMemberUnFollowData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMUFHttp.memberId = self.memberId;
    [self.mCMUFHttp requestCircleMemberUnFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject resetCircleMemberDataIsFollowed:NO];
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

- (AGCircleMemberOthersHttp *)mCMOHttp {
    
    if(!_mCMOHttp) {
        
        _mCMOHttp = [AGCircleMemberOthersHttp new];
    }
    
    return _mCMOHttp;
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

- (AGCircleMemberBlackUserHttp *)mCMBUHttp {
    
    if(!_mCMBUHttp) {
        
        _mCMBUHttp =  [AGCircleMemberBlackUserHttp new];
    }
    
    return _mCMBUHttp;
}

#pragma mark - Getter
- (ABMultiContainerTableView *)mMultiContainerTableView{
    
    if(!_mMultiContainerTableView){
        
        _mMultiContainerTableView = [[ABMultiContainerTableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.bounds), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.bounds))];
        
        _mMultiContainerTableView.backgroundColor = [UIColor clearColor];
        _mMultiContainerTableView.showsHorizontalScrollIndicator = NO;
        _mMultiContainerTableView.showsVerticalScrollIndicator = YES;
        _mMultiContainerTableView.canContainerScroll = YES;
        _mMultiContainerTableView.customDataSource = self;
        _mMultiContainerTableView.customDelegate = self;
    }
    
    return _mMultiContainerTableView;
}

- (AGUserHomeHeadView *)mAGUserHomeHeadView {
    
    if(!_mAGUserHomeHeadView) {
        
        _mAGUserHomeHeadView = [[AGUserHomeHeadView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, 180.f - CGRectGetHeight(self.mAGNavigateView.bounds))];
        _mAGUserHomeHeadView.topOffsetY = CGRectGetHeight(self.mAGNavigateView.bounds) - 20.f;
        
        __WeakObject(self);
        _mAGUserHomeHeadView.didFollowedSelectedHandle = ^(BOOL isFollowed) {
            __WeakStrongObject();
            
            [__strongObject gotoMemberFunctionAlertISFollowed:isFollowed];
        };
    }
    
    return _mAGUserHomeHeadView;
}

- (AGUserHomeCircleView *)mUserHomeCircleView {
    
    if(!_mUserHomeCircleView) {
        
        _mUserHomeCircleView = [[AGUserHomeCircleView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height)];
        _mUserHomeCircleView.delegate = self;
    }
    
    return _mUserHomeCircleView;
}

- (AGUserHomeHomeView *)mUserHomeHomeView {
    
    if(!_mUserHomeHomeView) {
        
        _mUserHomeHomeView = [[AGUserHomeHomeView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height)];
        _mUserHomeHomeView.delegate = self;
    }
    
    return _mUserHomeHomeView;
}

- (AGUserHomePostView *)mUserHomePostView {
    
    if(!_mUserHomePostView) {
        
        _mUserHomePostView = [[AGUserHomePostView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.mMultiContainerTableView.width, self.mMultiContainerTableView.height)];
        _mUserHomePostView.delegate = self;
    }
    
    return _mUserHomePostView;
}

@end
