//
//  AGHomePostDetailBottomView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGHomePostDetailBottomView.h"
#import "QBPlaceholderTextView.h"

static const NSInteger kLimitedLenght = 100;

@interface AGHomePostDetailBottomView () <UITextViewDelegate>

@property (strong, nonatomic) UIView *mContainerView;
@property (nonatomic, strong) QBPlaceholderTextView *textView;
@property (nonatomic, strong) UIButton *mConfirmButton;

@end

@implementation AGHomePostDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0x151A28);
        
        [self addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.textView];
        [self.mContainerView addSubview:self.mConfirmButton];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.mContainerView.frame = self.bounds;
    if(!self.mContainerView.layer.mask) {
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mContainerView];
    }
    
    self.mConfirmButton.left = self.mContainerView.width - self.mConfirmButton.width;
    
    self.textView.frame = CGRectMake(0.f, 0.f, self.mConfirmButton.left, self.mContainerView.height);
    
    self.textView.originPoint = CGPointMake(15.f, 14.f);
    self.textView.placeholder = @"说点什么吧...";
}

- (NSString *)inputContent {
    
    return self.textView.text;
}

- (void)cleanContent {
    
    self.textView.text = @"";
}

#pragma mark - Selector
- (void)comfirmButtonAction:(UIButton *)button {
    
    if(self.didConfirmHandle) {
        
        self.didConfirmHandle();
    }
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
    
    if(kLimitedLenght > 0){
        
        if(textView.text.length > kLimitedLenght){
            
            textView.text = [textView.text substringToIndex:kLimitedLenght];
        }
    }
}

#pragma mark - Getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
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
        _textView.font = [UIFont font15];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    
    return _textView;
}

- (UIButton *)mConfirmButton {
    
    if(!_mConfirmButton) {
        
        _mConfirmButton = [UIButton new];
        _mConfirmButton.size = CGSizeMake(99.f, self.height);
        
        [_mConfirmButton setBackgroundImage:[HelpTools createGradientImageWithSize:_mConfirmButton.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:0] forState:UIControlStateNormal];
        [_mConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mConfirmButton setTitle:@"发布" forState:UIControlStateNormal];
        _mConfirmButton.titleLabel.font = [UIFont font15];
        
        [_mConfirmButton addTarget:self action:@selector(comfirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mConfirmButton;
}

@end
