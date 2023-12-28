//
//  AGUserHomeHomeView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/29.
//

#import "AGUserHomeHomeView.h"

@interface AGUserHomeHomeView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mScrollView;

@property (strong, nonatomic) UILabel *mStaticTitleLabel;
@property (strong, nonatomic) UILabel *mUserInfoLabel;
@property (strong, nonatomic) UILabel *mGenderLabel;

@end

@implementation AGUserHomeHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.scrollView = self.mScrollView;
        
        [self addSubview:self.mScrollView];
        
        [self.mScrollView addSubview:self.mStaticTitleLabel];
        [self.mScrollView addSubview:self.mUserInfoLabel];
        [self.mScrollView addSubview:self.mGenderLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.mScrollView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(frame), CGRectGetHeight(frame) - 20.f);
    self.mScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.mScrollView.frame), CGRectGetHeight(self.mScrollView.frame) + 1.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mStaticTitleLabel.origin = CGPointMake(15.f, 55.f);
    
    self.mGenderLabel.left = self.mStaticTitleLabel.left;
    self.mGenderLabel.top = self.mStaticTitleLabel.bottom + 20.f;
    self.mGenderLabel.width = self.scrollView.width - self.mGenderLabel.left * 2;
    self.mGenderLabel.text = [NSString stringWithFormat:@"性别：%@", @"未知"];
    
    NSString *content = [NSString stringWithFormat:@"个人简介：%@", [NSString isNotEmptyAndValid:self.data.remark] ? self.data.remark : @"无"];
    
    self.mUserInfoLabel.left = self.mStaticTitleLabel.left;
    self.mUserInfoLabel.top = self.mGenderLabel.bottom + 20.f;
    self.mUserInfoLabel.width = self.scrollView.width - self.mUserInfoLabel.left * 2;
    self.mUserInfoLabel.height = [HelpTools sizeForString:content withFont:self.mUserInfoLabel.font viewWidth:self.mUserInfoLabel.width].height;
    self.mUserInfoLabel.text = content;
    
    if(self.mUserInfoLabel.bottom + 20.f > self.mScrollView.contentSize.height) {
        
        self.mScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.mScrollView.frame), self.mUserInfoLabel.bottom + 20.f);
    }
}

- (void)setData:(AGCircleMemberOtherMemberData *)data {
    _data = data;
    
    [self setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - Getter
- (UIScrollView *)mScrollView{
    
    if(!_mScrollView){
        
        _mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mScrollView.backgroundColor = [UIColor clearColor];
        _mScrollView.delegate = self;
        
        if([HelpTools iPhoneNotchScreen]){

            _mScrollView.contentInset = UIEdgeInsetsMake(0.f, 0.f, kSafeAreaHeight, 0.f);
        }
    }
    
    return _mScrollView;
}

- (UILabel *)mStaticTitleLabel {
    
    if(!_mStaticTitleLabel) {
        
        _mStaticTitleLabel = [UILabel new];
        _mStaticTitleLabel.font = [UIFont font15Bold];
        _mStaticTitleLabel.textColor = [UIColor whiteColor];
        _mStaticTitleLabel.text = @"基本信息";
        [_mStaticTitleLabel sizeToFit];
    }
    
    return _mStaticTitleLabel;
}

- (UILabel *)mGenderLabel {
    
    if(!_mGenderLabel) {
        
        _mGenderLabel = [UILabel new];
        _mGenderLabel.font = [UIFont font15Bold];
        _mGenderLabel.textColor = [UIColor whiteColor];
        
        _mGenderLabel.height = _mGenderLabel.font.lineHeight;
    }
    
    return _mGenderLabel;
}

- (UILabel *)mUserInfoLabel {
    
    if(!_mUserInfoLabel) {
        
        _mUserInfoLabel = [UILabel new];
        _mUserInfoLabel.font = [UIFont font15Bold];
        _mUserInfoLabel.textColor = [UIColor whiteColor];
        _mUserInfoLabel.numberOfLines = 0;
    }
    
    return _mUserInfoLabel;
}

@end
