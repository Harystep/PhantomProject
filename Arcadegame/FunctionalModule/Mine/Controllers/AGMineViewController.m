//
//  AGMineViewController.m
//  Arcadegame
//
//  Created by rrj on 2023/6/9.
//

#import "AGMineViewController.h"

#import "AGHomePostDetailViewController.h"
#import "AGMineAttentionViewController.h"
#import "AGMineFeedbackViewController.h"
#import "AGServiceCollectionViewCell.h"
#import "AGMineMessageViewController.h"
#import "BLImagePickerViewController.h"
#import "AGTrendsCollectionViewCell.h"
#import "AGMineCircleViewController.h"
#import "AGRechargeViewController.h"
#import "AGMineFansViewController.h"
#import "AGGameListViewController.h"
#import "ABWebsiteViewController.h"
#import "AGSettingViewController.h"
#import "AGLoginViewController.h"
#import "AGGameViewController.h"
#import "UIButton+WebCache.h"
#import "AGGradientView.h"
#import "AGWealthButton.h"
#import "AGCoinButton.h"
#import "Masonry.h"

#import "AGMemberHttp.h"
#import "AGServiceHttp.h"

static NSString * const kAGTrendsCollectionViewIdentifier = @"kAGTrendsCollectionViewIdentifier";
static NSString * const kAGServiceCollectionViewIdentifier = @"kAGServiceCollectionViewIdentifier";

static NSArray<AGServiceItem *> *serviceItems;

@interface AGMineViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIButton *avatar;
@property (strong, nonatomic) UIImageView *level;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UICollectionView *trendsCollectionView;
@property (strong, nonatomic) UICollectionView *serviceCollectionView;

@property (strong, nonatomic) UIView *wealthContainer;
@property (strong, nonatomic) AGCoinButton *mCoinButton;
@property (strong, nonatomic) AGCoinButton *mDiamondButton;
@property (strong, nonatomic) UIButton *mChargeButton;

@property (strong, nonatomic) UILabel *fansCount;
@property (strong, nonatomic) UILabel *followCount;
@property (strong, nonatomic) UILabel *circleCount;
@property (strong, nonatomic) UIButton *viewTrendsButton;
@property (strong, nonatomic) AGGradientView *trendContainer;
@property (strong, nonatomic) AGMineViewBannerView *banner;
@property (strong, nonatomic) AGWealthButton *goldButton;

@property (strong, nonatomic) AGMemberUserInfoEditHttp *mMUIEHttp;
@property (strong, nonatomic) AGMemberInviteInfoHttp *mMIIHttp;
@property (strong, nonatomic) AGMemberUserInfoHttp *mMUIHttp;
@property (strong, nonatomic) AGMemberMyCircleHttp *mMMCHttp;
@property (strong, nonatomic) AGServiceBannerHttp *mSBHttp;

@end

@implementation AGMineViewController

+ (void)initialize {
    serviceItems = @[
        //[[AGServiceItem alloc] initWithType:@"game-history" name:@"游戏记录" icon:@"game-history"],
        //[[AGServiceItem alloc] initWithType:@"catch-history" name:@"抓取记录" icon:@"catch-history"],
        [[AGServiceItem alloc] initWithType:@"friend-invite" name:@"邀请好友" icon:@"friend-invite"],
        [[AGServiceItem alloc] initWithType:@"message" name:@"消息" icon:@"message"],
        //[[AGServiceItem alloc] initWithType:@"contactus" name:@"联系我们" icon:@"friend-invite"],
        [[AGServiceItem alloc] initWithType:@"palyercomminicate" name:@"玩家交流群" icon:@"friend-contact"],
        [[AGServiceItem alloc] initWithType:@"feedback" name:@"意见反馈" icon:@"my-appeal"],
        //[[AGServiceItem alloc] initWithType:@"friend-contact" name:@"联系好友" icon:@"friend-contact"],
        //[[AGServiceItem alloc] initWithType:@"address-manage" name:@"地址管理" icon:@"address-manage"],
        //[[AGServiceItem alloc] initWithType:@"my-appeal" name:@"我的申诉" icon:@"my-appeal"],
        [[AGServiceItem alloc] initWithType:@"settings" name:@"设置" icon:@"settings"]
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self requestMemberUserInfoData];
    [self requestMemberMyCircleData];
    [self requestBannerData];
}

- (void)initUI {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-bg"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIScrollView *scrollView= [UIScrollView new];
    scrollView.backgroundColor = [UIColor clearColor];
    
    UIView *containerView = [UIView new];
    
    UIButton *avatar = [[UIButton alloc] init];
    avatar.layer.cornerRadius = 35;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    avatar.layer.borderWidth = 3.f;
    //[avatar sd_setImageWithURL:[NSURL URLWithString:@"https://img2.baidu.com/it/u=955956276,3392954639&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"] forState:UIControlStateNormal];
    [avatar addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.avatar = avatar;
    
    UIImageView *level = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_level_1"]];
    level.hidden = YES;
    self.level = level;
    
    UILabel *userName = [UILabel new];
    userName.userInteractionEnabled = YES;
    userName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    userName.textColor = [UIColor whiteColor];
    //userName.text = @"娃娃机娃娃";
    self.userName = userName;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameTapGestureAction:)];
    [userName addGestureRecognizer:tapGesture];
    
    UIView *wealthContainer = [UIView new];
    self.wealthContainer = wealthContainer;
    AGWealthButton *diamonButton = [[AGWealthButton alloc] initWithWealthType:AGWealthButtonTypeDiamond];
    AGWealthButton *goldButton = [[AGWealthButton alloc] initWithWealthType:AGWealthButtonTypeGold];
    AGWealthButton *pointButton = [[AGWealthButton alloc] initWithWealthType:AGWealthButtonTypePoint];
    diamonButton.hidden = pointButton.hidden = YES;
    self.goldButton = goldButton;
    self.mCoinButton = [[AGCoinButton alloc] initWithWealthType:AGCoinButtonTypeGold];
    [self.mCoinButton addTarget:self action:@selector(mCoinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mDiamondButton = [[AGCoinButton alloc] initWithWealthType:AGCoinButtonTypeDiamond];
    [self.mDiamondButton addTarget:self action:@selector(mCoinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [goldButton addTarget:self action:@selector(wealthButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *relationView = [[UIView alloc] init];
    UIImageView *relationBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-num-banner"]];
    relationBackground.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenWidth - 46, 63) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    relationBackground.layer.mask = shape;
    
    UIButton *fansButton = [UIButton new];
    [fansButton addTarget:self action:@selector(fansButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *fansCount = [UILabel new];
    fansCount.font = [UIFont fontWithName:@"Alfa Slab One" size:16];
    fansCount.textColor = [UIColor whiteColor];
    //fansCount.text = @"1231";
    UILabel *fansName = [UILabel new];
    fansName.font = [UIFont systemFontOfSize:14];
    fansName.textColor = [UIColor whiteColor];
    fansName.text = @"粉丝";
    self.fansCount = fansCount;
    
    UIButton *followButton = [UIButton new];
    [followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *followCount = [UILabel new];
    followCount.font = [UIFont fontWithName:@"Alfa Slab One" size:16];
    followCount.textColor = [UIColor whiteColor];
    //followCount.text = @"1231";
    UILabel *followName = [UILabel new];
    followName.font = [UIFont systemFontOfSize:14];
    followName.textColor = [UIColor whiteColor];
    followName.text = @"关注";
    self.followCount = followCount;
    
    UIButton *circleButton = [UIButton new];
    [circleButton addTarget:self action:@selector(circleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *circleCount = [UILabel new];
    circleCount.font = [UIFont fontWithName:@"Alfa Slab One" size:16];
    circleCount.textColor = [UIColor whiteColor];
    //circleCount.text = @"1231";
    UILabel *circleName = [UILabel new];
    circleName.font = [UIFont systemFontOfSize:14];
    circleName.textColor = [UIColor whiteColor];
    circleName.text = @"圈子";
    self.circleCount = circleCount;
    
    AGGradientView *trendContainer = [AGGradientView new];
    trendContainer.colors = @[[UIColor getColor:@"1b2233"], [UIColor getColor:@"121621"]];
    trendContainer.startPoint = CGPointMake(0.44, 0);
    trendContainer.endPoint = CGPointMake(0.65, 1);
    trendContainer.locations = @[@0, @1];
    trendContainer.layer.cornerRadius = 9;
    self.trendContainer = trendContainer;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(129, 230);
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *trendsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    trendsCollectionView.delegate = self;
    trendsCollectionView.dataSource = self;
    [trendsCollectionView registerClass:[AGTrendsCollectionViewCell class] forCellWithReuseIdentifier:kAGTrendsCollectionViewIdentifier];
    trendsCollectionView.backgroundColor = [UIColor clearColor];
    trendsCollectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _trendsCollectionView = trendsCollectionView;
    
    UIButton *viewTrendsButton = [UIButton new];
    viewTrendsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [viewTrendsButton setImage:[UIImage imageNamed:@"circle-arrow"] forState:UIControlStateNormal];
    [viewTrendsButton setTitle:@"查看所有动态" forState:UIControlStateNormal];
    [viewTrendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    viewTrendsButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    self.viewTrendsButton = viewTrendsButton;
    self.viewTrendsButton.hidden = YES;
    
    AGMineViewBannerView *banner = [AGMineViewBannerView new];
    self.banner = banner;
    
    __WeakObject(self);
    banner.didSelectedHandle = ^(NSString * _Nonnull urlString) {
        __WeakStrongObject();
        
        [__strongObject gotoWebViewWithUrlStr:urlString];
    };
    
    UIView *serviceDot = [[UIView alloc] init];
    serviceDot.backgroundColor = [UIColor whiteColor];
    serviceDot.layer.cornerRadius = 3.5;
    
    UILabel *myService = [UILabel new];
    myService.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    myService.textColor = [UIColor whiteColor];
    myService.text = @"我的服务";
    
    UICollectionViewFlowLayout *serviceLayout = [[UICollectionViewFlowLayout alloc] init];
    //serviceLayout.itemSize = CGSizeMake(ceil((screenWidth - 36)/2), 80);
    serviceLayout.minimumLineSpacing = 12;
    serviceLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *serviceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:serviceLayout];
    serviceCollectionView.delegate = self;
    serviceCollectionView.dataSource = self;
    [serviceCollectionView registerClass:[AGServiceCollectionViewCell class] forCellWithReuseIdentifier:kAGServiceCollectionViewIdentifier];
    serviceCollectionView.backgroundColor = [UIColor clearColor];
    serviceCollectionView.scrollEnabled = false;
    serviceCollectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _serviceCollectionView = serviceCollectionView;
    
    //NSInteger cellCount = serviceItems.count;
    NSInteger cellCount = serviceItems.count / 2 + ((serviceItems.count % 2 > 0) ? 1 : 0);
    CGFloat serviceCollectionViewHeight = /*serviceLayout.itemSize.height*/80.f * cellCount + 12.f * (cellCount - 1);
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:scrollView];
    [scrollView addSubview:containerView];
    [containerView addSubview:avatar];
    //[containerView addSubview:self.mChargeButton];
    [containerView addSubview:level];
    [containerView addSubview:userName];
//    [containerView addSubview:wealthContainer];
//    [wealthContainer addSubview:self.mDiamondButton];
//    [wealthContainer addSubview:self.mCoinButton];
//    [wealthContainer addSubview:diamonButton];
//    [wealthContainer addSubview:goldButton];
//    [wealthContainer addSubview:pointButton];
    [containerView addSubview:relationView];
    [relationView addSubview:relationBackground];
    [relationView addSubview:fansButton];
    [fansButton addSubview:fansCount];
    [fansButton addSubview:fansName];
    [relationView addSubview:followButton];
    [followButton addSubview:followName];
    [followButton addSubview:followCount];
    [relationView addSubview:circleButton];
    [circleButton addSubview:circleCount];
    [circleButton addSubview:circleName];
    [containerView addSubview:trendContainer];
    [trendContainer addSubview:trendsCollectionView];
    [trendContainer addSubview:viewTrendsButton];
    [containerView addSubview:banner];
    [containerView addSubview:serviceDot];
    [containerView addSubview:myService];
    [containerView addSubview:serviceCollectionView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(self.view);
    }];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(69);
        make.centerX.equalTo(containerView);
        make.size.mas_equalTo(70);
    }];
    
    /*
    [self.mChargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.centerY.equalTo(avatar);
        make.right.equalTo(containerView).offset(- 12.f);
    }];
     */
    
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatar);
        make.size.mas_equalTo(CGSizeMake(50, 18));
        make.bottom.equalTo(avatar).offset(10);
    }];
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatar);
        make.top.equalTo(avatar.mas_bottom).offset(12);
    }];
    
//    [wealthContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(userName.mas_bottom).offset(15);
//        make.left.mas_equalTo(23);
//        make.right.mas_equalTo(-23);
//        make.height.mas_equalTo(40);
//    }];
    
//    [self.mCoinButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.center.equalTo(wealthContainer);
//    }];
    
//    NSArray<AGWealthButton *> *buttons = @[diamonButton, goldButton, pointButton];
//    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(wealthContainer);
//    }];
//
//    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    
    [relationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        //make.top.equalTo(wealthContainer.mas_bottom).offset(19);
        make.top.equalTo(userName.mas_bottom).offset(19);
        make.height.mas_equalTo(63);
    }];
    
    [relationBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(relationView);
    }];
    
    [fansCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fansButton);
        make.top.mas_equalTo(10);
    }];
    
    [fansName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fansButton);
        make.bottom.mas_equalTo(-8);
    }];
    
    [followCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(followButton);
        make.top.mas_equalTo(10);
    }];
    
    [followName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(followButton);
        make.bottom.mas_equalTo(-8);
    }];
    
    [circleCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleButton);
        make.top.mas_equalTo(10);
    }];
    
    [circleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(circleButton);
        make.bottom.mas_equalTo(-8);
    }];
    
    NSArray <UIButton *> *relationButtons = @[fansButton, followButton, circleButton];
    
    [relationButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(relationView);
    }];
    
    [relationButtons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [trendContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(relationView.mas_bottom);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        //make.height.mas_equalTo(300);
        make.height.mas_equalTo(0.f);
    }];
    
    [trendsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        //make.height.mas_equalTo(230);
        make.height.mas_equalTo(0.f);
        make.left.right.equalTo(trendContainer);
    }];
    
    [viewTrendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(trendsCollectionView.mas_bottom);
        make.left.right.bottom.equalTo(trendContainer);
    }];
    
    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(trendContainer.mas_bottom).offset(14);
        make.left.right.equalTo(trendContainer);
        //make.height.mas_equalTo(120.f);
        make.height.mas_equalTo(0.f);
    }];
    
    [serviceDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom).offset(33);
        make.size.mas_equalTo(CGSizeMake(7, 7));
        make.left.equalTo(banner);
    }];
    
    [myService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceDot);
        make.left.equalTo(serviceDot.mas_right).offset(8);
    }];
    
    [serviceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceDot.mas_bottom).offset(17);
        make.left.right.equalTo(containerView);
        make.height.mas_equalTo(serviceCollectionViewHeight);
        //make.bottom.mas_equalTo(-142);
        make.bottom.mas_equalTo(-12);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //[self.wealthContainer layoutIfNeeded];
    [self centerCoinView];
}

- (void)centerCoinView {
    
    /*
    CGFloat originX = (self.wealthContainer.width - self.mDiamondButton.width - self.mCoinButton.width - 8.f) / 2;
    self.mDiamondButton.left = originX;
    self.mCoinButton.left = self.mDiamondButton.right + 8.f;
    
    self.mDiamondButton.centerY = self.mCoinButton.centerY = self.wealthContainer.height / 2.f;
     */
    //self.mDiamondButton.center = CGPointMake(self.wealthContainer.width / 2.f, self.wealthContainer.height / 2.f);
}

#pragma mark - Refresh
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestMemberUserInfoData];
    [self requestMemberMyCircleData];
    [self requestBannerData];
}

#pragma mark -
- (void)reloadUserInfoData {
    
    if(self.mMUIHttp.mBase) {
        
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringSafeChecking:self.mMUIHttp.mBase.data.member.avatar]] forState:UIControlStateNormal];
        
        NSString *level = self.mMUIHttp.mBase.data.member.level;
        if([NSString isNotEmptyAndValid:level] &&
           [level integerValue] > 0) {
            self.level.hidden = NO;
            self.level.image = [UIImage imageNamed:[NSString stringWithFormat:@"user_level_%@", level]];
        }
        else {
            self.level.hidden = YES;
        }
        
        self.userName.text = [NSString stringSafeChecking:self.mMUIHttp.mBase.data.member.nickname];
        
        self.fansCount.text = [NSString stringSafeChecking:self.mMUIHttp.mBase.data.fansCount];
        self.followCount.text = [NSString stringSafeChecking:self.mMUIHttp.mBase.data.focusCount];
        self.circleCount.text = [NSString stringSafeChecking:self.mMUIHttp.mBase.data.groupCount];
        
        //[self.goldButton setAmount:self.mMUIHttp.mBase.data.member.goldCoin];
        //[self.mDiamondButton setValue:[HelpTools checkNumberInfo:self.mMUIHttp.mBase.data.member.money]];
        //[self.mCoinButton setValue:[HelpTools checkNumberInfo:self.mMUIHttp.mBase.data.member.goldCoin]];
        
        [self centerCoinView];
    }
}

- (void)reloadUserMyCircleData {
    
    if(self.mMMCHttp.mBase &&
       self.mMMCHttp.mBase.data &&
       self.mMMCHttp.mBase.data.data.count) {
        
        [self.trendContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
        }];
        
        [self.trendsCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(230);
        }];
    }
}

- (void)reloadUserBannerData {
    
    if(self.mSBHttp.mBase &&
       self.mSBHttp.mBase.data &&
       self.mSBHttp.mBase.data.count) {
        
        [self.banner mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(120.f);
        }];
        
        self.banner.data = self.mSBHttp.mBase.data;
    }
}

#pragma mark - GOTO
- (void)gotoTakePhoto {
    
    BLImagePickerViewController *imgVc = [[BLImagePickerViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:imgVc];
    imgVc.navColor = [UIColor whiteColor];
    imgVc.navTitleColor = [UIColor blackColor333333];
    
    imgVc.imageClipping = NO;
    imgVc.showCamera = YES;
    imgVc.maxNum = 1;
    imgVc.maxScale = 2.0;
    imgVc.minScale = 0.5;
    
    __WeakObject(self);
    [imgVc initDataProgress:^(CGFloat progress) {
        
        [HelpTools showLoadingForView:self.view.window];
        
    } finished:^(NSArray<UIImage *> *resultAry, NSArray<PHAsset *> *assetsArry, UIImage *editedImage) {
        __WeakStrongObject();
        
        NSMutableArray *imagePathArray = [NSMutableArray arrayWithCapacity:resultAry.count];
        for (int i = 0; i < resultAry.count; ++i) {
            
            UIImage *image = resultAry[i];
            NSString *cacheFilePath = [[PathTools getDataCacheFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"pics_user.png"]];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            BOOL isOK = [data writeToFile:cacheFilePath atomically:YES];
            if(isOK){
                
                [imagePathArray addObject:cacheFilePath];
            }
        }
        
        [HelpTools hideLoadingForcibleWithVIew:self.view.window];
        
        if(imagePathArray.count != resultAry.count){
            
            [HelpTools showHUDOnlyWithText:@"图片选取失败, 请重新选择" toView:__strongObject.view];
        }
        else {
            //__strongObject.selectedImages = imagePathArray;
            
            [__strongObject requestUploadPicsWithPicpaths:imagePathArray nikeName:nil];
        }

    } cancle:^(NSString *cancleStr) {
        
        DLOG(@"取消了");
        [HelpTools hideLoadingForcibleWithVIew:self.view.window];
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)gotoWebViewWithUrlStr:(NSString *)urlString {
    /*
     /pages/gamehome  // 进入游戏主页
     /pages/gamelist?categoryId=123 // 进入对应的分类游戏列表
     */
    urlString = @"/pages/gamehome";
    
    if([urlString hasPrefix:@"http"]) {
        
        ABWebsiteViewController *webVC = [[ABWebsiteViewController alloc] initWithUrl:urlString];
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if([urlString hasPrefix:@"/pages"]){
        NSString *appView = @"";
        if([urlString rangeOfString:@"?"].location == NSNotFound) {
            
            appView = urlString;
        }
        else {
            NSArray *appViewArray = [urlString componentsSeparatedByString:@"?"];
            if(appViewArray && appViewArray.count){
                
                appView = appViewArray.firstObject;
            }
        }
        
        if([NSString isNotEmptyAndValid:appView]) {
            
            if([appView hasPrefix:@"/pages/postdetail"]) {
                // 帖子详情
                NSDictionary *params = [HelpTools getURLParams:urlString];
                
                if(params && params.count) {
                    
                    NSString *title = @"";
                    if([params.allKeys containsObject:@"title"]){
                        
                        title = params[@"title"];
                    }
                    
                    NSString *dynamicid = @"";
                    if([params.allKeys containsObject:@"dynamicid"]){
                        
                        dynamicid = params[@"dynamicid"];
                    }
                    
                    if([NSString isNotEmptyAndValid:title] &&
                       [NSString isNotEmptyAndValid:dynamicid]) {
                        
                        AGHomePostDetailViewController *AGHPDVC = [AGHomePostDetailViewController new];
                        AGHPDVC.postDynamicId = dynamicid;
                        AGHPDVC.postTitle = title;
                        
                        [self.navigationController pushViewController:AGHPDVC animated:YES];
                    }
                }
            }
            else if([appView hasPrefix:@"/pages/game"]) {
                // 游戏
                NSDictionary *params = [HelpTools getURLParams:urlString];
                
                if(params && params.count) {
                    
                    NSString *machinesn = @"";
                    if([params.allKeys containsObject:@"machinesn"]){
                        
                        machinesn = params[@"machinesn"];
                    }
                    
                    NSString *roomid = @"";
                    if([params.allKeys containsObject:@"roomid"]){
                        
                        roomid = params[@"roomid"];
                    }
                    
                    NSString *machinetype = @"";
                    if([params.allKeys containsObject:@"machinetype"]){
                        
                        machinetype = params[@"machinetype"];
                    }
                    
                    if([NSString isNotEmptyAndValid:machinesn] &&
                       [NSString isNotEmptyAndValid:roomid] &&
                       [NSString isNotEmptyAndValid:machinetype]) {
                        

                    }
                }
            }
            else if([appView hasPrefix:@"/pages/gamehome"]){
                // 游戏首页
                AGGameViewController *AGGVC = [AGGameViewController new];
                [self.navigationController pushViewController:AGGVC animated:YES];
            }
            else if([appView hasPrefix:@"/pages/gamelist"]) {
                // 游戏列表
                NSDictionary *params = [HelpTools getURLParams:urlString];
                
                if(params && params.count) {
                    
                    NSString *categoryId = @"";
                    if([params.allKeys containsObject:@"categoryId"]){
                        
                        categoryId = params[@"categoryId"];
                    }
                    
                    if([NSString isNotEmptyAndValid:categoryId]) {
                        
                        AGGameListViewController *AGGLVC = [AGGameListViewController new];
                        AGGLVC.categoryId = categoryId;
                        
                        [self.navigationController pushViewController:AGGLVC animated:YES];
                    }
                }
            }
        }
    }
}

//- (void)gotoRechargeView {
//
//    AGRechargeViewController *rechargeVC = [AGRechargeViewController new];
//    [self.navigationController pushViewController:rechargeVC animated:YES];
//}

- (void)gotoMineCircleViewController {
    
    [self.navigationController pushViewController:[AGMineCircleViewController new] animated:YES];
}

#pragma mark - Selector
- (void)avatarClick:(UIButton *)button {
    /*
     AGLoginViewController *loginVc = [AGLoginViewController new];
     loginVc.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:loginVc animated:YES completion:nil];
     */
    
    [self gotoTakePhoto];
}

- (void)userNameTapGestureAction:(UITapGestureRecognizer *)gesture {
    
    AGAlertPopView *alertPopView = [[AGAlertPopView alloc] initWithType:AGAlertType_Usermodify title:@"" info:@"" confirmButton:@"确定" cancelButton:@"取消" autoClose:NO];
    alertPopView.textFieldText = self.mMUIHttp.mBase.data.member.nickname;
    [alertPopView show];
    
    __WeakObject(self);
    alertPopView.confirmTextBlock = ^(NSString * _Nonnull textFieldText) {
        __WeakStrongObject();
        
        [__strongObject requestUserEditWithImages:nil nikeName:textFieldText];
    };
}

- (void)fansButtonAction:(UIButton *)button {
    
    [self.navigationController pushViewController:[AGMineFansViewController new] animated:YES];
}

- (void)followButtonAction:(UIButton *)button {
    
    [self.navigationController pushViewController:[AGMineAttentionViewController new] animated:YES];
}

- (void)circleButtonAction:(UIButton *)button {
    
    [self gotoMineCircleViewController];
}

- (void)wealthButtonAction:(UIControl *)button {
    
    if(button == self.goldButton) {
        
//        [self gotoRechargeView];
    }
}

- (void)mCoinButtonAction:(UIControl *)button {
    
//    [self gotoRechargeView];
}

- (void)mChargeButtonAction:(UIButton *)button {
    
//    [self gotoRechargeView];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.trendsCollectionView) {
        AGTrendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGTrendsCollectionViewIdentifier forIndexPath:indexPath];
        return cell;
    }
    else {
        AGServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAGServiceCollectionViewIdentifier forIndexPath:indexPath];
        cell.serviceItem = serviceItems[indexPath.row];
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.trendsCollectionView) {
        return 0;
    }
    else {
        return serviceItems.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    if(collectionView == self.serviceCollectionView) {
        
        return CGSizeMake((collectionView.width - 12.f * 2 - 12.f) / 2.f, 80.f);
        //return CGSizeMake((collectionView.width - 12.f * 2), 80.f);
    }
    else {
        
        return CGSizeMake(129, 230);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AGServiceItem *item = serviceItems[indexPath.row];
    
    if ([@"settings" isEqualToString:item.serviceType]) {
        [self.navigationController pushViewController:[AGSettingViewController new] animated:YES];
    }
    else if([@"message" isEqualToString:item.serviceType]) {
        
        [self.navigationController pushViewController:[AGMineMessageViewController new] animated:YES];
    }
    else if([@"friend-contact" isEqualToString:item.serviceType]) {
        
    }
    else if([@"friend-invite" isEqualToString:item.serviceType]) {
        
        [self requestMemberInviteInfoData];
    }
    else if([@"contactus" isEqualToString:item.serviceType]) {
        //联系我们
        NSString *qqString = @"1231231231";
        [UIPasteboard generalPasteboard].string = qqString;
        AGAlertPopView *alertPopView = [[AGAlertPopView alloc] initWithType:AGAlertType_Defalut title:@"联系我们" info:[NSString stringWithFormat:@"请联系这个QQ号码:%@\n\n(号码已复制到粘贴板)", qqString] confirmButton:@"确定" cancelButton:@"" autoClose:NO];
        [alertPopView show];
    }
    else if([@"palyercomminicate" isEqualToString:item.serviceType]) {
        //玩家交流群
        NSString *qqString = @"928314338";
        AGAlertPopView *alertPopView = [[AGAlertPopView alloc] initWithType:AGAlertType_Defalut title:@"玩家交流群" info:[NSString stringWithFormat:@"加入我们的QQ群:%@\n\n(号码已复制到粘贴板)", qqString] confirmButton:@"确定" cancelButton:@"" autoClose:NO];
        [alertPopView show];
    }
    else if([@"feedback" isEqualToString:item.serviceType]) {
        //意见反馈
        [self.navigationController pushViewController:[AGMineFeedbackViewController new] animated:YES];
    }
}

#pragma mark - Request
- (void)requestUploadPicsWithPicpaths:(NSArray *)picPaths nikeName:(NSString *)nikeName {
    
    if(!picPaths || !picPaths.count) {
        
        [self requestUserEditWithImages:nil nikeName:nikeName];
        return;
    }
    
    __block NSMutableArray *mutablePicPaths = [NSMutableArray arrayWithCapacity:picPaths.count];
    __block NSInteger uploadCount = 0;
    
    for (int i = 0; i < picPaths.count; ++i) {
        
        NSString *picPath = picPaths[i];
        uploadCount += 1;
        
        __block AGServiceUploadImageHttp *suiHttp = [AGServiceUploadImageHttp new];
        [suiHttp setFilePath:picPath];
        
        __WeakObject(self);
        [HelpTools showLoadingForView:self.view];
        
        [suiHttp requestServiceUploadImageResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
                   
            __WeakStrongObject();
            [HelpTools hideLoadingForView:__strongObject.view];
            
            if(isSuccess){
                
                [mutablePicPaths addObject:[NSString stringSafeChecking:suiHttp.mBase.data]];
            }
            else {
                [HelpTools showHttpError:responseObject];
            }
            
            if(uploadCount == picPaths.count) {
                
                if(mutablePicPaths.count == 0) {
                    
                    [HelpTools showHUDOnlyWithText:@"图片上传失败，请稍后重试！" toView:__strongObject.view];
                }
                else {
                    if(mutablePicPaths.count != picPaths.count) {
                        
                        [HelpTools showHUDOnlyWithText:@"部分图片上传失败!" toView:__strongObject.view];
                    }
                    
                    [__strongObject requestUserEditWithImages:mutablePicPaths nikeName:nikeName];
                }
            }
        }];
    }
}

- (void)requestUserEditWithImages:(NSArray *)images nikeName:(NSString *)nikeName {
    
    BOOL shouldRequest = YES;
    NSString *imageReStr = @"";
    NSString *lastNikeName = @"";
    
    if([NSString isNotEmptyAndValid:nikeName]) {
        
        if([nikeName isEqualToString:self.mMUIHttp.mBase.data.member.nickname]) {
            
            shouldRequest = NO;
        }
        
        lastNikeName = nikeName;
    }
    else if(images && images.count) {
        
        imageReStr = images.firstObject;
        lastNikeName = self.mMUIHttp.mBase.data.member.nickname;
    }
    else {
        shouldRequest = NO;
    }
    
    if(!shouldRequest) return;
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mMUIEHttp.avatar = imageReStr;
    self.mMUIEHttp.nickName = lastNikeName;
    
    [self.mMUIEHttp requestMemberUserInfoEditResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
          
        __WeakStrongObject();
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools showHUDOnlyWithText:@"更新成功" toView:__strongObject.view];
            __strongObject.mMUIHttp.mBase.data.member.nickname = lastNikeName;
            
            if([NSString isNotEmptyAndValid:imageReStr]) {
                __strongObject.mMUIHttp.mBase.data.member.avatar = imageReStr;
            }
            
            [__strongObject reloadUserInfoData];
        }
        else {
            [HelpTools showHttpError:responseObject];
        }
    }];
}

- (void)requestMemberUserInfoData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mMUIHttp requestMemberUserInfoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadUserInfoData];
        }
        else {
            if(!__strongObject.mMUIHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestMemberMyCircleData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mMMCHttp requestMemberMyCircleResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadUserMyCircleData];
        }
        else {
            if(!__strongObject.mMMCHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestBannerData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mSBHttp requestServiceBannerResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject reloadUserBannerData];
        }
        else {
            if(!__strongObject.mMMCHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (void)requestMemberInviteInfoData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    [self.mMIIHttp requestMemberInviteInfoResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [UIPasteboard generalPasteboard].string = __strongObject.mMIIHttp.mBase.data.code;
            [HelpTools showHUDOnlyWithText:@"邀请码已复制到粘贴板" toView:__strongObject.view];
        }
        else {
            if(!__strongObject.mMIIHttp.mBase){
                
            }
            
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGMemberUserInfoHttp *)mMUIHttp {
    
    if(!_mMUIHttp) {
        
        _mMUIHttp = [AGMemberUserInfoHttp new];
    }
    
    return _mMUIHttp;
}

- (AGMemberMyCircleHttp *)mMMCHttp {
    
    if(!_mMMCHttp) {
        
        _mMMCHttp = [AGMemberMyCircleHttp new];
    }
    
    return _mMMCHttp;
}

- (AGServiceBannerHttp *)mSBHttp {
    
    if(!_mSBHttp) {
        
        _mSBHttp = [AGServiceBannerHttp new];
    }
    
    return _mSBHttp;
}

- (AGMemberUserInfoEditHttp *)mMUIEHttp {
    
    if(!_mMUIEHttp) {
        
        _mMUIEHttp = [AGMemberUserInfoEditHttp new];
    }
    
    return _mMUIEHttp;
}

- (AGMemberInviteInfoHttp *)mMIIHttp {
    
    if(!_mMIIHttp) {
        
        _mMIIHttp = [AGMemberInviteInfoHttp new];
    }
    
    return _mMIIHttp;
}

- (UIButton *)mChargeButton {
    
    if(!_mChargeButton) {
        
        _mChargeButton = [UIButton new];
        _mChargeButton.size = CGSizeMake(70.f, 32.f);
        _mChargeButton.layer.cornerRadius = 7.f;
        _mChargeButton.clipsToBounds = YES;
        
        [_mChargeButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mChargeButton.size colors:@[UIColorFromRGB(0x2BDD9A), UIColorFromRGB(0x36CBD1)] gradientType:1] forState:UIControlStateNormal];
        [_mChargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mChargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _mChargeButton.titleLabel.font = [UIFont font15];
        
        [_mChargeButton addTarget:self action:@selector(mChargeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mChargeButton;
}

@end

/**
 * AGMineViewBannerView
 */
@interface AGMineViewBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *mContainerCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *mContainerLayout;

@end

@implementation AGMineViewBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.mContainerCollectionView registerClass:[AGMineViewBannerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([AGMineViewBannerCollectionViewCell class])];
        [self addSubview:self.mContainerCollectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerCollectionView.frame = self.bounds;
}

- (void)setData:(NSArray<AGServiceBannerData *> *)data {
    _data = data;
    
    [self.mContainerCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellWidth = collectionView.width;
    CGFloat cellHeight = collectionView.height;
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if(section == 0) {
        
        return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    }
    
    return UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AGMineViewBannerCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AGMineViewBannerCollectionViewCell class]) forIndexPath:indexPath];
    
    collectionCell.data = [self.data objectAtIndexForSafe:indexPath.item];
    
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AGServiceBannerData *data = [self.data objectAtIndexForSafe:indexPath.item];
    if(data && self.didSelectedHandle) {
        
        self.didSelectedHandle(data.url);
    }
}

#pragma mark - Getter
- (UICollectionView *)mContainerCollectionView{
    
    if(!_mContainerCollectionView){
        
        _mContainerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.mContainerLayout];
        
        _mContainerCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mContainerCollectionView.backgroundColor = [UIColor clearColor];
        _mContainerCollectionView.showsHorizontalScrollIndicator = NO;
        _mContainerCollectionView.showsVerticalScrollIndicator = NO;
        _mContainerCollectionView.pagingEnabled = YES;
        _mContainerCollectionView.scrollsToTop = NO;
        _mContainerCollectionView.dataSource = self;
        _mContainerCollectionView.delegate = self;
    }
    
    return _mContainerCollectionView;
}

- (UICollectionViewFlowLayout *)mContainerLayout{
    
    if(!_mContainerLayout){
        
        _mContainerLayout = [UICollectionViewFlowLayout new];
        _mContainerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mContainerLayout.minimumInteritemSpacing = 12.f;
    }
    
    return _mContainerLayout;
}

@end

/**
 * AGMineViewBannerCollectionViewCell
 */
@interface AGMineViewBannerCollectionViewCell ()

@property (strong, nonatomic) CarouselImageView *mContentImageView;

@end

@implementation AGMineViewBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.mContentImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContentImageView.frame = self.bounds;
}

- (void)setData:(AGServiceBannerData *)data {
    _data = data;
    
    [self.mContentImageView setImageWithObject:[NSString stringSafeChecking:data.imgUrl] withPlaceholderImage:IMAGE_NAMED(@"default_square_image") interceptImageModel:INTERCEPT_CENTER correctRect:nil];
}

- (CarouselImageView *)mContentImageView {
    
    if(!_mContentImageView) {
        
        _mContentImageView = [CarouselImageView new];
        _mContentImageView.userInteractionEnabled = YES;
        _mContentImageView.layer.cornerRadius = 10.f;
        _mContentImageView.clipsToBounds = YES;
        _mContentImageView.ignoreCache = YES;
    }
    
    return _mContentImageView;
}

@end
