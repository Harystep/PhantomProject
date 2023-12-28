//
//  AGCirclePublishCircleChekMarkTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishCircleChekMarkTableViewCell.h"
#import "QBPlaceholderTextView.h"

static const NSInteger kLimitedLenght = 6;

@interface AGCirclePublishCircleChekMarkTableViewCell ()<UITextViewDelegate>

@property (strong, nonatomic) UIView *mMarkView;
@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIImageView *mMarkIconImageView;
@property (nonatomic, strong) QBPlaceholderTextView *textView;

@end

@implementation AGCirclePublishCircleChekMarkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mMarkView];
        
        [self.mMarkView addSubview:self.mMarkIconImageView];
        [self.mMarkView addSubview:self.textView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height);
    
    self.mMarkView.frame = CGRectMake(14.f, 20.f, 150.f, self.height - 20.f * 2);
    
    self.mMarkIconImageView.left = 14.f;
    self.mMarkIconImageView.centerY = self.mMarkView.height / 2.f;
    
    self.textView.frame = CGRectMake(self.mMarkIconImageView.right + 5.f, 0.f, self.mMarkView.width - (self.mMarkIconImageView.right + 5.f), self.mMarkView.height);
    
    CGFloat topInset = (self.textView.height - self.textView.font.lineHeight) / 2.f;
    self.textView.originPoint = CGPointMake(5.f, topInset);
    self.textView.textContainerInset = UIEdgeInsetsMake(topInset, 0.f, 0.f, 0.f);
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

- (UIView *)mMarkView {
    
    if(!_mMarkView) {
        
        _mMarkView = [UIView new];
        _mMarkView.layer.cornerRadius = 10.f;
        _mMarkView.backgroundColor = UIColorFromRGB(0x5E657B);
    }
    
    return _mMarkView;
}

- (UIImageView *)mMarkIconImageView {
    
    if(!_mMarkIconImageView) {
        
        _mMarkIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"circle_publish_mark_icon")];
    }
    
    return _mMarkIconImageView;
}

- (QBPlaceholderTextView *)textView{
    
    if(!_textView){
        
        _textView = [QBPlaceholderTextView new];
        _textView.textColor = [UIColor whiteColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.placeholderColor = UIColorFromRGB(0xB5B7C1);
        _textView.font = [UIFont font14];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    
    return _textView;
}

@end
