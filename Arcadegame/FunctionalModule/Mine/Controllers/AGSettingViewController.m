//
//  AGSettingViewController.m
//  Arcadegame
//
//  Created by Sean on 2023/6/22.
//

#import "AGSettingViewController.h"
#import "ABWebsiteViewController.h"
#import "AGSettingTableViewCell.h"
#import "Masonry.h"
#import "AGMemberHttp.h"

static NSArray<AGSettingItem *> *settings;
static NSString * kAGSettingTableViewIdentifier = @"kAGSettingTableViewIdentifier";

@interface AGSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) AGMemberMemberDeleteHttp *mMDHttp;

@end

@implementation AGSettingViewController

+ (void)initialize {
    settings = @[[[AGSettingItem alloc] initWithType:@"protocol" name:@"用户协议" icon:@"setting-portocol"],
                 [[AGSettingItem alloc] initWithType:@"privacy" name:@"隐私协议" icon:@"setting-privacy"],
                 [[AGSettingItem alloc] initWithType:@"unsubcribe" name:@"注销账户" icon:@"setting-unsubscribe"],
                 [[AGSettingItem alloc] initWithType:@"exit" name:@"退出登录" icon:@"setting-exit"]
    ];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//    appearance.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]};
//    appearance.backgroundColor = [UIColor clearColor];
//    self.title = @"设置";
//    self.navigationController.navigationBar.standardAppearance = appearance;
//    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//
//    self.navigationController.navigationBarHidden = NO;
////    [self.navigationController.navigationBar ]
//    self.navigationItem.title = @"设置";
    [self setLeftNaviBarButton];
    self.titleString = @"设置";
    [self initUI];
}

- (void)initUI {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-bg"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[AGSettingTableViewCell class] forCellReuseIdentifier:kAGSettingTableViewIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView = tableView;
    
    [self.view insertSubview:backgroundView atIndex:0];
    [self.view addSubview:tableView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mAGNavigateView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAGSettingTableViewIdentifier];
    cell.setting = settings[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settings.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AGSettingItem *item = settings[indexPath.row];
    
    if([@"protocol" isEqualToString:item.settingName]) {
        
        [self goToServiceWebViewIsPrivacy:NO];
    }
    else if([@"privacy" isEqualToString:item.settingName]) {
        
        [self goToServiceWebViewIsPrivacy:YES];
    }
    else if([@"unsubcribe" isEqualToString:item.settingName]) {
        
        __WeakObject(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注销账号您的数据也会同步销毁！请确认！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __WeakStrongObject();
            
            [__strongObject requestMemberMemberDeleteData];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([@"exit" isEqualToString:item.settingName]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请确认是否退出！" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [HelpTools cleanUserDataCache];
            [NotificationCenterHelper postNotifiction:NotificationCenterRelogin userInfo:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - GOTO
- (void)goToServiceWebViewIsPrivacy:(BOOL)IsPrivacy{
    
    NSString *titleString = @"用户协议";
    NSString *serviceUrl = URL_ARCADEGAME_USER_LINK;
    if(IsPrivacy){
        titleString = @"隐私政策";
        serviceUrl = URL_ARCADEGAME_POLICY_LINK;
    }
    
    ABWebsiteViewController *webVC = [[ABWebsiteViewController alloc] initWithUrl:serviceUrl];
    webVC.naviTitleString = titleString;
    
    //[self.navigationController pushViewController:webVC animated:YES];
    
    //UINavigationController *webNaviVC = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self presentViewController:webVC animated:YES completion:nil];
}

#pragma mark - Request
- (void)requestMemberMemberDeleteData {
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    [self.mMDHttp requestMemberMemberDeleteResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
            
        __WeakStrongObject();
        [__strongObject refreshDidFinishRefresh:nil];
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [HelpTools cleanUserDataCache];
            [NotificationCenterHelper postNotifiction:NotificationCenterRelogin userInfo:nil];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
        }
    }];
}

- (AGMemberMemberDeleteHttp *)mMDHttp {
    
    if(!_mMDHttp) {
        
        _mMDHttp = [AGMemberMemberDeleteHttp new];
    }
    
    return _mMDHttp;
}

@end
