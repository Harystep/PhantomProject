//
//  AGAlertSheetPopView.m
//  Arcadegame
//
//  Created by Abner on 2023/7/10.
//

#import "AGAlertSheetPopView.h"

@interface AGAlertSheetPopView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *maskBackView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation AGAlertSheetPopView

- (instancetype)init{
    
    if(self = [super init]){
        
        self.frame = CGRectMake(0, 0, [HelpTools getKeyWindow].width, 330.f);
        self.backgroundColor = UIColorFromRGB(0x262D42);
        
        if([HelpTools iPhoneNotchScreen]) {
            
            CGRect rect = self.frame;
            rect.size.height +=  kSafeAreaHeight;
            
            self.frame = rect;
        }
        
        [HelpTools addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10.f, 10.f) forView:self];
        
        self.closeButton.frame = ({
            CGRect rect = self.closeButton.frame;
            rect.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(self.closeButton.frame);
            rect;
        });
        [self addSubview:self.closeButton];
        
        [self addSubview:self.tableView];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if(!newSuperview)
        return;
    
    __block CGRect popRect = self.frame;
    popRect.origin.y = CGRectGetHeight([HelpTools getKeyWindow].bounds);
    
    self.frame = popRect;
    self.maskBackView.alpha = 0.f;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        popRect.origin.y = CGRectGetHeight([HelpTools getKeyWindow].bounds) - CGRectGetHeight(popRect);
        
        self.frame = popRect;
        self.maskBackView.alpha = 0.3f;
        
    }];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    
    CGRect popRect = self.frame;
    popRect.origin.y = CGRectGetHeight([HelpTools getKeyWindow].bounds);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.frame = popRect;
        self.maskBackView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.maskBackView removeFromSuperview];
        [super removeFromSuperview];
    }];
}

- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:self.maskBackView];
    [window addSubview:self];
}

- (void)hide{
    
    [self removeFromSuperview];
    
    if(self.dismissBlock){
        
        self.dismissBlock();
    }
}

#pragma mark - Selector

- (void)tapGestureRecognizerAction:(id)sender{
    
     [self hide];
}

- (void)closeButtonAction:(UIButton *)button{
    
    [self hide];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableCell.backgroundColor = [UIColor clearColor];
    
    tableCell.textLabel.textAlignment = NSTextAlignmentCenter;
    tableCell.textLabel.textColor = [UIColor whiteColor];
    tableCell.textLabel.font = [UIFont font14];
    
    tableCell.textLabel.text = self.dataSourceArray[indexPath.row];
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getter

- (UIView *)maskBackView{
    
    if(!_maskBackView){
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        
        _maskBackView = [[UIView alloc] initWithFrame:window.bounds];
        _maskBackView.backgroundColor = [UIColor blackColor];
        _maskBackView.alpha = 0.3f;
        
        _maskBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
        [_maskBackView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _maskBackView;
}

- (UIButton *)closeButton{
    
    if(!_closeButton){
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:IMAGE_NAMED(@"universal_icon_close") forState:UIControlStateNormal];
        //[_closeButton setImage:IMAGE_NAMED(@"btn_close_pressed") forState:UIControlStateHighlighted];
        
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.size = CGSizeMake(42.f, 42.f);
    }
    
    return _closeButton;
}

- (UILabel *)titleLabel{
    
    if(!_titleLabel){
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont font16];
        _titleLabel.textColor = [UIColor blackColor333333];
    }
    
    return _titleLabel;
}

- (UITableView *)tableView{
    
    if(!_tableView){
        
        _tableView = [[UITableView alloc] initWithFrame:({
            CGRect rect = self.bounds;
            rect.origin.y = self.closeButton.bottom + 15.f;
            if([HelpTools iPhoneNotchScreen]){
                
                rect.size.height -= kSafeAreaHeight;
            }
            
            rect;
        })];
        //_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (NSArray *)dataSourceArray {
    
    if(!_dataSourceArray) {
        
        _dataSourceArray = @[@"关注", @"拉黑", @"举报"];
    }
    
    return _dataSourceArray;
}

@end
