//
//  ABWebsiteViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/7/5.
//

#import "ABWebsiteViewController.h"
#import <WebKit/WebKit.h>

@interface ABWebsiteViewController () <WKNavigationDelegate, WKUIDelegate>

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) WKWebView *mWebView;

@end

@implementation ABWebsiteViewController

- (instancetype)initWithUrl:(NSString *)urlString {

    if(self = [super init]) {

        self.url = urlString;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = [NSString isNotEmptyAndValid:self.naviTitleString] ? self.naviTitleString : @"幻影乐游圈";
    
    [self.view addSubview:self.mWebView];
    if (self.url) {
        [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma mark - 

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - Getter
- (WKWebView *)mWebView {
    
    if(!_mWebView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = 0;
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        _mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mAGNavigateView.frame), self.view.width, self.view.height - CGRectGetHeight(self.mAGNavigateView.frame)) configuration:config];
        
        _mWebView.allowsBackForwardNavigationGestures = YES;
        _mWebView.navigationDelegate = self;
        _mWebView.UIDelegate = self;
    }
    
    return _mWebView;
}

@end
