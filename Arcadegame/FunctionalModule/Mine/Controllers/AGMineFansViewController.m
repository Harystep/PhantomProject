//
//  AGMineFansViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/6/30.
//

#import "AGMineFansViewController.h"
#import "AGUserHomeViewController.h"
#import "AGCircleMemberHttp.h"

@interface AGMineFansViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;

@property (strong, nonatomic) AGCircleMemberFollowHttp *mCMFHttp;
@property (strong, nonatomic) AGCircleMemberFansHttp *mCMFansHttp;
@property (strong, nonatomic) AGCircleMemberUnFollowHttp *mCMUFHttp;

@end

@implementation AGMineFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"我的粉丝";
    
    [self.view addSubview:self.mTableView];
    [self.mTableView registerClass:[AGMineFansTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGMineFansTableViewCell class])];
    
    [self addRefreshControlWithScrollView:self.mTableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
    [self requestCircleMemberFansData];
}

#pragma mark - Refresh
- (void)loadInsertDidBeginRefresh:(const void *)key {
    
    [self requestCircleMemberFansData];
}

- (void)checkDataIsEmptyOrError:(BOOL)isError {
    
    if(self.mCMFansHttp.mBase && self.mCMFansHttp.mBase.data.data.count) {
        
        [self.mEmptyNoticeLabel removeFromSuperview];
    }
    else {
        self.mEmptyNoticeLabel.center = CGPointMake(self.mTableView.width / 2.f, self.mTableView.height / 2.f);
        [self.mTableView addSubview:self.mEmptyNoticeLabel];
    }
}

#pragma mark - GOTO
- (void)gotoUserHomeVCWithData:(AGCircleMemberFansData *)data {
    
    AGUserHomeViewController *AGUHVC = [AGUserHomeViewController new];
    AGUHVC.memberId = data.memberId;
    
    [self.navigationController pushViewController:AGUHVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mCMFansHttp.mBase.data.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGMineFansTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGMineFansTableViewCell class]) forIndexPath:indexPath];
    
    tableCell.indexPath = indexPath;
    tableCell.data = self.mCMFansHttp.mBase.data.data[indexPath.row];
    
    if(indexPath.row == 0) {
        
        if(self.mCMFansHttp.mBase.data.data.count == 1) {
            
            tableCell.corner = KMineFansTableViewCorner_All;
        }
        else {
            
            tableCell.corner = KMineFansTableViewCorner_top;
        }
    }
    else if(indexPath.row == self.mCMFansHttp.mBase.data.data.count - 1) {
        
        tableCell.corner = KMineFansTableViewCorner_Bottom;
    }
    else {
        
        tableCell.corner = KMineFansTableViewCorner_None;
    }
    
    __WeakObject(self);
    tableCell.didFollowedSelectedHandle = ^(AGCircleMemberFansData * _Nonnull data) {
        __WeakStrongObject();
        
        if(data.hasFocus) {
            
            [__strongObject requestCircleMemberUnFollowDataWithID:data.memberId];
        }
        else {
            [__strongObject requestCircleMemberFollowDataWithID:data.memberId];
        }
    };
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGCircleMemberFansData *data = self.mCMFansHttp.mBase.data.data[indexPath.row];
    [self gotoUserHomeVCWithData:data];
}

#pragma mark - Request
- (void)requestCircleMemberFansData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    [self.mCMFansHttp requestCircleMemberFansDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.mTableView reloadData];
            [__strongObject checkDataIsEmptyOrError:NO];
        }
        else {
            if(!__strongObject.mCMFansHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
            [__strongObject checkDataIsEmptyOrError:YES];
        }
    }];
}

- (void)requestCircleMemberFollowDataWithID:(NSString *)ID {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMFHttp.memberId = ID;
    [self.mCMFHttp requestCircleMemberFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject requestCircleMemberFansData];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleMemberUnFollowDataWithID:(NSString *)ID {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCMUFHttp.memberId = ID;
    [self.mCMUFHttp requestCircleMemberUnFollowDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject requestCircleMemberFansData];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGCircleMemberFansHttp *)mCMFansHttp {
    
    if(!_mCMFansHttp) {
        
        _mCMFansHttp = [AGCircleMemberFansHttp new];
    }
    
    return _mCMFansHttp;
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

#pragma mark - Getter
- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.frame))];
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
 * AGMineFansTableViewCell
 */
@interface AGMineFansTableViewCell ()

@property (strong, nonatomic) UIView *mBackGroundView;
@property (strong, nonatomic) CarouselImageView *mImageView;
@property (strong, nonatomic) UIButton *mFollowButton;
@property (strong, nonatomic) UILabel *mNameLabel;

@end

@implementation AGMineFansTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mBackGroundView];
        [self.mBackGroundView addSubview:self.mImageView];
        [self.mBackGroundView addSubview:self.mNameLabel];
        [self.mBackGroundView addSubview:self.mFollowButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mBackGroundView.frame = self.bounds;
    self.mBackGroundView.left = 12.f;
    self.mBackGroundView.width -= self.mBackGroundView.left * 2;
    
    if(self.corner == KMineFansTableViewCorner_top) {
        
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else if(self.corner == KMineFansTableViewCorner_Bottom){
        
        [HelpTools addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else if(self.corner == KMineFansTableViewCorner_All) {
        
        [HelpTools addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(10.f, 10.f) forView:self.mBackGroundView];
    }
    else {
        self.mBackGroundView.layer.mask = nil;
    }
    
    self.mImageView.left = 12.f;
    [self.mImageView setImageWithObject:[NSString stringSafeChecking:self.data.avatar] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mFollowButton.left = self.mBackGroundView.width - self.mFollowButton.width - 12.f;
    if(self.data.hasFocus) {
        
        [self.mFollowButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else {
        [self.mFollowButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    self.mNameLabel.left = self.mImageView.right + 10.f;
    self.mNameLabel.width = self.mFollowButton.left - self.mImageView.right - 10.f *2;
    self.mNameLabel.text = [NSString stringSafeChecking:self.data.nickName];
    
    self.mImageView.centerY = self.mNameLabel.centerY = self.mFollowButton.centerY = self.height / 2.f;
}

#pragma mark - Selector
- (void)followButtonAction:(UIButton *)button {
    
    if(self.didFollowedSelectedHandle) {
        
        self.didFollowedSelectedHandle(self.data);
    }
}

#pragma mark - Getter
- (UIView *)mBackGroundView {
    
    if(!_mBackGroundView) {
        
        _mBackGroundView = [UIView new];
        _mBackGroundView.backgroundColor = UIColorFromRGB(0x2D354E);
    }
    
    return _mBackGroundView;
}

- (CarouselImageView *)mImageView {
    
    if(!_mImageView) {
        
        _mImageView = [CarouselImageView new];
        _mImageView.size = CGSizeMake(40.f, 40.f);
        _mImageView.layer.cornerRadius = _mImageView.height / 2.f;
        _mImageView.userInteractionEnabled = YES;
        _mImageView.clipsToBounds = YES;
        _mImageView.ignoreCache = YES;
    }
    
    return _mImageView;
}

- (UILabel *)mNameLabel {
    
    if(!_mNameLabel) {
        
        _mNameLabel = [UILabel new];
        _mNameLabel.font = [UIFont font14];
        _mNameLabel.textColor = [UIColor whiteColor];
        
        _mNameLabel.height = _mNameLabel.font.lineHeight;
    }
    
    return _mNameLabel;
}

- (UIButton *)mFollowButton {
    
    if(!_mFollowButton) {
        
        _mFollowButton = [UIButton new];
        _mFollowButton.size = CGSizeMake(70.f, 32.f);
        _mFollowButton.layer.cornerRadius = 7.f;
        _mFollowButton.clipsToBounds = YES;
        
        [_mFollowButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mFollowButton.size colors:@[UIColorFromRGB(0x2BDD9A), UIColorFromRGB(0x36CBD1)] gradientType:1] forState:UIControlStateNormal];
        [_mFollowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mFollowButton setTitle:@"关注" forState:UIControlStateNormal];
        _mFollowButton.titleLabel.font = [UIFont font15];
        
        [_mFollowButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mFollowButton;
}

@end
