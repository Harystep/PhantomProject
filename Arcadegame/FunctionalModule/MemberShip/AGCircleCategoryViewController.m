//
//  AGCircleCategoryViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/23.
//

#import "AGCircleCategoryViewController.h"
#import "AGCircleCategoryTableViewCell.h"

#import "AGCircleHttp.h"

@interface AGCircleCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) AGCircleHotListHttp *mCircleHotListHttp;

@end

@implementation AGCircleCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"热门圈子";
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[AGCircleCategoryTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCircleCategoryTableViewCell class])];
    
    [self addRefreshControlWithScrollView:self.mTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    
    [self requestHotListData];
}

#pragma Refresh
- (void)dropViewDidBeginRefresh:(const void *)key {
    
    [self requestHotListData];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mCircleHotListHttp.mBase.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [AGCircleCategoryTableViewCell getAGCircleCategoryTableViewCellHeight:self.mCircleHotListHttp.mBase.data[indexPath.row] withContainerWidth:tableView.width withIndex:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleCategoryTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCircleCategoryTableViewCell class]) forIndexPath:indexPath];
    
    tableCell.indexPath = indexPath;
    tableCell.data = self.mCircleHotListHttp.mBase.data[indexPath.row];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Request
- (void)requestHotListData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mCircleHotListHttp requestCircleHotListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.mTableView reloadData];
        }
        else {
            if(!__strongObject.mCircleHotListHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGCircleHotListHttp *)mCircleHotListHttp {
    
    if(!_mCircleHotListHttp) {
        
        _mCircleHotListHttp = [AGCircleHotListHttp new];
    }
    
    return _mCircleHotListHttp;
}

#pragma mark - Getter
- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.mAGNavigateView.frame), self.view.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mAGNavigateView.frame))];
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

@end
