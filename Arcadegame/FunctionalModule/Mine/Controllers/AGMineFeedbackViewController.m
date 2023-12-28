//
//  AGMineFeedbackViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/9/22.
//

#import "AGMineFeedbackViewController.h"
#import "QBPlaceholderTextView.h"

static const NSInteger kFBLimitedLenght = 200;

@interface AGMineFeedbackViewController () <UITextViewDelegate>

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIButton *mRightButton;
@property (nonatomic, strong) QBPlaceholderTextView *textView;

@end

@implementation AGMineFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"意见反馈";
    
    self.mRightButton.left = self.mAGNavigateView.width - self.mRightButton.width - 12.f;
    self.mRightButton.centerY = self.mAGNavigateView.fixedTop + self.mAGNavigateView.fixedHeight / 2.f;
    [self.mAGNavigateView addSubview:self.mRightButton];
    
    [self.view addSubview:self.mContainerView];
    [self.mContainerView addSubview:self.textView];
    
    [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mContainerView];
    self.textView.frame = self.mContainerView.bounds;
    
    self.textView.originPoint = CGPointMake(15.f, 14.f);
    self.textView.placeholder = @"请在这里输入您的建议";
}

#pragma mark - Selector
- (void)rightButtonAction:(UIButton *)button {
    
    [HelpTools showLoadingForView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [HelpTools hideLoadingForView:self.view.window];
        [HelpTools showHUDOnlyWithText:@"感谢您的反馈" toView:self.view.window];
        [self backToParentView];
    });
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if(kFBLimitedLenght > 0){
        
        if(textView.text.length > kFBLimitedLenght){
            
            textView.text = [textView.text substringToIndex:kFBLimitedLenght];
        }
    }
}

#pragma mark - Getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [[UIView alloc] initWithFrame:CGRectMake(12.f, CGRectGetHeight(self.mAGNavigateView.frame) + 20.f, self.view.width - 12.f * 2, 160.f)];
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (QBPlaceholderTextView *)textView{
    
    if(!_textView){
        
        _textView = [QBPlaceholderTextView new];
        _textView.textColor = [UIColor whiteColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholderColor = UIColorFromRGB(0xB5B7C1);
        _textView.textContainerInset = UIEdgeInsetsMake(14.f, 12.f, 14.f, 12.f);
        _textView.font = [UIFont font14];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    
    return _textView;
}

- (UIButton *)mRightButton {
    
    if(!_mRightButton) {
        
        CGFloat buttonHeight = kNaviBarHeight - 10.f;
        
        _mRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mRightButton.frame = CGRectMake(0.f, 0.f, 80.f, buttonHeight);
        [_mRightButton setTitle:@"提交" forState:UIControlStateNormal];
        _mRightButton.backgroundColor = [UIColor clearColor];
        [_mRightButton.titleLabel setFont:[UIFont font15]];
        
        [_mRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mRightButton setTitleColor:[UIColor whiteColorffffffAlpha01] forState:UIControlStateHighlighted];
        
        _mRightButton.layer.cornerRadius = 10.f;
        
        [_mRightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mRightButton;
}

@end
