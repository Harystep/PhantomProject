//
//  AGCirclePublishCircleConfirmTableViewCell.m
//  Arcadegame
//
//  Created by Abner on 2023/6/25.
//

#import "AGCirclePublishCircleConfirmTableViewCell.h"

@interface AGCirclePublishCircleConfirmTableViewCell ()

@property (strong, nonatomic) UIView *mContainerView;
@property (strong, nonatomic) UIButton *mConfirmButton;

@end

@implementation AGCirclePublishCircleConfirmTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.mContainerView];
        [self.mContainerView addSubview:self.mConfirmButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mContainerView.frame = CGRectMake(12.f, 0.f, self.width - 12.f * 2, self.height);
    if(!self.mContainerView.layer.mask) {
        [HelpTools addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10.f, 10.f) forView:self.mContainerView];
    }
    
    self.mConfirmButton.frame = CGRectMake(14.f, self.height - 46.f - 10.f, self.mContainerView.width - 14.f * 2, 46.f);
    if(!self.mConfirmButton.backgroundColor) {
        
        self.mConfirmButton.backgroundColor = [UIColor colorWithPatternImage:[HelpTools createGradientImageWithSize:self.mConfirmButton.size colors:@[UIColorFromRGB(0x41E1E0), UIColorFromRGB(0x31E79D)] gradientType:1]];
    }
}

#pragma mark -
- (void)confirmButtonAction:(UIButton *)button {
    
    if(self.didSelectedHandle) {
        
        self.didSelectedHandle();
    }
}

#pragma mark - getter
- (UIView *)mContainerView {
    
    if(!_mContainerView) {
        
        _mContainerView = [UIView new];
        _mContainerView.backgroundColor = UIColorFromRGB(0x262E42);
    }
    
    return _mContainerView;
}

- (UIButton *)mConfirmButton {
    
    if(!_mConfirmButton) {
        
        _mConfirmButton = [UIButton new];
        [_mConfirmButton.titleLabel setFont:[UIFont font16]];
        [_mConfirmButton setTitle:@"发布" forState:UIControlStateNormal];
        [_mConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mConfirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
        _mConfirmButton.layer.cornerRadius = 10.f;
        _mConfirmButton.backgroundColor = nil;
        _mConfirmButton.clipsToBounds = YES;
        
        [_mConfirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mConfirmButton;
}

@end
