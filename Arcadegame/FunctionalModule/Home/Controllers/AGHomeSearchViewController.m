//
//  AGHomeSearchViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGHomeSearchViewController.h"

#import "AGHomeSearchCircleTableViewCell.h"
#import "AGHomeSearchPostTableViewCell.h"
#import "AGHomeSearchUserTableViewCell.h"
#import "AGSegmentControl.h"
#import "ESSearchBar.h"

@interface AGHomeSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) AGSegmentControl *mSegControl;
@property (nonatomic, strong) ESSearchBar *mESSearchBar;
@property (nonatomic, strong) UITableView *mTableView;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation AGHomeSearchViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.titleString = @"搜索";
    self.currentIndex = 0;
    
    [self.view addSubview:self.mESSearchBar];
    
    self.mContainerView.frame = CGRectMake(12.f, self.mESSearchBar.bottom + 12.f, self.view.width - 12.f * 2, self.view.height - (self.mESSearchBar.bottom + 12.f) - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 12.f));
    [self.view addSubview:self.mContainerView];
    
    self.mSegControl.frame = CGRectMake(50.f, 0.f, self.mContainerView.width - 50.f * 2, 45.f);
    [self.mContainerView addSubview:self.mSegControl];
    
    [self.mContainerView addSubview:self.mTableView];
    [self.mTableView registerClass:[AGHomeSearchPostTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomeSearchPostTableViewCell class])];
    [self.mTableView registerClass:[AGHomeSearchCircleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomeSearchCircleTableViewCell class])];
    [self.mTableView registerClass:[AGHomeSearchUserTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomeSearchUserTableViewCell class])];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.currentIndex == 0) {
        
        return 10;
    }
    else if(self.currentIndex == 1) {
        
        return 10;
    }
    else if(self.currentIndex == 2) {
        
        return 10;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentIndex == 0) {
        
        return 165.f;
    }
    else if(self.currentIndex == 1) {
        
        return 70.f;
    }
    else if(self.currentIndex == 2) {
        
        return 130.f;
    }
    
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.currentIndex == 0) {
        
        AGHomeSearchPostTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomeSearchPostTableViewCell class]) forIndexPath:indexPath];
        
        return tableCell;
    }
    else if(self.currentIndex == 1) {
        
        AGHomeSearchUserTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomeSearchUserTableViewCell class]) forIndexPath:indexPath];
        
        return tableCell;
    }
    else if(self.currentIndex == 2) {
        
        AGHomeSearchCircleTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomeSearchCircleTableViewCell class]) forIndexPath:indexPath];
        
        return tableCell;
    }
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.backgroundColor = [UIColor clearColor];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - KeyBoard
- (void)keyboardWillShowAction:(NSNotification *)notifi{
    
//    CGRect keyboardRect = [[[notifi userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//    _keyBoardHeight = keyboardRect.size.height;
//    [self checkBackScrollContentSize];
//
//    [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, _keyBoardHeight, 0.f)];
}

- (void)keyboardWillHideAction:(NSNotification *)notifi{
    
//    _keyBoardHeight = 0.f;
//    [self checkBackScrollContentSize];
//
//    [self.tableView setContentInset:UIEdgeInsetsMake(0.f, 0.f, _keyBoardHeight + ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f), 0.f)];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
//    [self searchContentWithText:searchBar.text];
    
    // 让取消按钮一直处于激活状态
    /*
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled = YES;
     */
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if([NSString isNotEmptyAndValid:searchText]){
        
//        [self requestGoodsListDataIsRefresh:YES withIndex:self.mPLFSView.selectedIndex withSortType:self.mPLFSView.sortType withKeyWord:searchText];
    }
    else {
//        [self showContentUI];
    }
}

#pragma mark - Getter
- (ESSearchBar *)mESSearchBar {
    
    if(!_mESSearchBar) {
        
        _mESSearchBar = [[ESSearchBar alloc] initWithFrame:CGRectMake(30.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width - 30.f * 2, 46.f) withPlaceholder:@"请输入搜索内容" tintColor:UIColorFromRGB(0xB5B7C1) isShowCancelButton:NO];
        _mESSearchBar.textFieldBackColor = UIColorFromRGB(0x262E42);
        _mESSearchBar.textFieldTextColor = UIColorFromRGB(0xB5B7C1);
        _mESSearchBar.textFieldCornerRadius = 5.f;
    }
    
    return _mESSearchBar;
}

- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.clipsToBounds = YES;
        _mContainerView.layer.cornerRadius = 10.f;
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (AGSegmentControl *)mSegControl {
    
    if(!_mSegControl) {
        
        __WeakObject(self);
        _mSegControl = [[AGSegmentControl alloc] initWithSegments:@[
            [[AGSegmentItem alloc] initWithTitle:@"动态" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
            __WeakStrongObject();
            
            __strongObject.currentIndex = index;
            [__strongObject.mTableView reloadData];
        }],
            [[AGSegmentItem alloc] initWithTitle:@"用户" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
            __WeakStrongObject();
            
            __strongObject.currentIndex = index;
            [__strongObject.mTableView reloadData];
        }],
            [[AGSegmentItem alloc] initWithTitle:@"圈子" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
            __WeakStrongObject();
            
            __strongObject.currentIndex = index;
            [__strongObject.mTableView reloadData];
        }]]];
    }
    
    return _mSegControl;
}

- (UITableView *)mTableView{
    
    if(!_mTableView){
        
        _mTableView = [UITableView new];
        _mTableView.frame = CGRectMake(0, self.mSegControl.bottom + 12.f, self.mContainerView.width, self.mContainerView.height - (self.mSegControl.bottom + 12.f));
        
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = UIColorFromRGB(0x262E42);
        //_mLeftTableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
    }
    
    return _mTableView;
}

@end
