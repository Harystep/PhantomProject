//
//  AGLoginViewController.m
//  Arcadegame
//
//  Created by rrj on 2023/6/19.
//

#import "AGLoginViewController.h"
#import "Masonry.h"

#import <AuthenticationServices/AuthenticationServices.h>
#import "PrivacyWebViewController.h"
#import "AGMemberHttp.h"

typedef NS_ENUM(NSInteger, AGLoginState) {
    AGLoginStateOneKey,
    AGLoginStateNumber,
    AGLoginState_AppleID
};

@interface AGLoginViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (assign, nonatomic) AGLoginState currentLoginState;
@property (strong, nonatomic) UIView *loginContentView;
@property (strong, nonatomic) UILabel *loginTitle;
@property (strong, nonatomic) UILabel *loginTip;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UILabel *agreementLabel;
@property (strong, nonatomic) UIButton *appleLoginButton;
@property (strong, nonatomic) UIButton *phoneLoginButton;
@property (strong, nonatomic) UITextField *phoneNumberField;
@property (strong, nonatomic) UITextField *codeField;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) AGMemberLoginAppleHttp *mMLAHttp;
@property (strong, nonatomic) AGMemberLoginAliYunHttp *mMLATHttp;
@property (strong, nonatomic) AGMemberLoginPhoneNumHttp *mMLPNHttp;

@end

@implementation AGLoginViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
        
}

- (void)initUI {
    self.view.clipsToBounds = YES;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-bg"]];
    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIButton *backButton = [UIButton new];
    [backButton setImage:[UIImage imageNamed:@"navi_back_normal"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = backButton;
    backButton.hidden = YES;
    
    UIView *loginContentView = [UIView new];
    _loginContentView = loginContentView;
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:loginContentView];
    [self.view addSubview:backButton];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [loginContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([HelpTools safeAreaInsetsTop]);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    [self initOneKeyLogin];
}

- (void)initOneKeyLogin {
    self.currentLoginState = AGLoginStateOneKey;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *loginContentView = self.loginContentView;
    UILabel *loginTitle = [UILabel new];
    loginTitle.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    loginTitle.textColor = [UIColor whiteColor];
    loginTitle.text = @"欢迎登录";
    _loginTitle = loginTitle;
    
    UILabel *loginTip = [UILabel new];
    loginTip.font = [UIFont systemFontOfSize:18];
    loginTip.textColor = [UIColor getColor:@"BDBFC7"];
    loginTip.text = @"登录后更精彩";
    _loginTip = loginTip;
    
    UIButton *loginButton = [UIButton new];
    [loginButton setBackgroundImage:[HelpTools createGradientImageWithSize:CGSizeMake(screenWidth - 40, 55) colors:@[[UIColor getColor:@"3ee3d1"], [UIColor getColor:@"31e79d"]] gradientType:1] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [loginButton setTitle:@"一键手机号登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 10;
    loginButton.layer.masksToBounds = YES;
    _loginButton = loginButton;
    
    UILabel *agreementLabel = [UILabel new];
    agreementLabel.font = [UIFont systemFontOfSize:14];
    agreementLabel.textColor = [UIColor whiteColor];
    agreementLabel.text = @"登录注册即代表您同意《用户协议和隐私政策》";
    _agreementLabel = agreementLabel;
    
    UIView *loginButtonView = [UIView new];
    
    UIButton *appleLoginButton = [UIButton new];
    [appleLoginButton setImage:[UIImage imageNamed:@"apple-login"] forState:UIControlStateNormal];
    [appleLoginButton addTarget:self action:@selector(onAppleLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    _appleLoginButton = appleLoginButton;
    
    UIButton *phoneLoginButton = [UIButton new];
    [phoneLoginButton setImage:[UIImage imageNamed:@"number-login"] forState:UIControlStateNormal];
    [phoneLoginButton addTarget:self action:@selector(onDoPhoneNumberLogin:) forControlEvents:UIControlEventTouchUpInside];
    _phoneLoginButton = phoneLoginButton;
    
    [loginContentView addSubview:loginTitle];
    [loginContentView addSubview:loginTip];
    [loginContentView addSubview:loginButton];
    [loginContentView addSubview:agreementLabel];
    [loginContentView addSubview:loginButtonView];
    [loginButtonView addSubview:appleLoginButton];
//    [loginButtonView addSubview:phoneLoginButton];
    
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(133);
        make.left.mas_equalTo(38);
    }];
    
    [loginTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginTitle.mas_bottom).offset(8);
        make.left.equalTo(loginTitle);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(55);
    }];
    
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginButton);
        make.top.equalTo(loginButton.mas_bottom).offset(14);
    }];
    
    [loginButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreementLabel.mas_bottom).offset(95);
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-50);
    }];
    
    [appleLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 52));
        make.top.left.bottom.equalTo(loginButtonView);
        make.centerX.equalTo(loginButtonView);
    }];
    
//    [phoneLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(appleLoginButton);
//        make.top.right.bottom.equalTo(loginButtonView);
//        make.left.equalTo(appleLoginButton.mas_right).offset(50);
//    }];
}

- (void)initNumberLoginPanel {
    self.currentLoginState = AGLoginStateNumber;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *loginContentView = self.loginContentView;
    UILabel *loginTitle = [UILabel new];
    loginTitle.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    loginTitle.textColor = [UIColor whiteColor];
    loginTitle.text = @"使用验证码登录";
    _loginTitle = loginTitle;
    
    UILabel *loginTip = [UILabel new];
    loginTip.font = [UIFont systemFontOfSize:18];
    loginTip.textColor = [UIColor getColor:@"BDBFC7"];
    loginTip.text = @"登录后更精彩";
    _loginTip = loginTip;
    
    UIButton *loginButton = [UIButton new];
    [loginButton setBackgroundImage:[HelpTools createGradientImageWithSize:CGSizeMake(screenWidth - 40, 55) colors:@[[UIColor getColor:@"3ee3d1"], [UIColor getColor:@"31e79d"]] gradientType:1] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 10;
    loginButton.layer.masksToBounds = YES;
    _loginButton = loginButton;

    UITextField *phoneNumberField = [UITextField new];
    phoneNumberField.textColor = [UIColor whiteColor];
    phoneNumberField.font = [UIFont systemFontOfSize:16];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"ffffff" alpha:0.37],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    phoneNumberField.attributedPlaceholder = attributedPlaceholder;
    phoneNumberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 55)];
    phoneNumberField.leftViewMode = UITextFieldViewModeAlways;
    phoneNumberField.backgroundColor = [UIColor getColor:@"1d2332"];
    phoneNumberField.layer.cornerRadius = 10;
    phoneNumberField.layer.masksToBounds = YES;
    _phoneNumberField = phoneNumberField;
    
    UITextField *codeField = [UITextField new];
    codeField.textColor = [UIColor whiteColor];
    codeField.font = [UIFont systemFontOfSize:16];
    attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"ffffff" alpha:0.37],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    codeField.attributedPlaceholder = attributedPlaceholder;
    codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 55)];
    codeField.leftViewMode = UITextFieldViewModeAlways;
    UIButton *codeButton = [[UIButton alloc] init];
    codeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    codeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeButton.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    [codeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    codeField.rightView = codeButton;
    codeField.rightViewMode = UITextFieldViewModeAlways;
    codeField.backgroundColor = [UIColor getColor:@"1d2332"];
    codeField.layer.cornerRadius = 10;
    codeField.layer.masksToBounds = YES;
    _codeField = codeField;
    
    [loginContentView addSubview:loginTitle];
    [loginContentView addSubview:loginTip];
    [loginContentView addSubview:phoneNumberField];
    [loginContentView addSubview:codeField];
    [loginContentView addSubview:loginButton];
    
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(133);
        make.left.mas_equalTo(38);
    }];
    
    [loginTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginTitle.mas_bottom).offset(8);
        make.left.equalTo(loginTitle);
    }];
    
    [phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.right.equalTo(loginButton);
        make.height.equalTo(loginButton);
        make.bottom.equalTo(codeField.mas_top).offset(-25);
    }];
    
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.right.equalTo(loginButton);
        make.height.equalTo(loginButton);
        make.bottom.equalTo(loginButton.mas_top).offset(-40);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(55);
        make.bottom.mas_equalTo(-105);
    }];
    
}

- (void)initAppleIDLoginPanel {
    self.currentLoginState = AGLoginState_AppleID;
    
    self.currentLoginState = AGLoginStateNumber;
    //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *loginContentView = self.loginContentView;
    UILabel *loginTitle = [UILabel new];
    loginTitle.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    loginTitle.textColor = [UIColor whiteColor];
    loginTitle.text = @"使用Apple ID 登录";
    _loginTitle = loginTitle;
    
    UILabel *loginTip = [UILabel new];
    loginTip.font = [UIFont systemFontOfSize:18];
    loginTip.textColor = [UIColor getColor:@"BDBFC7"];
    loginTip.text = @"登录后更精彩";
    _loginTip = loginTip;
    
    ASAuthorizationAppleIDButton *loginButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
    // 不小于 140 * 30
    loginButton.cornerRadius = 10;
    [loginButton addTarget:self action:@selector(appleIDLoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginContentView addSubview:loginTitle];
    [loginContentView addSubview:loginTip];
    [loginContentView addSubview:loginButton];
    
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(133);
        make.left.mas_equalTo(38);
    }];
    
    [loginTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginTitle.mas_bottom).offset(8);
        make.left.equalTo(loginTitle);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(55);
        make.bottom.mas_equalTo(-105);
    }];
}

- (void)onDoPhoneNumberLogin:(UIButton *)button {
    [self changeToLoginType:AGLoginStateNumber];
}

- (void)onAppleLoginButton:(UIButton *)button {
    [self changeToLoginType:AGLoginState_AppleID];
}

- (void)changeToLoginType:(AGLoginState)loginState {
    [self.loginContentView removeAllSubview];
    
    switch (loginState) {
        case AGLoginStateOneKey:
            
            self.backButton.hidden = YES;
            [self initOneKeyLogin];
            break;
            
        case AGLoginState_AppleID:
            
            self.backButton.hidden = NO;
            [self initAppleIDLoginPanel];
            break;
        default:
            self.backButton.hidden = NO;
            [self initNumberLoginPanel];
            break;
    }
}

#pragma mark - Selector
- (void)onClose:(UIButton *)button {
    if (self.currentLoginState == AGLoginStateOneKey) {
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
    } else {
        [self changeToLoginType:AGLoginStateOneKey];
    }
}

- (void)sendCode:(UIButton *)button {
    
}

- (void)appleIDLoginButtonAction:(ASAuthorizationAppleIDButton *)button {
    
    ASAuthorizationAppleIDProvider *appleIdProvider = [ASAuthorizationAppleIDProvider new];
    
    ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
    request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

- (void)loginButtonAction:(UIButton *)button {
    
//#if TARGET_IPHONE_SIMULATOR
//    self.loginSuccessHandle();
//#else
    if(self.currentLoginState == AGLoginStateOneKey) {

        [self requestAliYunGetPhoneToken];
    }
    else {
#warning 验证码登录
    }
//#endif
}

#pragma mark - ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        NSString *user = appleIDCredential.user;
        NSString *email = appleIDCredential.email;
        NSString *nickname = appleIDCredential.fullName.nickname;
        NSData *identityToken = appleIDCredential.identityToken;
        DLOG(@"apple id authorizationController user:%@, email:%@, nickname:%@, identityToken:%@", user, email, nickname, identityToken);
        
        [self requestMemberLoginAppleWithToken:[[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding]];
    }
    else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *psdCredential = (ASPasswordCredential *)authorization.credential;
        
        NSString *user = psdCredential.user;
        NSString *password = psdCredential.password;
        DLOG(@"ASPasswordCredential:%@<>%@", password, user);
    }
    else {
        [HelpTools showHUDOnlyWithText:@"授权信息不符" toView:self.view];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"ASAuthorizationErrorCanceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"ASAuthorizationErrorFailed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"ASAuthorizationErrorInvalidResponse";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"ASAuthorizationErrorNotHandled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"ASAuthorizationErrorUnknown";
            break;
    }
    
    DLOG(@"controller requests：%@", controller.authorizationRequests);
    
    if (errorMsg) {
        
        [HelpTools showHUDOnlyWithText:@"授权登录失败" toView:self.view];
    }
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    
    return self.view.window;
}

- (void)handleSignInWithAppleStateChanged:(id)notifi {
    
    DLOG(@"%s", __FUNCTION__);
    DLOG(@"%@", notifi);
}

#pragma mark - Request
- (void)requestAliYunGetPhoneToken {
    
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.backgroundImage = IMAGE_NAMED(@"app_back_image");
    model.backgroundImageContentMode = UIViewContentModeScaleAspectFill;
    model.navColor = [UIColor clearColor];
    model.navTitle = [[NSAttributedString alloc] initWithString:@""];
    model.numberColor = [UIColor whiteColor];
    model.navBackImage = IMAGE_NAMED(@"navi_back_normal");
    model.sloganIsHidden = YES;
    model.logoIsHidden = YES;
    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换到其他登录方式" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.size.width += 30.f;
        return frame;
    };
    model.privacyAlignment = NSTextAlignmentCenter;
    model.expandAuthPageCheckedScope = YES;
    model.privacyNavColor = UIColorFromRGB(0x262E42);
    model.privacyNavBackImage = IMAGE_NAMED(@"navi_back_normal");
    model.checkBoxImages = @[IMAGE_NAMED(@"uncheckedImg"), IMAGE_NAMED(@"checkedImg")];
    
    CGSize buttonSize = CGSizeMake(self.view.width - 20.f * 2, 50.f);
    model.loginBtnBgImgs = @[[HelpTools createGradientImageWithSize:buttonSize colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:0], [HelpTools createImageWithColor:[UIColor lightGrayColor] withRect:((CGRect){CGPointZero, buttonSize})], [HelpTools createGradientImageWithSize:buttonSize colors:@[[UIColorFromRGB(0x41E1E0) colorWithAlphaComponent:0.5], [UIColorFromRGB(0x31E79D) colorWithAlphaComponent:0.5]] gradientType:0]];
    
    
    __weak typeof(self) weakSelf = self;
    [HelpTools showLoadingForView:self.view];
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            DLOG(@"授权页拉起成功回调：%@", resultDic);
            
            [HelpTools hideLoadingForView:weakSelf.view];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginClickPrivacyAlertView isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClickContinue isEqualToString:resultCode] ||
                   [PNSCodeLoginPrivacyAlertViewClose isEqualToString:resultCode]) {
            DLOG(@"页面点击事件回调：%@", resultDic);
            
            if([resultCode isEqualToString:@"700001"]) {
                [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
            }
        }else if([PNSCodeLoginControllerClickProtocol isEqualToString:resultCode] ||
                 [PNSCodeLoginPrivacyAlertViewPrivacyContentClick isEqualToString:resultCode]){
            DLOG(@"页面点击事件回调：%@", resultDic);
            NSString *privacyUrl = [resultDic objectForKey:@"url"];
            NSString *privacyName = [resultDic objectForKey:@"urlName"];
            DLOG(@"如果TXCustomModel的privacyVCIsCustomized设置成YES，则SDK内部不会跳转协议页，需要自己实现");
            if(model.privacyVCIsCustomized){
                PrivacyWebViewController *controller = [[PrivacyWebViewController alloc] initWithUrl:privacyUrl andUrlName:privacyName];
                controller.isHiddenNavgationBar = NO;
                UINavigationController *navigationController = weakSelf.navigationController;
                if (weakSelf.presentedViewController) {
                    //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                    navigationController = (UINavigationController *)weakSelf.presentedViewController;
                }
                [navigationController pushViewController:controller animated:YES];
            }
        } else if ([PNSCodeLoginControllerSuspendDisMissVC isEqualToString:resultCode]) {
            DLOG(@"页面点击事件回调：%@", resultDic);
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            DLOG(@"获取LoginToken成功回调：%@", resultDic);
            NSString *token = [resultDic objectForKey:@"token"];
            //UIPasteboard *generalPasteboard = [UIPasteboard generalPasteboard];
            //if ([token isKindOfClass:NSString.class]) {
            //    generalPasteboard.string = token;
            //}
            DLOG(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
            [weakSelf reqeustMemberLoginAliYunWithToken:token];
        } else {
            DLOG(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [HelpTools showHUDOnlyWithText:@"获取手机号失败，请换其他方式登录或稍后再试！" toView:weakSelf.view];
            [HelpTools hideLoadingForView:weakSelf.view];
            //失败后可以跳转到短信登录界面
            //[weakSelf changeToLoginType:AGLoginStateNumber];
        }
    }];
}

- (void)reqeustMemberLoginAliYunWithToken:(NSString *)token {
    
    if(![NSString isNotEmptyAndValid:token]) {
        
        [HelpTools showHUDOnlyWithText:@"一键登录失败,请重试或其他方式登录" toView:self.view];
        //[self changeToLoginType:AGLoginStateNumber];
        return;
    }
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mMLATHttp.loginToken = token;
    [self.mMLATHttp requestMemberLoginAliYunResultHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            [__strongObject requestMemberLoginPhoneNumWithPhoneNum:__strongObject.mMLATHttp.mBase.data];
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
            //[__strongObject changeToLoginType:AGLoginStateNumber];
        }
    }];
}

- (void)requestMemberLoginPhoneNumWithPhoneNum:(NSString *)phoneNum {
    
    if(![NSString isNotEmptyAndValid:phoneNum]) {
        
        [HelpTools showHUDOnlyWithText:@"一键登录失败,请重试或其他方式登录" toView:self.view];
        //[self changeToLoginType:AGLoginStateNumber];
        return;
    }
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mMLPNHttp.phoneNum = phoneNum;
    [self.mMLPNHttp requestMemberLoginPhoneNumHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if(__strongObject.loginSuccessHandle) {
                
                __strongObject.loginSuccessHandle();
            }
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
            //[__strongObject changeToLoginType:AGLoginStateNumber];
        }
    }];
}

- (void)requestMemberLoginAppleWithToken:(NSString *)appleTokens {
    
    if(![NSString isNotEmptyAndValid:appleTokens]) {
        
        [HelpTools showHUDOnlyWithText:@"Apple 授权失败" toView:self.view];
        //[self changeToLoginType:AGLoginStateNumber];
        return;
    }
    
    __WeakObject(self);
    [HelpTools showLoadingForView:self.view];
    
    self.mMLAHttp.identityToken = appleTokens;
    [self.mMLAHttp requestMemberLoginAppleHandle:^(BOOL isSuccess, id  _Nonnull responseObject) {
        __WeakStrongObject();
        [HelpTools hideLoadingForView:__strongObject.view];
        
        if(isSuccess){
            
            if(__strongObject.loginSuccessHandle) {
                
                __strongObject.loginSuccessHandle();
            }
        }
        else {
            [HelpTools showHttpError:responseObject complete:nil];
            //[__strongObject changeToLoginType:AGLoginStateNumber];
        }
    }];
}

- (AGMemberLoginAliYunHttp *)mMLATHttp {
    
    if(!_mMLATHttp) {
        
        _mMLATHttp = [AGMemberLoginAliYunHttp new];
    }
    
    return _mMLATHttp;
}

- (AGMemberLoginPhoneNumHttp *)mMLPNHttp {
    
    if(!_mMLPNHttp) {
        
        _mMLPNHttp = [AGMemberLoginPhoneNumHttp new];
    }
    
    return _mMLPNHttp;
}

- (AGMemberLoginAppleHttp *)mMLAHttp {
    
    if(!_mMLAHttp) {
        
        _mMLAHttp = [AGMemberLoginAppleHttp new];
    }
    
    return _mMLAHttp;
}

@end
