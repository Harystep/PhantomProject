//
//  AGFuncMoreReportViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/7/4.
//

#import "AGFuncMoreReportViewController.h"

@interface AGFuncMoreReportViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *mDataSource;
@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation AGFuncMoreReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"举报";
    [self.mAGNavigateView setAGLeftNaviButtonHide:NO];
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.mDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return ({
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont font16Bold];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.size = CGSizeMake(tableView.width, 40.f);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        titleLabel.text = @"请选择举报原因";
        
        titleLabel;
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableCell.backgroundColor = [UIColor clearColor];
    
    tableCell.textLabel.text = self.mDataSource[indexPath.row];
    tableCell.textLabel.textAlignment = NSTextAlignmentCenter;
    tableCell.textLabel.textColor = [UIColor whiteColor];
    tableCell.textLabel.font = [UIFont font14];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.didSelectedReportHandle) {
        
        self.didSelectedReportHandle(self.mDataSource[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Getter
- (NSArray *)mDataSource {
    
    if(!_mDataSource) {
        
        _mDataSource = @[@"发布违法违规内容",
                         @"发布色情低俗内容",
                         @"发布有害信息内容",
                         @"发布垃圾广告内容",
                         @"发布辱骂/引战内容",
                         @"发布侵权/抄袭内容",
                         @"发布未证实/谣传内容",
                         @"发布血腥/暴力内容",
                         @"发布恶意剧透内容",
                         @"发布欺诈内容",
                         @"其他"];
    }
    
    return _mDataSource;
}

- (UITableView *)mTableView{
    
    if(!_mTableView){
        
        _mTableView = [UITableView new];
        _mTableView.frame = CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.frame));
        
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = UIColorFromRGB(0x262E42);
        //_mLeftTableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]) {
            
            _mTableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mTableView;
}

@end
