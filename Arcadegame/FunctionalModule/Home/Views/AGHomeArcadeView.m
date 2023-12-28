//
//  AGHomeArcadeView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeArcadeView.h"

static const CGFloat kHAHeadContentHeight = 193.f;

@interface AGHomeArcadeView ()

@property (strong, nonatomic) AGHomeArcadeHeadView *mHArcadeHeadView;

@end

@implementation AGHomeArcadeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        self.mTableView.width = self.width;
    }
    
    return self;
}

- (void)setData:(AGCicleHomeOtherData *)data {
    _data = data;
    
    self.postArray = data.groupDynamicList;
    
    self.mTableView.tableHeaderView = self.mHArcadeHeadView;
    [self.mHArcadeHeadView setData:data];
    
    [self.mTableView reloadData];
}

#pragma mark -
- (AGHomeArcadeHeadView *)mHArcadeHeadView {
    
    if(!_mHArcadeHeadView) {
        
        _mHArcadeHeadView = [AGHomeArcadeHeadView new];
        
        __WeakObject(self);
        _mHArcadeHeadView.didSelectedLeftHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedLeftHandle) {
                
                __strongObject.didHeadSelectedLeftHandle(data);
            }
        };
        
        _mHArcadeHeadView.didSelectedRightCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedRightCellHandle) {
                
                __strongObject.didHeadSelectedRightCellHandle(data);
            }
        };
        
        _mHArcadeHeadView.didSelectedRightHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didHeadSelectedRightHeadHandle) {
                
                __strongObject.didHeadSelectedRightHeadHandle();
            }
        };
    }
    
    return _mHArcadeHeadView;
}

@end

/**
 * AGHomeArcadeHeadView
 */
@interface AGHomeArcadeHeadView ()

@property (strong, nonatomic) AGHomeArcadeHeadRightView *mHAHRView;
@property (strong, nonatomic) AGHomeArcadeHeadLeftView *mHAHLView;

@property (strong, nonatomic) NSString *currentCategoryId;

@end

@implementation AGHomeArcadeHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        self.height = 0.f;
        [self addSubview:self.mHAHRView];
        [self addSubview:self.mHAHLView];
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
        
        AGCicleHomeOtherDtoData *firstDtoData = data.groupDtoList.firstObject;
        
        CGFloat contentWidth = (self.width - 12.f * 2 - 12.f) / 2.f;
        self.mHAHLView.frame = CGRectMake(12.f, 12.f, contentWidth, kHAHeadContentHeight);
        self.mHAHLView.data = firstDtoData;
        
        self.mHAHRView.frame = CGRectMake(self.mHAHLView.right + 12.f, self.mHAHLView.top, contentWidth, kHAHeadContentHeight);
        self.mHAHRView.dataList = data.groupDtoList;
        
        self.height = kHAHeadContentHeight + 12.f * 2;
    }
    else {
        self.height = 0.f;
    }
}

#pragma mark -
- (AGHomeArcadeHeadRightView *)mHAHRView {
    
    if(!_mHAHRView) {
        
        _mHAHRView = [AGHomeArcadeHeadRightView new];
        
        __WeakObject(self);
        _mHAHRView.didSelectedCellHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didSelectedRightCellHandle) {
                
                __strongObject.didSelectedRightCellHandle(data);
            }
        };
        
        _mHAHRView.didSelectedHeadHandle = ^{
            __WeakStrongObject();
            
            if(__strongObject.didSelectedRightHeadHandle) {
                
                __strongObject.didSelectedRightHeadHandle();
            }
        };
    }
    
    return _mHAHRView;
}

- (AGHomeArcadeHeadLeftView *)mHAHLView {
    
    if(!_mHAHLView) {
        
        _mHAHLView = [AGHomeArcadeHeadLeftView new];
        
        __WeakObject(self);
        _mHAHLView.didSelectedHandle = ^(AGCicleHomeOtherDtoData * _Nonnull data) {
            __WeakStrongObject();
            
            if(__strongObject.didSelectedLeftHandle) {
                
                __strongObject.didSelectedLeftHandle(data);
            }
        };
    }
    
    return _mHAHLView;
}

@end

/**
 * AGHomeArcadeHeadLeftView
 */
@interface AGHomeArcadeHeadLeftView ()

@property (strong, nonatomic) CarouselImageView *mTopImageView;
@property (strong, nonatomic) UIImageView *mMarkRightIcon;
@property (strong, nonatomic) UILabel *mMarkLabel;
@property (strong, nonatomic) UILabel *mInfoLabel;

@end

@implementation AGHomeArcadeHeadLeftView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = UIColorFromRGB(0x262E42);
        self.layer.cornerRadius = 10.f;
        
        [self addSubview:self.mTopImageView];
        [self addSubview:self.mMarkRightIcon];
        [self addSubview:self.mMarkLabel];
        [self addSubview:self.mInfoLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewDidSelectedAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(AGCicleHomeOtherDtoData *)data {
    _data = data;
    
    self.mInfoLabel.text = [NSString stringSafeChecking:data.Description];
    self.mInfoLabel.left = 5.f;
    self.mInfoLabel.width = self.width - self.mInfoLabel.left * 2;
    self.mInfoLabel.height = self.mInfoLabel.font.lineHeight * 2 + self.mInfoLabel.font.leading;
    
    self.mMarkRightIcon.left = self.width - self.mMarkRightIcon.width - 5.f;
    
    self.mMarkLabel.text = [NSString stringWithFormat:@"#%@", data.name];
    self.mMarkLabel.left = 5.f;
    self.mMarkLabel.width = self.mMarkRightIcon.left - self.mMarkLabel.left - 5.f;
    self.mMarkLabel.height = self.mMarkLabel.font.lineHeight;
    
    CGFloat topImageViewHeight = self.height - self.mInfoLabel.height - 7.f - self.mMarkLabel.height - 5.f - 5.f * 2;
    
    self.mTopImageView.origin = CGPointMake(5.f, 5.f);
    self.mTopImageView.width = self.width - self.mTopImageView.left * 2;
    self.mTopImageView.height = topImageViewHeight;
    [self.mTopImageView setImageWithObject:[NSString stringSafeChecking:data.bgImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
    NSLog(@"coverImage--->%@", data.coverImage);
//    [self.mTopImageView sd_setImageWithURL:[NSURL URLWithString:data.coverImage] placeholderImage:IMAGE_NAMED(@"default_square_image")];
    
    self.mMarkLabel.top = self.mTopImageView.bottom + 5.f;
    self.mMarkRightIcon.centerY = self.mMarkLabel.centerY;
    
    self.mInfoLabel.top = self.mMarkLabel.bottom + 7.f;
}

#pragma mark - Selector
- (void)headViewDidSelectedAction:(UITapGestureRecognizer *)gesture {
    
    if(self.didSelectedHandle) {
        
        self.didSelectedHandle(self.data);
    }
}

#pragma mark -
- (CarouselImageView *)mTopImageView {

    if(!_mTopImageView) {

        _mTopImageView = [CarouselImageView new];
        _mTopImageView.userInteractionEnabled = YES;
        _mTopImageView.layer.cornerRadius = 10.f;
        _mTopImageView.clipsToBounds = YES;
        _mTopImageView.ignoreCache = YES;
    }

    return _mTopImageView;
}
//- (UIImageView *)mTopImageView {
//
//    if(!_mTopImageView) {
//
//        _mTopImageView = [UIImageView new];
//        _mTopImageView.userInteractionEnabled = YES;
//        _mTopImageView.layer.cornerRadius = 10.f;
//        _mTopImageView.clipsToBounds = YES;
//    }
//
//    return _mTopImageView;
//}

- (UIImageView *)mMarkRightIcon {
    
    if(!_mMarkRightIcon) {
        
        _mMarkRightIcon = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"list_right_icon")];
        _mMarkRightIcon.userInteractionEnabled = YES;
    }
    
    return _mMarkRightIcon;
}

- (UILabel *)mMarkLabel {
    
    if(!_mMarkLabel) {
        
        _mMarkLabel = [UILabel new];
        _mMarkLabel.font = [UIFont font14];
        _mMarkLabel.textColor = [UIColor whiteColor];
    }
    
    return _mMarkLabel;
}

- (UILabel *)mInfoLabel {
    
    if(!_mInfoLabel) {
        
        _mInfoLabel = [UILabel new];
        _mInfoLabel.font = [UIFont font14];
        _mInfoLabel.textColor = [UIColor whiteColor];
        _mInfoLabel.numberOfLines = 2;
    }
    
    return _mInfoLabel;
}

@end

/**
 * AGHomeArcadeHeadRightView
 */
@interface AGHomeArcadeHeadRightView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *mBackView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AGHomeArcadeHeadRightView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 10.f;
        self.clipsToBounds = YES;
        
        //[self addSubview:[HelpTools createHorizontalShadeViewWithSize:self.size withColor:@[UIColorFromRGB(0x30E39E), UIColorFromRGB(0x2DC8C2)]]];
        
        [self.tableView registerClass:[AGHomeArcadeHeadRightTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomeArcadeHeadRightTableViewCell class])];
        [self addSubview:self.tableView];
        if([HelpTools iPhoneNotchScreen]) {
            
            self.tableView.contentInset = UIEdgeInsetsMake(-22.f, 0.f, 0.f, 0.f);
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.mBackView) {
        
        self.mBackView = [HelpTools createHorizontalShadeViewWithSize:self.size withColor:@[UIColorFromRGB(0x30E39E), UIColorFromRGB(0x2DC8C2)]];
        [self addSubview:self.mBackView];
        self.tableView.frame = self.bounds;
        [self.tableView reloadData];
        [self.tableView bringToFront];
    }
}

- (void)setDataList:(NSArray<AGCicleHomeOtherDtoData *> *)dataList {
    _dataList = dataList;
    
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
    
    NSInteger maxCellCont = 5;
    maxCellCont = self.dataList.count > maxCellCont ? maxCellCont : self.dataList.count;
    
    return maxCellCont;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 28.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.frame = (CGRect){CGPointZero, CGSizeMake(tableView.width, 35.f)};

        UIImageView *rightIconView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"list_right_icon")];
        [headerView addSubview:rightIconView];

        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont font16Bold];
        headLabel.textColor = [UIColor whiteColor];
        headLabel.text = @"全部圈子";
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
    
    AGHomeArcadeHeadRightTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomeArcadeHeadRightTableViewCell class])];
    tableCell.width = tableView.width;
    if(!tableCell){
        
        tableCell = [[AGHomeArcadeHeadRightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AGHomeArcadeHeadRightTableViewCell class])];
    }
    
    AGCicleHomeOtherDtoData *dtoData = self.dataList[indexPath.row];
    
    tableCell.indexPath = indexPath;
    tableCell.infoText = dtoData.name;
    
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
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end

/**
 * AGHomeArcadeHeadRightTableViewCell
 */
@interface AGHomeArcadeHeadRightTableViewCell ()

@property (strong, nonatomic) UILabel *mTextLabel;
@property (strong, nonatomic) UIImageView *mRightIconImageView;

@end

@implementation AGHomeArcadeHeadRightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mRightIconImageView];
        [self.contentView addSubview:self.mTextLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    
    CGFloat fixedWidth = self.width - self.mRightIconImageView.width - 4.f - 12.f * 2;
    
    self.mTextLabel.left = 12.f;
    self.mTextLabel.text = [NSString stringWithFormat:@"#%@", infoText];
    [self.mTextLabel sizeToFit];
    
    if(self.mTextLabel.width > fixedWidth) {
        
        self.mTextLabel.width = fixedWidth;
    }
    self.mRightIconImageView.left = self.mTextLabel.right + 4.f;
    
    self.mTextLabel.centerY = self.mRightIconImageView.centerY = self.height / 2.f;
}

#pragma mark - Getter
- (UILabel *)mTextLabel {
    
    if(!_mTextLabel) {
        _mTextLabel = [UILabel new];
        _mTextLabel.font = [UIFont font14];
        _mTextLabel.textColor = [UIColor whiteColor];
        _mTextLabel.height = _mTextLabel.font.lineHeight;
    }
    
    return _mTextLabel;
}

- (UIImageView *)mRightIconImageView {
    
    if(!_mRightIconImageView) {
        
        _mRightIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"list_right_icon")];
    }
    
    return _mRightIconImageView;
}

@end
