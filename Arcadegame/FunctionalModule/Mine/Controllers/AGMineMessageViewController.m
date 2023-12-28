//
//  AGMineMessageViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/27.
//

#import "AGMineMessageViewController.h"

@interface AGMineMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UIView *mTableContainerView;

@property (strong, nonatomic) NSArray *mMessageData;

@end

@implementation AGMineMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"消息";
    
    [self.view addSubview:self.mTableContainerView];
    [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mTableContainerView];
    
    [self.mTableContainerView addSubview:self.mTableView];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self addRefreshControlWithScrollView:self.mTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    [self requestMessageListData];
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key {
    
    [self requestMessageListData];
}

- (void)checkDataIsEmptyOrError:(BOOL)isError {
    
    if(self.mMessageData && self.mMessageData.count) {
        
        [self.mEmptyNoticeLabel removeFromSuperview];
    }
    else {
        self.mEmptyNoticeLabel.center = CGPointMake(self.mTableView.width / 2.f, self.mTableView.height / 2.f);
        [self.mTableView addSubview:self.mEmptyNoticeLabel];
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.backgroundColor = [UIColor clearColor];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Request
- (void)requestMessageListData {
    
    [HelpTools showLoadingForView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self checkDataIsEmptyOrError:NO];
        [self refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:self.view.window];
    });
}

#pragma mark - Getter
- (UIView *)mTableContainerView {
    
    if(!_mTableContainerView) {
        
        _mTableContainerView = [UIView new];
        _mTableContainerView.backgroundColor = UIColorFromRGB(0x151A28);
        _mTableContainerView.frame = CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mAGNavigateView.frame) - 12.f - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0.f));
        _mTableContainerView.clipsToBounds = YES;
    }
    
    return _mTableContainerView;
}

- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:self.mTableContainerView.bounds];
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
    }
//    18964804240
    return _mTableView;
}

@end
