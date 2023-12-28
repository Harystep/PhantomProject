//
//  ESCancelResonPopViewTableViewCell.m
//  EShopClient
//
//  Created by Abner on 2019/7/10.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESCancelResonPopViewTableViewCell.h"

@interface ESCancelResonPopViewTableViewCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation ESCancelResonPopViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.textLabel.font = [UIFont font16];
        self.textLabel.textColor = [UIColor blackColor333333];
        
        [self addSubview:self.selectedButton];
        [self addSubview:self.lineView];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.selectedButton.origin = CGPointMake(self.width - self.selectedButton.width - 15.f, 0.f);
    self.selectedButton.centerY = self.height / 2.f;
    self.selectedButton.selected = self.isSelected;
    
    if(self.isSelected){
        self.textLabel.textColor = [UIColor eshopColor];
    }
    else {
        self.textLabel.textColor = [UIColor blackColor333333];
    }
    
    self.lineView.hidden = !self.shouldShowLine;
    self.lineView.frame = CGRectMake(0.f, self.height - 1.f, self.width, 1.f);
}

#pragma mark - Getter

- (UIView *)lineView{
    
    if(!_lineView){
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor cellLineColor];
    }
    
    return _lineView;
}

- (UIButton *)selectedButton{
    
    if(!_selectedButton){
        
        _selectedButton = [UIButton new];
        _selectedButton.size = CGSizeMake(14.f, 14.f);
        [_selectedButton setBackgroundImage:IMAGE_NAMED(@"shoppingCart_unselected_icon") forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:IMAGE_NAMED(@"shoppingCart_check_selected_icon") forState:UIControlStateSelected];
    }
    
    return _selectedButton;
}

@end
