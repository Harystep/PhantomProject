//
//  ESCancelResonPopView.m
//  EShopClient
//
//  Created by Abner on 2019/7/10.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ESCancelResonPopView.h"
#import "ESCancelResonPopViewTableViewCell.h"

@interface ESCancelResonPopView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSArray *dataSourceArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ESCancelResonPopView

- (instancetype)initWithResonArray:(NSArray *)resonArray withTitle:(NSString *)title withInfo:(NSString *)info withSelectedText:(NSString *)text{
    
    if(self = [super init]){
        self.dataSourceArray = [resonArray copy];
        self.currentIndex = -1;
        
        if([NSString isNotEmptyAndValid:text]){
            
            [resonArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if([text isEqualToString:obj]){
                    
                    self.currentIndex = idx;
                    *stop = YES;
                }
            }];
        }
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.infoLabel];
        [self addSubview:self.confirmButton];
        [self addSubview:self.tableView];
        
        self.titleLabel.text = [NSString stringSafeChecking:title];
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.width / 2.f, self.closeButton.centerY);
        
        self.infoLabel.text = [NSString stringSafeChecking:info];
        [self.infoLabel sizeToFit];
        self.infoLabel.origin = CGPointMake(15.f, self.titleLabel.bottom + 30.f);
        
        self.tableView.frame = CGRectMake(0.f, self.infoLabel.bottom + 10.f, self.width, self.confirmButton.top - self.infoLabel.bottom - 15.f - 10.f);
        [self.tableView registerClass:[ESCancelResonPopViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ESCancelResonPopViewTableViewCell class])];
    }
    
    return self;
}

#pragma mark - Selector

- (void)confirmButtonAction:(UIButton *)button{
    
    if(self.currentIndex < 0){
        
        [HelpTools showHUDOnlyWithText:@"请选择原因" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if(self.confirmDidSelectedHandle){
        self.confirmDidSelectedHandle([self.dataSourceArray objectAtIndexForSafe:self.currentIndex], self.currentIndex);
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ESCancelResonPopViewTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ESCancelResonPopViewTableViewCell class]) forIndexPath:indexPath];
    tableCell.textLabel.text = [NSString stringSafeChecking:self.dataSourceArray[indexPath.row]];
    tableCell.shouldShowLine = (indexPath.row != self.dataSourceArray.count - 1);
    tableCell.isSelected = (self.currentIndex == indexPath.row);
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentIndex = indexPath.row;
    [tableView reloadData];
}

#pragma mark - Getter

- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font16];
        _titleLabel.textColor = [UIColor blackColor333333];
    }
    
    return _titleLabel;
}

- (UILabel *)infoLabel{
    
    if(!_infoLabel){
        
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont font18];
        _infoLabel.textColor = [UIColor grayColor999999];
    }
    
    return _infoLabel;
}

- (UIButton *)confirmButton{
    
    if(!_confirmButton){
        
        _confirmButton = [[UIButton alloc] initWithFrame:({
            CGRect rect = CGRectMake(28.f, self.height - 44.f, self.width - 28.f * 2, 44.f);
            if([HelpTools iPhoneNotchScreen]){
                
                rect.origin.y -= kSafeAreaHeight + 15.f;
            }
            else {
                rect.origin.y -= 30.f;
            }
            
            rect;
        })];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_confirmButton setBackgroundImage:[HelpTools createImageWithColor:[UIColor eshopColor]] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[HelpTools createImageWithColor:[[UIColor eshopColor] colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
        _confirmButton.layer.cornerRadius = 5.f;
        _confirmButton.clipsToBounds = YES;
        
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (UITableView *)tableView{
    
    if(!_tableView){
        
        _tableView = [UITableView new];
        //_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        //_tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
