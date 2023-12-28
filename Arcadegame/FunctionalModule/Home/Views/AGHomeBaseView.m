//
//  AGHomeBaseView.m
//  Arcadegame
//
//  Created by Abner on 2023/6/15.
//

#import "AGHomeBaseView.h"

@interface AGHomeBaseView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AGHomeBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.scrollView = self.mTableView;
        
        [self addSubview:self.mTableView];
        [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.mTableView registerClass:[AGHomePostTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AGHomePostTableViewCell class])];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGRect tableFrame = self.bounds;
//    if([HelpTools iPhoneNotchScreen]) {
//
//        tableFrame.size.height = tableFrame.size.height - 22.f;
//    }
    
    self.mTableView.frame = tableFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.postArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 165.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return ({
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.frame = (CGRect){CGPointZero, CGSizeMake(tableView.width, 35.f)};
        
        UIView *dotView = [UIView new];
        dotView.size = CGSizeMake(5.f, 5.f);
        dotView.backgroundColor = [UIColor whiteColor];
        dotView.layer.cornerRadius = dotView.size.height / 2.f;
        [headerView addSubview:dotView];
        
        UILabel *headLabel = [UILabel new];
        headLabel.font = [UIFont font16];
        headLabel.textColor = [UIColor whiteColor];
        headLabel.text = @"热门帖子";
        [headLabel sizeToFit];
        [headerView addSubview:headLabel];
        
        dotView.left = 25.f;
        headLabel.left = dotView.right + 6.f;
        
        dotView.centerY = headLabel.centerY = headerView.height / 2.f;
        
        headerView;
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AGHomePostTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AGHomePostTableViewCell class])];
    if(!tableCell){
        
        tableCell = [[AGHomePostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([AGHomePostTableViewCell class])];
    }
    tableCell.indexPath = indexPath;
    tableCell.mData = self.postArray[indexPath.row];
    
    if(indexPath.row == 0) {
        
        if(self.postArray.count == 1) {
            
            tableCell.corner = KHomePostTableViewCorner_All;
        }
        else {
            
            tableCell.corner = KHomePostTableViewCorner_top;
        }
    }
    else if(indexPath.row == self.postArray.count - 1) {
        
        tableCell.corner = KHomePostTableViewCorner_Bottom;
    }
    else {
        
        tableCell.corner = KHomePostTableViewCorner_None;
    }
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.didSelectedTableCellHandle) {
        
        self.didSelectedTableCellHandle(indexPath);
    }
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    
    if(scrollView == self.mTableView){

        CGFloat headerHeight = 35.f;
        CGFloat bottomInsets = scrollView.contentInset.bottom;
        
        if(scrollView.contentOffset.y <= headerHeight &&
           scrollView.contentOffset.y >= 0.f){
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.f, bottomInsets, 0.f);
        }
        else if(scrollView.contentOffset.y >= headerHeight){

            scrollView.contentInset = UIEdgeInsetsMake(-headerHeight, 0.f, bottomInsets, 0.f);
        }
    }
}

#pragma mark - Getter
- (UITableView *)mTableView {
    
    if(!_mTableView) {
        
        _mTableView = [[UITableView alloc] initWithFrame:self.bounds];
        //_mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor = [UIColor clearColor];
        //_tableView.scrollEnabled = NO;
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        
        //_mTableView.contentInset = UIEdgeInsetsMake(15.f, 0.f, 15.f, 0.f);
    }
    
    return _mTableView;
}

@end
