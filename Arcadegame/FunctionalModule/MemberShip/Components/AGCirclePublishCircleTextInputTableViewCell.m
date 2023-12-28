//
//  AGCirclePublishCircleTextInputTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishCircleTextInputTableViewCell.h"
#import "QBPlaceholderTextView.h"

static const NSInteger kLimitedLenght = 200;

@interface AGCirclePublishCircleTextInputTableViewCell () <UITextViewDelegate>

@property (strong, nonatomic) UIView *mContainerView;
@property (nonatomic, strong) QBPlaceholderTextView *textView;

@end

@implementation AGCirclePublishCircleTextInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.textView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height);
    if(!self.mContainerView.layer.mask) {
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mContainerView];
    }
    
    self.textView.frame = self.mContainerView.bounds;
    
    self.textView.originPoint = CGPointMake(15.f, 14.f);
    self.textView.placeholder = self.palaceholder;
}

- (NSString *)inputContent {
    
    return self.textView.text;
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
    
    if(self.textDidChangedHandle){
        
        self.textDidChangedHandle(textView.text, self.indexPath);
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
        _textView.font = [UIFont font14];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    
    return _textView;
}

@end
