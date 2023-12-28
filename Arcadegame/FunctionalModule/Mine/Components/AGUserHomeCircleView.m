//
//  AGUserHomeCircleView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGUserHomeCircleView.h"

@interface AGUserHomeCircleView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UILabel *mEmptyNoticeLabel;

@end

@implementation AGUserHomeCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.scrollView = self.mTableView;
        
        [self addSubview:self.mTableView];
        [self.mTableView registerClass:[AGUserHomeCircleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGUserHomeCircleTableViewCell class])];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGRect tableFrame = self.bounds;
    tableFrame.size.height = tableFrame.size.height - 22.f;
    
    self.mTableView.frame = tableFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(NSArray<AGCircleMemberOtherGroupData *> *)data {
    _data = data;
    
    [self.mTableView reloadData];
    [self checkDataIsEmpty];
}

- (void)checkDataIsEmpty {
    
    if(self.data && self.data.count) {
        
        [self.mEmptyNoticeLabel removeFromSuperview];
    }
    else {
        self.mEmptyNoticeLabel.center = CGPointMake(self.mTableView.width / 2.f, self.mTableView.height / 2.f - 50.f);
        [self.mTableView addSubview:self.mEmptyNoticeLabel];
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 113.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGUserHomeCircleTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGUserHomeCircleTableViewCell class]) forIndexPath:indexPath];
    tableCell.data = self.data[indexPath.row];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter
- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:self.bounds];
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

- (UILabel *)mEmptyNoticeLabel {
    
    if(!_mEmptyNoticeLabel) {
        
        _mEmptyNoticeLabel = [UILabel new];
        _mEmptyNoticeLabel.font = [UIFont font14];
        _mEmptyNoticeLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
        _mEmptyNoticeLabel.text = @"暂时没有内容~";
        [_mEmptyNoticeLabel sizeToFit];
    }
    
    return _mEmptyNoticeLabel;
}

@end

/**
 * AGUserHomeCircleTableViewCell
 */
@interface AGUserHomeCircleTableViewCell ()

@property (strong, nonatomic) UIView *mSContainerView;
@property (strong, nonatomic) CarouselImageView *mSCircleImageView;

@property (strong, nonatomic) UILabel *mSCircleNameLabel;
@property (strong, nonatomic) UILabel *mSCircleInfoLabel;

@end

@implementation AGUserHomeCircleTableViewCell

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
