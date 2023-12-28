//
//  AGRechargeView.m
//  Arcadegame
//
//  Created by Abner on 2023/7/18.
//

#import "AGRechargeView.h"

const static NSInteger kChargeValueButtonBaseTag = 1000;

@interface AGRechargeView ()

@property (strong, nonatomic) UIView *mChargeValueButtonContainerView;
@property (strong, nonatomic) AGRechargePayMethodView *mPayMethodView;
@property (strong, nonatomic) AGRechargeInputView *mTotalView;
@property (strong, nonatomic) AGRechargeInputView *mInputView;
@property (strong, nonatomic) UILabel *mTitleLabel;
@property (strong, nonatomic) UIButton *mPayButton;

@property (assign, nonatomic) AGRechargePayType mPayType;
@property (strong, nonatomic) NSArray *mChargeValueArray;
@property (strong, nonatomic) AGRechargeValueItem *mUserValue;
@property (assign, nonatomic) NSInteger mCurrentChargeValueSelectedIndex;

@end

@implementation AGRechargeView

- (instancetype)initWithUserName:(NSString *)userName withValue:(AGRechargeValueItem *)valueItem{
    
    if(self = [super init]) {
        self.backgroundColor = UIColorFromRGB(0x262E42);
        
        self.mCurrentChargeValueSelectedIndex = 0;
        self.mPayType = kAGRechargePayType_Pay;
        self.mUserValue = valueItem;
        
        [self addSubview:self.mTitleLabel];
        [self addSubview:self.mChargeValueButtonContainerView];
        
        [self addSubview:self.mInputView];
        [self addSubview:self.mTotalView];
        [self addSubview:self.mPayMethodView];
        [self addSubview:self.mPayButton];
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]  initWithString:[NSString stringWithFormat:@"给 %@ 赞赏", [NSString stringSafeChecking:userName]]];
        [titleString setAttributes:@{NSFontAttributeName: [UIFont font18Bold]} range:NSMakeRange(2, [NSString stringSafeChecking:userName].length)];
        self.mTitleLabel.attributedText = titleString;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mTitleLabel.top = 20.f;
    self.mTitleLabel.width = self.width;
    
    self.mChargeValueButtonContainerView.top = self.mTitleLabel.bottom + 25.f;
    self.mChargeValueButtonContainerView.width = self.width;
    
    NSInteger column = 3;
    CGFloat valueBtnWidth = 80.f;
    CGFloat leftOrigain = (self.width - valueBtnWidth * column - 10.f * (column - 1)) / 2.f;
    CGFloat origainX = leftOrigain;
    CGFloat origainY = 0.f;
    
    for (int i = 0; i < self.mChargeValueArray.count; ++i) {
        
        UIButton *chargeValueButton = [self viewWithTag:(kChargeValueButtonBaseTag + i)];
        if(!chargeValueButton) {
            
            chargeValueButton = [UIButton new];
            chargeValueButton.tag = kChargeValueButtonBaseTag + i;
            chargeValueButton.size = CGSizeMake(valueBtnWidth, 35.f);
            chargeValueButton.titleLabel.font = [UIFont font15];
            [chargeValueButton setTitleColor:UIColorFromRGB(0xEE607C) forState:UIControlStateNormal];
            [chargeValueButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateSelected];
            [chargeValueButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
            
            /*
            [chargeValueButton setImage:IMAGE_NAMED(@"chargevalue_btn_icon_gold") forState:UIControlStateNormal];
            [chargeValueButton setImage:IMAGE_NAMED(@"chargevalue_btn_icon_gold_0") forState:UIControlStateSelected];
             */
            [chargeValueButton setImage:IMAGE_NAMED(@"chargevalue_btn_icon") forState:UIControlStateNormal];
            [chargeValueButton setImage:IMAGE_NAMED(@"chargevalue_btn_icon_0") forState:UIControlStateSelected];
            [chargeValueButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, 0.f, 8.f)];
            
            [chargeValueButton setBackgroundImage:[HelpTools createImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            [chargeValueButton setBackgroundImage:[HelpTools createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [chargeValueButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0xEE607C)] forState:UIControlStateSelected];
            
            chargeValueButton.clipsToBounds = YES;
            chargeValueButton.layer.cornerRadius = 10.f;
            chargeValueButton.layer.borderColor = [UIColorFromRGB(0xEE607C) CGColor];
            chargeValueButton.layer.borderWidth = 1.f;
            
            [self.mChargeValueButtonContainerView addSubview:chargeValueButton];
            [chargeValueButton addTarget:self action:@selector(chargeValueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [chargeValueButton setTitle:self.mChargeValueArray[i] forState:UIControlStateNormal];
        
        if(self.mCurrentChargeValueSelectedIndex == i) {
            
            chargeValueButton.selected = YES;
        }
        
        chargeValueButton.origin = CGPointMake(origainX, origainY);
        origainX = (i % column == 2) ? leftOrigain : (chargeValueButton.right + 10.f);
        origainY = (i % column == 2) ? (chargeValueButton.bottom + 10.f) : origainY;
        
        if(i == (self.mChargeValueArray.count - 1)) {
            
            self.mChargeValueButtonContainerView.height = chargeValueButton.bottom;
        }
    }
    
    self.mInputView.frame = (CGRect){CGPointMake(12.f, self.mChargeValueButtonContainerView.bottom + 20.f), CGSizeMake(self.width - 12.f * 2, 40.f)};
    self.mInputView.titleString = @"自定义金额";
    self.mInputView.placeholderString = @"可填写1-500";
    
    self.mTotalView.frame = (CGRect){CGPointMake(self.mInputView.left, self.mInputView.bottom + 12.f), CGSizeMake(self.width - self.mInputView.left * 2, 40.f)};
    self.mTotalView.titleString = @"支付总额";
    
    self.mPayMethodView.frame = (CGRect){CGPointMake(self.mTotalView.left, self.mTotalView.bottom + 12.f), CGSizeMake(self.width - self.mTotalView.left * 2, 60.f)};
    
    self.mPayButton.frame = (CGRect){CGPointMake(12.f, self.height - 46.f - ([HelpTools iPhoneNotchScreen] ? kSafeAreaHeight : 0) - 20.f), CGSizeMake(self.width - 12.f * 2, 46.f)};
    
    [self resetPayValueFormInput];
}

- (void)resetPayValueFormInput {
    
    //NSString *remainingValue = self.mUserValue.goldCoin;
    NSString *remainingValue = self.mUserValue.diamond;
    
    self.mPayMethodView.remainingValue = remainingValue;
    
    NSString *totalValue = [self.mChargeValueArray objectAtIndexForSafe:self.mCurrentChargeValueSelectedIndex];
    if([NSString isNotEmptyAndValid:self.mInputView.value]) {
        
        totalValue = self.mInputView.value;
    }
    self.mTotalView.initialValue = totalValue;
    
    if(totalValue.integerValue > remainingValue.integerValue) {
        
        self.mPayType = kAGRechargePayType_Charge;
        //[self.mPayButton setTitle:@"金币不足，立即充值" forState:UIControlStateNormal];
        [self.mPayButton setTitle:@"钻石不足，立即充值" forState:UIControlStateNormal];
    }
    else {
        
        self.mPayType = kAGRechargePayType_Pay;
        [self.mPayButton setTitle:@"赞赏" forState:UIControlStateNormal];
    }
}

- (void)resetPayValueFormSelected {
    
    //NSString *remainingValue = self.mUserValue.goldCoin;
    NSString *remainingValue = self.mUserValue.diamond;
    
    self.mPayMethodView.remainingValue = remainingValue;
    
    NSString *totalValue = [self.mChargeValueArray objectAtIndexForSafe:self.mCurrentChargeValueSelectedIndex];
    self.mTotalView.initialValue = totalValue;
    
    [self.mInputView clear];
    
    if(totalValue.integerValue > remainingValue.integerValue) {
        
        self.mPayType = kAGRechargePayType_Charge;
        //[self.mPayButton setTitle:@"金币不足，立即充值" forState:UIControlStateNormal];
        [self.mPayButton setTitle:@"钻石不足，立即充值" forState:UIControlStateNormal];
    }
    else {
        self.mPayType = kAGRechargePayType_Pay;
        [self.mPayButton setTitle:@"赞赏" forState:UIControlStateNormal];
    }
}

#pragma mark - Selector
- (void)chargeValueButtonAction:(UIButton *)button {
    
    for (UIView *subView in self.mChargeValueButtonContainerView.subviews) {
        if([subView isKindOfClass:[UIButton class]]) {
            
            ((UIButton *)subView).selected = NO;
        }
    }
    button.selected = YES;
    self.mCurrentChargeValueSelectedIndex = button.tag - kChargeValueButtonBaseTag;
    
    [self resetPayValueFormSelected];
}

- (void)mPayButtonAction:(UIButton *)button {
    
    if(self.didPaySelectedHandle) {
        
        self.didPaySelectedHandle(self.mPayType, self.mTotalView.value);
    }
}

#pragma mark - Getter
- (NSArray *)mChargeValueArray {
    
    if(!_mChargeValueArray) {
        
        _mChargeValueArray = @[@"1", @"2", @"5", @"10", @"20", @"50"];
    }
    
    return _mChargeValueArray;
}

- (UILabel *)mTitleLabel {
    
    if(!_mTitleLabel) {
        
        _mTitleLabel = [UILabel new];
        _mTitleLabel.font = [UIFont font16];
        _mTitleLabel.textColor = [UIColor whiteColor];
        _mTitleLabel.textAlignment = NSTextAlignmentCenter;
        _mTitleLabel.height = _mTitleLabel.font.lineHeight;
    }
    
    return _mTitleLabel;
}

- (UIView *)mChargeValueButtonContainerView {
    
    if(!_mChargeValueButtonContainerView) {
        
        _mChargeValueButtonContainerView = [UIView new];
        _mChargeValueButtonContainerView.backgroundColor = [UIColor clearColor];
    }
    
    return _mChargeValueButtonContainerView;
}

- (AGRechargeInputView *)mTotalView {
    
    if(!_mTotalView) {
        
        _mTotalView = [AGRechargeInputView new];
        _mTotalView.shouldEnable = NO;
    }
    
    return _mTotalView;
}

- (AGRechargeInputView *)mInputView {
    
    if(!_mInputView) {
        
        _mInputView = [AGRechargeInputView new];
        
        __WeakObject(self);
        _mInputView.textFieldDidEndHandle = ^{
            __WeakStrongObject();
            
            [__strongObject resetPayValueFormInput];
        };
    }
    
    return _mInputView;
}

- (AGRechargePayMethodView *)mPayMethodView {
    
    if(!_mPayMethodView) {
        
        _mPayMethodView = [AGRechargePayMethodView new];
    }
    
    return _mPayMethodView;
}

- (UIButton *)mPayButton {
    
    if(!_mPayButton) {
        
        _mPayButton = [UIButton new];
        _mPayButton.titleLabel.font = [UIFont font15Bold];
        [_mPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mPayButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        
        [_mPayButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0xEE607C)] forState:UIControlStateHighlighted];
        [_mPayButton setBackgroundImage:[HelpTools createImageWithColor:UIColorFromRGB(0xEE607C)] forState:UIControlStateNormal];
        
        _mPayButton.clipsToBounds = YES;
        _mPayButton.layer.cornerRadius = 10.f;
        
        [_mPayButton addTarget:self action:@selector(mPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mPayButton;
}

@end

/**
 * AGRechargeInputView
 */
@interface AGRechargeInputView () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIImageView *iconIamgeView;

@property (strong, nonatomic, readwrite) NSString *value;

@end

@implementation AGRechargeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.iconIamgeView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringSafeChecking:self.placeholderString] attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.5f]}];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@:", [NSString stringSafeChecking:self.titleString]];
    [self.titleLabel sizeToFit];
    self.titleLabel.left = 12.f;
    
    self.iconIamgeView.left = self.width - self.iconIamgeView.width - 12.f;
    
    self.textField.left = self.titleLabel.right + 12.f;
    self.textField.width = self.iconIamgeView.left - self.textField.left - 5.f;
    self.textField.height = self.height;
    
    self.titleLabel.centerY = self.textField.centerY = self.iconIamgeView.centerY = self.height / 2.f;
}

- (void)setInitialValue:(NSString *)initialValue {
    _initialValue = initialValue;
    
    self.textField.text = initialValue;
}

- (void)setShouldEnable:(BOOL)shouldEnable {
    _shouldEnable = shouldEnable;
    
    self.textField.enabled = shouldEnable;
}

- (NSString *)value {
    
    return self.textField.text;
}

- (void)clear {
    
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(self.textFieldDidEndHandle) {
        
        self.textFieldDidEndHandle();
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font14Bold];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.height = _titleLabel.font.lineHeight;
    }
    
    return _titleLabel;
}

- (UITextField *)textField {
    
    if(!_textField) {
        
        _textField = [UITextField new];
        _textField.font = [UIFont font14];
        _textField.textColor = [UIColor whiteColor];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIImageView *)iconIamgeView {
    
    if(!_iconIamgeView) {
        
        //_iconIamgeView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"chargevalue_btn_icon_gold_0")];
        _iconIamgeView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"chargevalue_btn_icon_0")];
    }
    
    return _iconIamgeView;
}

@end


/**
 * AGRechargePayMethodView
 */
@interface AGRechargePayMethodView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *remainingLabel;
@property (strong, nonatomic) UILabel *staticPayMLabel;
@property (strong, nonatomic) UIImageView *staticIconImageView;

@end

@implementation AGRechargePayMethodView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.remainingLabel];
        [self addSubview:self.staticPayMLabel];
        [self addSubview:self.staticIconImageView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.origin = CGPointMake(12.f, 12.f);
    
    self.remainingLabel.text = [NSString stringWithFormat:@"剩余 %@", [NSString stringSafeChecking:self.remainingValue]];
    [self.remainingLabel sizeToFit];
    self.remainingLabel.left = self.width - self.remainingLabel.width - 12.f;
    
    self.staticIconImageView.left = self.remainingLabel.left - self.staticPayMLabel.width - 3.f;
    self.staticPayMLabel.left = self.staticIconImageView.left - self.staticPayMLabel.width - 3.f;
    
    self.remainingLabel.centerY = self.staticIconImageView.centerY = self.staticPayMLabel.centerY = self.titleLabel.centerY;
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    
    if(!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font14Bold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"支付方式:";
        [_titleLabel sizeToFit];
    }
    
    return _titleLabel;
}

- (UILabel *)remainingLabel {
    
    if(!_remainingLabel) {
        
        _remainingLabel = [UILabel new];
        _remainingLabel.font = [UIFont font14];
        _remainingLabel.textColor = [UIColor redColor];
    }
    
    return _remainingLabel;
}

- (UILabel *)staticPayMLabel {
    
    if(!_staticPayMLabel) {
        
        _staticPayMLabel = [UILabel new];
        _staticPayMLabel.font = [UIFont font14];
        _staticPayMLabel.textColor = [UIColor whiteColor];
        //_staticPayMLabel.text = @"金币";
        _staticPayMLabel.text = @"钻石";
        [_staticPayMLabel sizeToFit];
    }
    
    return _staticPayMLabel;
}

- (UIImageView *)staticIconImageView {
    
    if(!_staticIconImageView) {
        
        //_staticIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"chargevalue_btn_icon_gold_0")];
        _staticIconImageView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"chargevalue_btn_icon_0")];
    }
    
    return _staticIconImageView;
}

@end

/**
 * AGRechargeValueItem
 */
@implementation AGRechargeValueItem

@end
