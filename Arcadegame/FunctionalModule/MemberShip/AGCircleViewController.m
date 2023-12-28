//
//  AGCircleViewController.m
//  Arcadegame
//
//  Created by rrj on 2023/6/6.
//

#import "AGCircleViewController.h"
#import "Masonry.h"
#import "AGSegmentControl.h"
#import "AGCircleTableViewCellNew.h"
#import "UIColor+THColor.h"
#import "HelpTools.h"
#import "AGHotRecommend.h"

#import "AGCircleSingleCategoryViewController.h"
#import "AGCircleALLCategoryViewController.h"
#import "AGFuncMoreReportViewController.h"
#import "AGCircleCategoryViewController.h"
#import "AGHomePostDetailViewController.h"
#import "AGCirclePublishViewController.h"
#import "AGMineMessageViewController.h"
#import "AGGameListViewController.h"
#import "AGUserHomeViewController.h"

#import "AGCircleHttp.h"
#import "AGCircleFunctionHttp.h"

typedef NS_ENUM(NSInteger, AGTopContainerType) {
    
    kAGTopContainerType_Title = 0,
    kAGTopContainerType_FriLabel,
    kAGTopContainerType_Detail,
    kAGTopContainerType_TopImage,
    kAGTopContainerType_Avatar1,
    kAGTopContainerType_Avatar2,
};

static NSString * const kAGCircleTableViewIdentifier = @"kAGCircleTableViewIdentifier";
static const NSInteger kTopContainerBaseTag = 1000;

@interface AGCircleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger mCurrentIndex;

@property (strong, nonatomic) UIView *mTopContainer;
@property (strong, nonatomic) AGHotRecommend *mHotRecommend;

@property (strong, nonatomic) AGCircleFollowListHttp *mCircleFollowListHttp;
@property (strong, nonatomic) AGCircleLaterListHttp *mCircleLaterListHttp;
@property (strong, nonatomic) AGCircleHotListHttp *mCircleHotListHttp;
@property (strong, nonatomic) AGCircleREPORTHttp *mCRHttp;

@end

@implementation AGCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mCurrentIndex = 0;
    [self initUI];
    
    [self requestHotListData];
    [self requestFollowListData];
}

- (void)initUI {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_back_image"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat navHeight = 84;
    UIImage *headImage = [UIImage imageNamed:@"circle-head"];
    CGFloat imageResizeRatio = screenWidth/375;
    CGFloat creatorTopOffset = imageResizeRatio * 204 - navHeight;
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:headImage];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIView *navView = [[UIView alloc] init];
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setImage:[UIImage imageNamed:@"circle-add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *messageButton = [[UIButton alloc] init];
    [messageButton setImage:[UIImage imageNamed:@"circle-info"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize tableHeaderSize = CGSizeMake(screenWidth, creatorTopOffset + 206);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0, 0, tableHeaderSize}];
    
    UIView *creatorView = [[UIView alloc] init];
    creatorView.backgroundColor = [UIColor whiteColor];
    creatorView.layer.cornerRadius = 16;
    creatorView.layer.shadowColor = ((UIColor *)[UIColor getColor:@"000000"]).CGColor;
    creatorView.layer.shadowOffset = CGSizeMake(-3,-3);
    creatorView.layer.shadowOpacity = 0.1;
    creatorView.layer.shadowRadius = 3;
    
    UILabel *creatorLabel = [[UILabel alloc] init];
    creatorLabel.font = [UIFont systemFontOfSize:14];
    creatorLabel.textColor = [UIColor getColor:@"333333"];
    creatorLabel.text = @"10万+游戏爱好者在这里";
    
    UIButton *creatorButton = [[UIButton alloc] init];
    creatorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [creatorButton setBackgroundImage:[HelpTools createGradientImageWithSize:CGSizeMake(71, 25) colors:@[[UIColor getColor:@"30e49d"], [UIColor getColor:@"2eccbe"]] gradientType:0] forState:UIControlStateNormal];
    [creatorButton setTitle:@"去发表" forState:UIControlStateNormal];
    [creatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    creatorButton.layer.cornerRadius = 13;
    creatorButton.layer.masksToBounds = YES;
    [creatorButton addTarget:self action:@selector(creatorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mHotRecommend = [[AGHotRecommend alloc] init];
    
    __WeakObject(self);
    self.mHotRecommend.didSelectedHeadHandle = ^{
        __WeakStrongObject();
        
        [__strongObject gotoCircleALLCategoryVC];
    };
    
    self.mHotRecommend.didSelectedContentHandle = ^(AGCircleHotData * _Nonnull data) {
        __WeakStrongObject();
        
        [__strongObject gotoCircleSingleCategoryVCWithHotData:data];
    };
    
    self.mTopContainer = [self generateHotTop];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[AGCircleTableViewCellNew class] forCellReuseIdentifier:kAGCircleTableViewIdentifier];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = tableHeaderView;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10.f, 0);
    self.tableView = tableView;
    
    AGSegmentControl *seg = [[AGSegmentControl alloc] initWithSegments:@[[[AGSegmentItem alloc] initWithTitle:@"关注" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        [__strongObject checkSegDidSelectedAtIndex:index];
        
    }], [[AGSegmentItem alloc] initWithTitle:@"最新" callback:^(AGSegmentItem * _Nonnull segment, NSUInteger index) {
        __WeakStrongObject();
        
        [__strongObject checkSegDidSelectedAtIndex:index];
    }]]];
    
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:headImageView];
    [self.view addSubview:tableView];
    [self.view addSubview:navView];
    
    [navView addSubview:addButton];
    //[navView addSubview:messageButton];
    [navView addSubview:seg];
    
    [tableHeaderView addSubview:creatorView];
    [tableHeaderView addSubview:self.mHotRecommend];
    [tableHeaderView addSubview:self.mTopContainer];
    
    [creatorView addSubview:creatorLabel];
    [creatorView addSubview:creatorButton];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(navHeight);
    }];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    /*
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addButton);
        make.right.mas_equalTo(-8);
        make.size.equalTo(addButton);
    }];
     */
    
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.centerY.equalTo(addButton);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(navView);
    }];
    
    [tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(tableHeaderSize);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backgroundView);
    }];
    
    [creatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableHeaderView);
        make.size.mas_equalTo(CGSizeMake(258, 32));
        make.top.mas_equalTo(creatorTopOffset);
    }];
    
    [creatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creatorView).offset(10);
        make.centerY.equalTo(creatorView);
    }];
    
    [creatorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(71, 25));
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(creatorView);
    }];
    
    [self.mHotRecommend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(creatorView.mas_bottom).offset(19);
        make.size.mas_equalTo(CGSizeMake(142 * imageResizeRatio, 154));
    }];
    
    [self.mTopContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mHotRecommend);
        make.left.equalTo(self.mHotRecommend.mas_right).offset(7);
        make.height.equalTo(self.mHotRecommend);
        make.right.mas_equalTo(-12);
    }];
    
    [self addRefreshControlWithScrollView:tableView isInitialRefresh:NO shouldInsert:NO forKey:nil];
}

- (UIView *)generateHotTop {
    UIView *topContainer = [[UIView alloc] init];
    topContainer.layer.cornerRadius = 10;
    topContainer.layer.masksToBounds = YES;
    topContainer.backgroundColor = [UIColor getColor:@"262e42"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topContainerSelectedAction:)];
    [topContainer addGestureRecognizer:tapGesture];

    CarouselImageView *hotTopImageView = [[CarouselImageView alloc] init];
    hotTopImageView.layer.cornerRadius = 10.f;
    hotTopImageView.clipsToBounds = YES;
    hotTopImageView.ignoreCache = YES;
    hotTopImageView.tag = kTopContainerBaseTag + kAGTopContainerType_TopImage;

    UILabel *hotTopTitle = [[UILabel alloc] init];
    [hotTopTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    hotTopTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    hotTopTitle.font = [UIFont systemFontOfSize:16];
    hotTopTitle.textColor = [UIColor whiteColor];
    //hotTopTitle.text = @"疯狂魔鬼城";
    hotTopTitle.tag = kTopContainerBaseTag + kAGTopContainerType_Title;

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-arrow"]];

    UIView *circleNumsView = [[UIView alloc] init];
    circleNumsView.layer.borderColor = ((UIColor *)[UIColor getColor:@"3ce2ce"]).CGColor;
    circleNumsView.layer.borderWidth = 1;
    circleNumsView.layer.cornerRadius = 5;
    circleNumsView.backgroundColor = [UIColor getColor:@"3ce3c9" alpha:0.22];

    CarouselImageView *circleAvatar1 = [[CarouselImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 14.f, 14.f)];
    circleAvatar1.layer.cornerRadius = circleAvatar1.size.height / 2.f;
    circleAvatar1.clipsToBounds = YES;
    circleAvatar1.ignoreCache = YES;
    circleAvatar1.tag = kTopContainerBaseTag + kAGTopContainerType_Avatar1;
    
    CarouselImageView *circleAvatar2 = [[CarouselImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 14.f, 14.f)];
    circleAvatar2.layer.cornerRadius = circleAvatar1.size.height / 2.f;
    circleAvatar2.clipsToBounds = YES;
    circleAvatar2.ignoreCache = YES;
    circleAvatar2.tag = kTopContainerBaseTag + kAGTopContainerType_Avatar2;

    UILabel *circleFriendsLabel = [[UILabel alloc] init];
    circleFriendsLabel.font = [UIFont systemFontOfSize:14];
    circleFriendsLabel.textColor = [UIColor whiteColor];
    //circleFriendsLabel.text = @"2.5w圈友";
    circleFriendsLabel.tag = kTopContainerBaseTag + kAGTopContainerType_FriLabel;
    
    UILabel *detail = [[UILabel alloc] init];
    detail.font = [UIFont systemFontOfSize:14];
    detail.textColor = [UIColor whiteColor];
    //detail.text = @"全民街机大决战，万圣节魔鬼城等你";
    detail.numberOfLines = 3;
    detail.lineBreakMode = NSLineBreakByTruncatingTail;
    detail.tag = kTopContainerBaseTag + kAGTopContainerType_Detail;

    [topContainer addSubview:hotTopImageView];
    [topContainer addSubview:hotTopTitle];
    [topContainer addSubview:arrowImageView];
    [topContainer addSubview:circleNumsView];
    [circleNumsView addSubview:circleAvatar1];
    [circleNumsView addSubview:circleAvatar2];
    [circleNumsView addSubview:circleFriendsLabel];
    [topContainer addSubview:detail];

    [hotTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(83);
    }];

    [hotTopTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.equalTo(hotTopImageView.mas_right).offset(8);
    }];

    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotTopTitle.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(-4);
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.centerY.equalTo(hotTopTitle);
    }];

    [circleNumsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotTopTitle);
        make.top.equalTo(hotTopTitle.mas_bottom).offset(9);
        make.right.lessThanOrEqualTo(topContainer);
        make.height.mas_equalTo(28);
    }];

    [circleAvatar1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
        make.centerY.equalTo(circleNumsView);
    }];
    
    [circleAvatar2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(circleAvatar1.mas_right).offset(-circleAvatar1.width / 3.f);
        make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
        make.centerY.equalTo(circleNumsView);
    }];

    [circleFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleAvatar2.mas_right).offset(3);
        make.centerY.equalTo(circleNumsView);
        make.right.mas_equalTo(-2);
    }];

    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleNumsView.mas_bottom).offset(7);
        make.left.equalTo(hotTopTitle);
        make.right.mas_equalTo(-10);
        make.bottom.mas_lessThanOrEqualTo(-6);
    }];
    
    return topContainer;
}

#pragma mark - Selector
- (void)messageButtonAction:(UIButton *)button {
    
    AGMineMessageViewController *AGMMVC = [AGMineMessageViewController new];
    [self.navigationController pushViewController:AGMMVC animated:YES];
}

- (void)addButtonAction:(UIButton *)button {
    
    [self gotoPublishVC];
}

- (void)creatorButtonAction:(UIButton *)button {
    
    [self gotoPublishVC];
}

- (void)topContainerSelectedAction:(id)sender {
    
    if(self.mCircleHotListHttp.mBase &&
       self.mCircleHotListHttp.mBase.data &&
       self.mCircleHotListHttp.mBase.data.count) {
        
        [self gotoCircleSingleCategoryVCWithHotData:self.mCircleHotListHttp.mBase.data.firstObject];
    }
}

#pragma mark - Refresh
- (void)dropViewDidBeginRefresh:(const void *)key{
    
    [self requestHotListData];

    if(self.mCurrentIndex == 0) {
        
        [self requestFollowListData];
    }
    else {
        [self requestLaterListData];
    }
}

- (void)didReloadViewData{
    
    [self requestHotListData];

    if(self.mCurrentIndex == 0) {

        [self requestFollowListData];
    }
    else {
        [self requestLaterListData];
    }
}

- (void)checkSegDidSelectedAtIndex:(NSInteger)index {
    
    self.mCurrentIndex = index;
    
    if(self.mCurrentIndex == 0) {
        
        if(!self.mCircleFollowListHttp.mBase) {
            
            [self requestFollowListData];
        }
    }
    else {
        if(!self.mCircleLaterListHttp.mBase) {
            
            [self requestLaterListData];
        }
    }
    
    [self.tableView reloadData];
}

- (void)resetHotRecommendData {
    
    [self.mHotRecommend setData:self.mCircleHotListHttp.mBase];
}

- (void)resetHotTopContainerData {
    
    if(self.mCircleHotListHttp.mBase &&
       self.mCircleHotListHttp.mBase.data &&
       self.mCircleHotListHttp.mBase.data.count) {
        
        AGCircleHotData *hotData = self.mCircleHotListHttp.mBase.data.firstObject;
        
        UILabel *hotTopTitle = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_Title)];
        if(hotTopTitle) {
            
            hotTopTitle.text = hotData.name;
        }
        
        UILabel *detail = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_Detail)];
        if(detail) {
            
            detail.text = [NSString stringSafeChecking:hotData.Description];
        }
        
        CarouselImageView *hotTopImageView = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_TopImage)];
        if(hotTopImageView) {
            
            [hotTopImageView setImageWithObject:[NSString stringSafeChecking:hotData.bgImage] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
        }
        
        NSString *userImage1;
        NSString *userImage2;
        if(hotData.followImages && hotData.followImages.count) {
            
            userImage1 = [hotData.followImages objectAtIndexForSafe:0];
            userImage2 = [hotData.followImages objectAtIndexForSafe:1];
        }
        
        CarouselImageView *circleAvatar1 = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_Avatar1)];
        if(circleAvatar1) {
            
            if([NSString isNotEmptyAndValid:userImage1]) {
                
                circleAvatar1.hidden = NO;
                [circleAvatar1 setImageWithObject:[NSString stringSafeChecking:userImage1] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
                [circleAvatar1 mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
                }];
            }
            else {
                circleAvatar1.hidden = YES;
                [circleAvatar1 mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.size.mas_equalTo(CGSizeZero);
                }];
            }
        }
        
        CarouselImageView *circleAvatar2 = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_Avatar2)];
        if(circleAvatar2) {
            
            if([NSString isNotEmptyAndValid:userImage2]) {
                
                circleAvatar2.hidden = NO;
                [circleAvatar2 setImageWithObject:[NSString stringSafeChecking:userImage2] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
                [circleAvatar2 mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
                }];
            }
            else {
                circleAvatar2.hidden = YES;
                [circleAvatar2 mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.size.mas_equalTo(CGSizeZero);
                }];
            }
        }
        
        UILabel *circleFriendsLabel = [self.mTopContainer viewWithTag:(kTopContainerBaseTag + kAGTopContainerType_FriLabel)];
        if(circleFriendsLabel) {
            
            circleFriendsLabel.text = [HelpTools checkCircleInfo:hotData.userNum];
        }
    }
}

#pragma mark - GOTO
- (void)gotoCircleCategoryVCWithData {
    
    AGCircleCategoryViewController *AGCCVC = [AGCircleCategoryViewController new];
    [self.navigationController pushViewController:AGCCVC animated:YES];
}

- (void)gotoCircleSingleCategoryVCWithData:(AGCicleHomeOtherDtoData *)data {
    
    if(!data) return;
    
    AGCircleSingleCategoryViewController *AGCSCVC = [AGCircleSingleCategoryViewController new];
    AGCSCVC.chodData = data;
    
    __WeakObject(self);
    AGCSCVC.noticeReloadListData = ^{
        __WeakStrongObject();
        
        if(__strongObject.mCurrentIndex == 0) {

            [__strongObject requestFollowListData];
        }
        else {
            [__strongObject requestLaterListData];
        }
    };
    
    [self.navigationController pushViewController:AGCSCVC animated:YES];
}

- (void)gotoCircleSingleCategoryVCWithHotData:(AGCircleHotData *)data  {
    
    [self gotoCircleSingleCategoryVCWithData:[data changeToHomeOtherDtoData]];
}

- (void)gotoCircleSingleCategoryVCWithFLData:(AGCircleFollowLastData *)data {
    
    [self gotoCircleSingleCategoryVCWithData:[data changeToHomeOtherDtoData]];
}

- (void)gotoPublishVC {
    
    AGCirclePublishViewController *AGCPVC = [AGCirclePublishViewController new];
    [self.navigationController pushViewController:AGCPVC animated:YES];
}

- (void)gotoCircleALLCategoryVC {
    
    AGCircleALLCategoryViewController *AGCALLCVC = [AGCircleALLCategoryViewController new];
    [self.navigationController pushViewController:AGCALLCVC animated:YES];
}

- (void)gotoMoreFunctionVCWithFLData:(AGCircleFollowLastData *)flData {
    
    AGFuncMoreReportViewController *AGFMRVC = [AGFuncMoreReportViewController new];
    AGFMRVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:AGFMRVC animated:YES completion:nil];
    
    __WeakObject(self);
    __weak __typeof(flData)__weakFLData = flData;
    
    AGFMRVC.didSelectedReportHandle = ^(NSString * _Nonnull reson) {
        __WeakStrongObject();
        
        [__strongObject requestCircleREPORTDataWithContent:reson withFLData:__weakFLData];
    };
}

- (void)gotoUserHomeVCWithData:(AGCircleFollowLastData *)flData {
    
    AGUserHomeViewController *AGUHVC = [AGUserHomeViewController new];
    AGUHVC.memberId = flData.memberBaseDto.memberId;
    
    [self.navigationController pushViewController:AGUHVC animated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    AGCircleFollowLastData *cflData;
    
    if(self.mCurrentIndex == 0) {
        
        cflData = [self.mCircleFollowListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    else {
        cflData = [self.mCircleLaterListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    
    if(cflData) {
        
        AGCircleTableViewCellNew *cell = [tableView dequeueReusableCellWithIdentifier:kAGCircleTableViewIdentifier forIndexPath:indexPath];
        cell.mCFLData = cflData;
        
        __WeakObject(self);
        cell.moreDidSelectedHandle = ^(AGCircleFollowLastData * _Nonnull data) {
            __WeakStrongObject();
            
            [__strongObject gotoMoreFunctionVCWithFLData:data];
        };
        
        cell.didHeadIconSelectedHandle = ^(AGCircleFollowLastData * _Nonnull data) {
            __WeakStrongObject();
            
            [__strongObject gotoUserHomeVCWithData:data];
        };
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGCircleFollowLastData *cflData;
    
    if(self.mCurrentIndex == 0) {
        
        cflData = [self.mCircleFollowListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    else {
        cflData = [self.mCircleLaterListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    
    if(cflData) {
        
        return [AGCircleTableViewCellNew getAGCircleSingleCategoryTableViewCellHeight:cflData withContainerWidth:tableView.width withIndex:indexPath];
    }
    
    return 0.f;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.mCurrentIndex == 0) {
        
        if(self.mCircleFollowListHttp.mBase &&
           self.mCircleFollowListHttp.mBase.data &&
           self.mCircleFollowListHttp.mBase.data.data) {
            
            return self.mCircleFollowListHttp.mBase.data.data.count;
        }
    }
    else {
        if(self.mCircleLaterListHttp.mBase &&
           self.mCircleLaterListHttp.mBase.data &&
           self.mCircleLaterListHttp.mBase.data.data) {
            
            return self.mCircleLaterListHttp.mBase.data.data.count;
        }
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGCircleFollowLastData *cflData;
    
    if(self.mCurrentIndex == 0) {
        
        cflData = [self.mCircleFollowListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    else {
        cflData = [self.mCircleLaterListHttp.mBase.data.data objectAtIndexForSafe:indexPath.row];
    }
    
    if(cflData) {
        
        [self gotoCircleSingleCategoryVCWithFLData:cflData];
    }
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
            
            [__strongObject resetHotRecommendData];
            [__strongObject resetHotTopContainerData];
        }
        else {
            if(!__strongObject.mCircleHotListHttp.mBase){
                
                [__strongObject resetHotRecommendData];
                [__strongObject resetHotTopContainerData];
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestFollowListData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mCircleFollowListHttp requestCircleFollowListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.tableView reloadData];
        }
        else {
            if(!__strongObject.mCircleFollowListHttp.mBase){
                
                [__strongObject.tableView reloadData];
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestLaterListData {
    
    __WeakObject(self);
    
    [HelpTools showLoadingForView:self.view];
    
    [self.mCircleLaterListHttp requestCircleLaterListDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject.tableView reloadData];
        }
        else {
            if(!__strongObject.mCircleFollowListHttp.mBase){
                
                [__strongObject.tableView reloadData];
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestCircleREPORTDataWithContent:(NSString *)content withFLData:(AGCircleFollowLastData *)data {
    
    if(!data) return;
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mCRHttp.content = content;
    self.mCRHttp.dynamicId = data.ID;
    [self.mCRHttp requestCircleAGCircleREPORTHttpDataResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"感谢您的反馈，我们将尽快处理。" toView:__strongObject.view];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

#pragma mark - Getter
- (AGCircleFollowListHttp *)mCircleFollowListHttp {
    
    if(!_mCircleFollowListHttp) {
        
        _mCircleFollowListHttp = [AGCircleFollowListHttp new];
    }
    
    return _mCircleFollowListHttp;
}

- (AGCircleLaterListHttp *)mCircleLaterListHttp {
    
    if(!_mCircleLaterListHttp) {
        
        _mCircleLaterListHttp = [AGCircleLaterListHttp new];
    }
    
    return _mCircleLaterListHttp;
}

- (AGCircleHotListHttp *)mCircleHotListHttp {
    
    if(!_mCircleHotListHttp) {
        
        _mCircleHotListHttp = [AGCircleHotListHttp new];
    }
    
    return _mCircleHotListHttp;
}

- (AGCircleREPORTHttp *)mCRHttp {
    
    if(!_mCRHttp) {
        
        _mCRHttp = [AGCircleREPORTHttp new];
    }
    
    return _mCRHttp;
}

@end
