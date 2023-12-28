//
//  AGCircleALLCategoryViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCircleALLCategoryViewController.h"

#import "AGCircleALLCategoryRightTableViewCell.h"
#import "AGCircleSingleCategoryViewController.h"
#import "AGCircleALLCategoryLeftTableViewCell.h"
#import "ESSearchBar.h"

#import "AGCicleHomeRecommendHttp.h"
#import "AGCircleHttp.h"

@interface AGCircleALLCategoryViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ESSearchBar *mESSearchBar;
@property (nonatomic, strong) UITableView *mLeftTableView;
@property (nonatomic, strong) UITableView *mRightTableView;
@property (strong, nonatomic) NSIndexPath *mSelectedIndexPath;

@property (strong, nonatomic) AGCicleHomeClassifyHttp *mAGCHCHttp;
@property (strong, nonatomic) AGCircleListHttp *mCLHttp;

@end

@implementation AGCircleALLCategoryViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.titleString = @"幻影游乐圈";
    self.mSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.view addSubview:self.mESSearchBar];
    
    [self.view addSubview:self.mLeftTableView];
    [self.mLeftTableView registerClass:[AGCircleALLCategoryLeftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCircleALLCategoryLeftTableViewCell class])];
    [self.mLeftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.view addSubview:self.mRightTableView];
    [self.mRightTableView registerClass:[AGCircleALLCategoryRightTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGCircleALLCategoryRightTableViewCell class])];
    [self.mRightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self requestHomeClassifyData];
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key {
    
    self.mSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)reloadLeftData {
    
    if(self.mAGCHCHttp.mBase &&
       self.mAGCHCHttp.mBase.list &&
       self.mAGCHCHttp.mBase.list.count) {
        
        [self requestCircleListDataWithIndex:self.mSelectedIndexPath.row withSearchText:nil];
    }
    
    [self.mLeftTableView reloadData];
}

#pragma mark - GOTO
- (void)gotoCircleSingleCategoryVCWithData:(AGCicleHomeOtherDtoData *)data {
    
    if(!data) return;
    
    AGCircleSingleCategoryViewController *AGCSCVC = [AGCircleSingleCategoryViewController new];
    AGCSCVC.chodData = data;
    
    [self.navigationController pushViewController:AGCSCVC animated:YES];
}

#pragma mark - KeyBoard
- (void)keyboardWillShowAction:(NSNotification *)notifi{
    
}

- (void)keyboardWillHideAction:(NSNotification *)notifi{
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.mLeftTableView == tableView) {
        
        return self.mAGCHCHttp.mBase.list.count;
    }
    
    if(self.mRightTableView == tableView) {
        
        return self.mCLHttp.mBase.data.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mLeftTableView == tableView) {
        
        return 12.f * 2 + 35.f;
    }
    
    if(self.mRightTableView == tableView) {
        
        return 110.f;
    }
    
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mLeftTableView == tableView) {
        
        AGCircleALLCategoryLeftTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCircleALLCategoryLeftTableViewCell class]) forIndexPath:indexPath];
        
        tableCell.data = self.mAGCHCHttp.mBase.list[indexPath.row];
        tableCell.isSelected = (self.mSelectedIndexPath.row == indexPath.row);
        
        return tableCell;
    }
    
    if(self.mRightTableView == tableView) {
        
        AGCircleALLCategoryRightTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGCircleALLCategoryRightTableViewCell class]) forIndexPath:indexPath];
        
        tableCell.data = self.mCLHttp.mBase.data[indexPath.row];
        
        return tableCell;
    }
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.backgroundColor = [UIColor clearColor];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.mLeftTableView == tableView) {
        
        self.mSelectedIndexPath = indexPath;
        [tableView reloadData];
        
        [self requestCircleListDataWithIndex:self.mSelectedIndexPath.row withSearchText:nil];
    }
    else {
        
        AGCircleData *circleData = [self.mCLHttp.mBase.data objectAtIndexForSafe:indexPath.row];
        
        if(self.didSelectedHandle) {
            
            self.didSelectedHandle(circleData);
            [self backToParentView];
        }
        else {
            [self gotoCircleSingleCategoryVCWithData:[circleData changeToHomeOtherDtoData]];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self requestCircleListDataWithIndex:self.mSelectedIndexPath.row withSearchText:searchBar.text];
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
            
            [__strongObject reloadLeftData];
        }
        else {
            if(!__strongObject.mAGCHCHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleListDataWithIndex:(NSInteger)index withSearchText:(NSString *)text{
    
    AGHomeClassifyData *hcData = [self.mAGCHCHttp.mBase.list objectAtIndexForSafe:index];
    if(!hcData) return;
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCLHttp.keyword = text;
    self.mCLHttp.categoryId = hcData.ID;
    [self.mCLHttp requestCircleListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.mRightTableView reloadData];
        }
        else {
            if(!__strongObject.mCLHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGCicleHomeClassifyHttp *)mAGCHCHttp {
    
    if(!_mAGCHCHttp) {
        
        _mAGCHCHttp = [AGCicleHomeClassifyHttp new];
    }
    
    return _mAGCHCHttp;
}

- (AGCircleListHttp *)mCLHttp {
    
    if(!_mCLHttp) {
        
        _mCLHttp = [AGCircleListHttp new];
    }
    
    return _mCLHttp;
}

#pragma mark - Getter
- (ESSearchBar *)mESSearchBar {
    
    if(!_mESSearchBar) {
        
        _mESSearchBar = [[ESSearchBar alloc] initWithFrame:CGRectMake(30.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width - 30.f * 2, 46.f) withPlaceholder:@"请输入搜索内容" tintColor:UIColorFromRGB(0xB5B7C1) isShowCancelButton:NO];
        _mESSearchBar.textFieldBackColor = UIColorFromRGB(0x262E42);
        _mESSearchBar.textFieldTextColor = UIColorFromRGB(0xB5B7C1);
        _mESSearchBar.textFieldCornerRadius = 5.f;
        _mESSearchBar.delegate = self;
    }
    
    return _mESSearchBar;
}

- (UITableView *)mLeftTableView{
    
    if(!_mLeftTableView){
        
        _mLeftTableView = [UITableView new];
        _mLeftTableView.frame = CGRectMake(0.f, self.mESSearchBar.bottom + 20.f, 102.f, self.view.height - (self.mESSearchBar.bottom + 20.f));
        
        _mLeftTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mLeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mLeftTableView.backgroundColor = UIColorFromRGB(0x262E42);
        //_mLeftTableView.scrollEnabled = NO;
        _mLeftTableView.dataSource = self;
        _mLeftTableView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){
            _mLeftTableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mLeftTableView;
}

- (UITableView *)mRightTableView{
    
    if(!_mRightTableView) {
        
        _mRightTableView = [UITableView new];
        _mRightTableView.frame = CGRectMake(self.mLeftTableView.right, self.mLeftTableView.top, self.view.width - self.mLeftTableView.right, self.mLeftTableView.height);
        
        _mRightTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mRightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mRightTableView.backgroundColor = [UIColor clearColor];
        //_mRightTableView.scrollEnabled = NO;
        _mRightTableView.dataSource = self;
        _mRightTableView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){
            _mRightTableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mRightTableView;
}

@end
