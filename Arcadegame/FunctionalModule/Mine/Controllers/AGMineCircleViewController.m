//
//  AGMineCircleViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/9/22.
//

#import "AGMineCircleViewController.h"
#import "AGCircleSingleCategoryViewController.h"

#import "AGCircleHttp.h"

@interface AGMineCircleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) AGCircleGroupFllowHttp *mCGFHttp;

@end

@implementation AGMineCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"我的圈子";
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[AGMineCircleViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGMineCircleViewTableViewCell class])];
    
    [self.mAGNavigateView bringToFront];
    
    [self addRefreshControlWithScrollView:self.mTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    [self requestCircleGroupFllowData];
}

#pragma mark -Refresh
- (void)dropViewDidBeginRefresh:(const void *)key {
    
    [self requestCircleGroupFllowData];
}

- (void)checkDataIsEmptyOrError:(BOOL)isError {
    
    if(self.mCGFHttp.mBase && self.mCGFHttp.mBase.data.data.count) {
        
        [self.mEmptyNoticeLabel removeFromSuperview];
    }
    else {
        self.mEmptyNoticeLabel.center = CGPointMake(self.mTableView.width / 2.f, self.mTableView.height / 2.f);
        [self.mTableView addSubview:self.mEmptyNoticeLabel];
    }
}

#pragma mark - GOTO
- (void)gotoCircleSingleCategoryVCWithData:(AGCicleHomeOtherDtoData *)data {
    
    if(!data) return;
    
    AGCircleSingleCategoryViewController *AGCSCVC = [AGCircleSingleCategoryViewController new];
    AGCSCVC.chodData = data;
    
    [self.navigationController pushViewController:AGCSCVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mCGFHttp.mBase.data.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 113.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGMineCircleViewTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGMineCircleViewTableViewCell class]) forIndexPath:indexPath];
    tableCell.data = self.mCGFHttp.mBase.data.data[indexPath.row];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleGroupFollowData *data = self.mCGFHttp.mBase.data.data[indexPath.row];
    
    [self gotoCircleSingleCategoryVCWithData:[data changeToHomeOtherDtoData]];
}

#pragma mark - Request
- (void)requestCircleGroupFllowData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mCGFHttp requestCircleGroupFllowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.mTableView reloadData];
        }
        else {
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
        
        [__strongObject checkDataIsEmptyOrError:!isSuccess];
    }];
}

- (AGCircleGroupFllowHttp *)mCGFHttp {
    
    if(!_mCGFHttp) {
        
        _mCGFHttp = [AGCircleGroupFllowHttp new];
    }
    
    return _mCGFHttp;
}

#pragma mark - Getter
- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.mAGNavigateView.frame))];
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

/**
 * AGMineCircleViewTableViewCell
 */
@interface AGMineCircleViewTableViewCell ()

@property (strong, nonatomic) UIView *mSContainerView;
@property (strong, nonatomic) CarouselImageView *mSCircleImageView;

@property (strong, nonatomic) UILabel *mSCircleNameLabel;
@property (strong, nonatomic) UILabel *mSCircleInfoLabel;

@end

@implementation AGMineCircleViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mSContainerView];
        
        [self.mSContainerView addSubview:self.mSCircleImageView];
        [self.mSContainerView addSubview:self.mSCircleNameLabel];
        [self.mSContainerView addSubview:self.mSCircleInfoLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mSContainerView.frame = CGRectMake(20.f, 0.f, self.width - 20.f * 2, self.height - 15.f);
    
    self.mSCircleImageView.size = CGSizeMake(self.mSContainerView.height - 10.f, self.mSContainerView.height - 10.f);
    self.mSCircleImageView.left = 10.f;
    self.mSCircleImageView.centerY = self.mSContainerView.height / 2.f;
    [self.mSCircleImageView setImageWithObject:[NSString stringSafeChecking:self.data.coverImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mSCircleNameLabel.top = self.mSCircleImageView.top + 3.f;
    self.mSCircleNameLabel.left = self.mSCircleImageView.right + 10.f;
    self.mSCircleNameLabel.width = self.mSContainerView.width - self.mSCircleImageView.right - 10.f * 2;
    self.mSCircleNameLabel.text = [NSString stringSafeChecking:self.data.name];
    
    self.mSCircleInfoLabel.top = self.mSCircleNameLabel.bottom + 10.f;
    self.mSCircleInfoLabel.left = self.mSCircleNameLabel.left;
    self.mSCircleInfoLabel.width = self.mSCircleNameLabel.width;
    self.mSCircleInfoLabel.text = [NSString stringSafeChecking:self.data.Description];
}

#pragma mark - Getter
- (UIView *)mSContainerView {
    
    if(!_mSContainerView) {
        
        _mSContainerView = [UIView new];
        _mSContainerView.layer.cornerRadius = 10.f;
        _mSContainerView.backgroundColor = UIColorFromRGB(0x1D2332);
    }
    
    return _mSContainerView;
}

- (CarouselImageView *)mSCircleImageView {
    
    if(!_mSCircleImageView) {
        
        _mSCircleImageView = [CarouselImageView new];
        _mSCircleImageView.layer.cornerRadius = 10.f;
        _mSCircleImageView.userInteractionEnabled = YES;
        _mSCircleImageView.clipsToBounds = YES;
        _mSCircleImageView.ignoreCache = YES;
    }
    
    return _mSCircleImageView;
}

- (UILabel *)mSCircleNameLabel {
    
    if(!_mSCircleNameLabel) {
        
        _mSCircleNameLabel = [UILabel new];
        _mSCircleNameLabel.font = [UIFont font15Bold];
        _mSCircleNameLabel.textColor = [UIColor whiteColor];
        
        _mSCircleNameLabel.height = _mSCircleNameLabel.font.lineHeight;
    }
    
    return _mSCircleNameLabel;
}

- (UILabel *)mSCircleInfoLabel {
    
    if(!_mSCircleInfoLabel) {
        
        _mSCircleInfoLabel = [UILabel new];
        _mSCircleInfoLabel.font = [UIFont font14];
        _mSCircleInfoLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _mSCircleInfoLabel.numberOfLines = 3;
        
        _mSCircleInfoLabel.height = _mSCircleInfoLabel.font.lineHeight * 3 + _mSCircleInfoLabel.font.leading * 2;
    }
    
    return _mSCircleInfoLabel;
}

@end
