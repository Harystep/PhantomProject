//
//  AGHomeMobilegameView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeMobilegameView.h"

static const CGFloat kHMHeadContentHeight = 244.f;

@interface AGHomeMobilegameView ()

@property (strong, nonatomic) AGHomeMobilegameHeadView *mHMobilegameHeadView;

@end

@implementation AGHomeMobilegameView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        self.mTableView.width = self.width;
    }
    
    return self;
}

- (void)setData:(AGCicleHomeOtherData *)data {
    _data = data;
    
    self.postArray = data.groupDynamicList;
    
    self.mTableView.tableHeaderView = self.mHMobilegameHeadView;
    [self.mHMobilegameHeadView setData:data];
    
    [self.mTableView reloadData];
}

#pragma mark - Getter
- (AGHomeMobilegameHeadView *)mHMobilegameHeadView {
    
    if(!_mHMobilegameHeadView) {
        
        _mHMobilegameHeadView = [AGHomeMobilegameHeadView new];
        
        __WeakObject(self);
        _mHMobilegameHeadView.didSelectedCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedCellHandle) {
                
                __strongObject.didHeadSelectedCellHandle(data);
            }
        };
        
        _mHMobilegameHeadView.didSelectedLeftHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedLeftHeadHandle) {
                
                __strongObject.didHeadSelectedLeftHeadHandle();
            }
        };
        
        _mHMobilegameHeadView.didSelectedRightHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedRightHeadHandle) {
                
                __strongObject.didHeadSelectedRightHeadHandle();
            }
        };
    }
    
    return _mHMobilegameHeadView;
}

@end

/**
 * AGHomeMobilegameHeadView
 */
@interface AGHomeMobilegameHeadView ()

@property (strong, nonatomic) UIScrollView *mContentScrollView;
@property (strong, nonatomic) AGHomeMobilegameHeadContentView *mHMHRView;
@property (strong, nonatomic) AGHomeMobilegameHeadContentView *mHMHLView;

@end

@implementation AGHomeMobilegameHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        self.height = 0.f;
        [self addSubview:self.mContentScrollView];
        [self.mContentScrollView addSubview:self.mHMHLView];
        [self.mContentScrollView addSubview:self.mHMHRView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeOtherData *)data {
    _data = data;
    
    if(data.groupDtoList &&
       data.groupDtoList.count) {
        
        NSInteger leftIndex = ceil(data.groupDtoList.count / 2.f);
        
        CGFloat contentWidth = (self.width - 12.f * 2 - 12.f) / 1.5f;
        self.mHMHLView.frame = CGRectMake(12.f, 12.f, contentWidth, kHMHeadContentHeight);
        self.mHMHLView.dataList = !leftIndex ? data.groupDtoList : [data.groupDtoList subarrayWithRange:NSMakeRange(0, leftIndex)];
        
        self.mHMHRView.frame = CGRectMake(self.mHMHLView.right + 12.f, self.mHMHLView.top, contentWidth, kHMHeadContentHeight);
        self.mHMHRView.isHot = YES;
        self.mHMHRView.dataList = !leftIndex ? data.groupDtoList : [data.groupDtoList subarrayWithRange:NSMakeRange(leftIndex, data.groupDtoList.count - leftIndex)];
        
        self.height = kHMHeadContentHeight + 12.f * 2;
        self.mContentScrollView.frame = self.bounds;
        self.mContentScrollView.contentSize = CGSizeMake(self.mHMHRView.right + 12.f, self.mContentScrollView.height);
    }
    else {
        
        self.height = 0.f;
    }
}

#pragma mark - Getter
- (UIScrollView *)mContentScrollView {
    
    if(!_mContentScrollView) {
        
        _mContentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mContentScrollView.backgroundColor = [UIColor clearColor];
        _mContentScrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _mContentScrollView;
}

#pragma mark -
- (AGHomeMobilegameHeadContentView *)mHMHRView {
    
    if(!_mHMHRView) {
        
        _mHMHRView = [AGHomeMobilegameHeadContentView new];
        
        __WeakObject(self);
        _mHMHRView.didSelectedCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didSelectedCellHandle) {
                
                __strongObject.didSelectedCellHandle(data);
            }
        };
        
        _mHMHRView.didSelectedHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didSelectedRightHeadHandle) {
                
                __strongObject.didSelectedRightHeadHandle();
            }
        };
    }
    
    return _mHMHRView;
}

- (AGHomeMobilegameHeadContentView *)mHMHLView {
    
    if(!_mHMHLView) {
        
        _mHMHLView = [AGHomeMobilegameHeadContentView new];
        
        __WeakObject(self);
        _mHMHLView.didSelectedCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didSelectedCellHandle) {
                
                __strongObject.didSelectedCellHandle(data);
            }
        };
        
        _mHMHLView.didSelectedHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didSelectedLeftHeadHandle) {
                
                __strongObject.didSelectedLeftHeadHandle();
            }
        };
    }
    
    return _mHMHLView;
}

@end

/**
 * AGHomeMobilegameHeadContentView
 */
@interface AGHomeMobilegameHeadContentView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *headTitle;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AGHomeMobilegameHeadContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor defaultBackColor];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        
        [self.tableView registerClass:[AGHomeMobilegameHeadCTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomeMobilegameHeadCTableViewCell class])];
        [self addSubview:self.tableView];
        if([HelpTools iPhoneNotchScreen]) {
            self.tableView.contentInset = UIEdgeInsetsMake(-22.f, 0.f, 0.f, 0.f);
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setDataList:(NSArray<AGCicleHomeOtherDtoData *> *)dataList {
    _dataList = dataList;
    
    self.headTitle = self.isHot ? @"热门圈子" : @"全部圈子";
    [self.tableView reloadData];
}

#pragma mark - Selector
- (void)headDidSelectedAction:(id)sender {
    
    if(self.didSelectedHeadHandle) {
        
        self.didSelectedHeadHandle();
    }
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger maxCellCont = 3;
    maxCellCont = self.dataList.count > maxCellCont ? maxCellCont : self.dataList.count;
    return maxCellCont;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return ({
        CGRect frame = (CGRect){CGPointZero, CGSizeMake(tableView.width, 35.f)};
        UIView *headerView = [HelpTools createHorizontalShadeViewWithSize:frame.size withColor:@[UIColorFromRGB(0x30E39E), UIColorFromRGB(0x2DC8C2)]];

        UIImageView *rightIconView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"list_right_icon")];
        [headerView addSubview:rightIconView];

        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont font16Bold];
        headLabel.textColor = [UIColor whiteColor];
        headLabel.text = self.headTitle;
        [headLabel sizeToFit];
        [headerView addSubview:headLabel];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor whiteColorffffffAlpha03];
        lineView.height = 1.f;
        [headerView addSubview:lineView];

        rightIconView.left = headerView.width - rightIconView.width - 8.f;
        headLabel.left = 12.f;
        lineView.top = headerView.height - lineView.height;
        lineView.width = headerView.width;
        
        rightIconView.centerY = headLabel.centerY = headerView.height / 2.f;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headDidSelectedAction:)];
        [headerView addGestureRecognizer:tapGesture];

        headerView;
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGHomeMobilegameHeadCTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomeMobilegameHeadCTableViewCell class])];
    tableCell.width = tableView.width;
    if(!tableCell){
        
        tableCell = [[AGHomeMobilegameHeadCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AGHomeMobilegameHeadCTableViewCell class])];
    }
    
    tableCell.indexPath = indexPath;
    tableCell.data = self.dataList[indexPath.row];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.didSelectedCellHandle) {
        
        self.didSelectedCellHandle(self.dataList[indexPath.row]);
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    
    if(!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end

/**
 * AGHomeMobilegameHeadCTableViewCell
 */
@interface AGHomeMobilegameHeadCTableViewCell ()

@property (strong, nonatomic) CarouselImageView *mLeftImageView;
@property (strong, nonatomic) UILabel *mSubInfoTextLabel;
@property (strong, nonatomic) UILabel *mInfoTextLabel;

@end

@implementation AGHomeMobilegameHeadCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mLeftImageView];
        [self.contentView addSubview:self.mInfoTextLabel];
        [self.contentView addSubview:self.mSubInfoTextLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeOtherDtoData *)data {
    _data = data;
    
    self.mLeftImageView.size = CGSizeMake(self.height - 2.f * 2, self.height - 2.f * 2);
    self.mLeftImageView.centerY = self.height / 2.f;
    self.mLeftImageView.left = 12.f;
    NSLog(@"coverImage==>%@", data.coverImage);
    [self.mLeftImageView setImageWithObject:[NSString stringSafeChecking:data.coverImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    
    self.mInfoTextLabel.left = self.mLeftImageView.right + 8.f;
    self.mInfoTextLabel.width = self.width - self.mLeftImageView.right - 8.f - 12.f;;
    self.mInfoTextLabel.top = (self.height - (self.mInfoTextLabel.height + self.mSubInfoTextLabel.height + 8.f)) / 2.f;
    self.mInfoTextLabel.text = [NSString stringWithFormat:@"#%@", [NSString stringSafeChecking:data.name]];
    
    self.mSubInfoTextLabel.top = self.mInfoTextLabel.bottom + 8.f;
    self.mSubInfoTextLabel.left = self.mInfoTextLabel.left;
    self.mSubInfoTextLabel.width = self.mInfoTextLabel.width;
    self.mSubInfoTextLabel.text = [NSString stringSafeChecking:data.Description];
}

#pragma mark - Getter
- (UILabel *)mInfoTextLabel {
    
    if(!_mInfoTextLabel) {
        _mInfoTextLabel = [UILabel new];
        _mInfoTextLabel.font = [UIFont font14];
        _mInfoTextLabel.textColor = [UIColor whiteColor];
        _mInfoTextLabel.height = _mInfoTextLabel.font.lineHeight;
    }
    
    return _mInfoTextLabel;
}

- (UILabel *)mSubInfoTextLabel {
    
    if(!_mSubInfoTextLabel) {
        _mSubInfoTextLabel = [UILabel new];
        _mSubInfoTextLabel.font = [UIFont font14];
        _mSubInfoTextLabel.textColor = UIColorFromRGB(0xB5B7C1);
        _mSubInfoTextLabel.height = _mSubInfoTextLabel.font.lineHeight;
    }
    
    return _mSubInfoTextLabel;
}

- (CarouselImageView *)mLeftImageView {
    
    if(!_mLeftImageView) {
        
        _mLeftImageView = [CarouselImageView new];
        _mLeftImageView.userInteractionEnabled = YES;
        _mLeftImageView.layer.cornerRadius = 5.f;
        _mLeftImageView.clipsToBounds = YES;
        _mLeftImageView.ignoreCache = YES;
    }
    
    return _mLeftImageView;
}
//- (UIImageView *)mLeftImageView {
//
//    if(!_mLeftImageView) {
//
//        _mLeftImageView = [UIImageView new];
//        _mLeftImageView.userInteractionEnabled = YES;
//        _mLeftImageView.layer.cornerRadius = 5.f;
//        _mLeftImageView.clipsToBounds = YES;
//        _mLeftImageView.contentMode = UIViewContentModeScaleAspectFill;
////        _mLeftImageView.ignoreCache = YES;
//    }
//
//    return _mLeftImageView;
//}

@end
