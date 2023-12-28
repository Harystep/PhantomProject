//
//  ABMultiContainerTableView.m
//  ABMultiScrollDemo
//
//  Created by Abner on 2019/5/30.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "ABMultiContainerTableView.h"
#import "ABMultiContentView.h"
#import <WebKit/WebKit.h>

#define ABMulti_Is_iPhoneXSerious @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0

@interface ABMultiContainerTableView () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, ABMultiContentViewDelegate, ABMultiContentViewDataSource>

@property (nonatomic, strong) ABMultiContentView *mMultiContentView;

@end

@implementation ABMultiContainerTableView

- (void)dealloc{
    
    self.delegate = nil;
}

- (instancetype)init{
    
    if(self = [super init]){
        
        [self initialMultiContainer];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self initialMultiContainer];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        [self initialMultiContainer];
    }
    
    return self;
}

#pragma mark -

- (void)initialMultiContainer{
    
    self.canContainerScroll = YES;
    
    self.delegate = self;
    self.dataSource = self;
    self.panGestureRecognizer.cancelsTouchesInView = NO;
    
    if(@available(iOS 11.0, *)){
        
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.backgroundColor = [UIColor blueColor];
}

- (CGFloat)heightForContainerCanScroll{
    
    if(self.tableHeaderView){
        
        CGFloat fixedOffsetY = 0.f;
        if(self.customDataSource &&
           [self.customDataSource respondsToSelector:@selector(containerTableViewContentFixedOffsetY:)]) {
            
            fixedOffsetY = [self.customDataSource containerTableViewContentFixedOffsetY:self];
        }
        
        return CGRectGetHeight(self.tableHeaderView.frame) - [self contentInsetTop] - fixedOffsetY;
    }
    
    return 0.f;
}

- (CGFloat)contentInsetTop{
    
    if(self.customDataSource &&
       [self.customDataSource respondsToSelector:@selector(containerTableViewContentInsetTop:)]){
        
        return [self.customDataSource containerTableViewContentInsetTop:self];
    }
    
    return 0.f;
}

- (CGFloat)contentInsetBottom{
    
    if(self.customDataSource &&
       [self.customDataSource respondsToSelector:@selector(containerTableViewContentInsetBottom:)]){
        
        return [self.customDataSource containerTableViewContentInsetBottom:self];
    }
    
    return 0.f;
}

- (CGFloat)segmentViewHeight{
    
    return self.segmentView ? CGRectGetHeight(self.segmentView.frame) : 0.f;
}

- (CGFloat)bottomViewHeight{
    
    return (self.bottomView && !self.shouldHideBottomView) ? CGRectGetHeight(self.bottomView.frame) : 0.f;
}

- (CGFloat)contentViewHeight{
    
    CGFloat fixedOffsetY = 0.f;
    if(self.customDataSource &&
       [self.customDataSource respondsToSelector:@selector(containerTableViewContentFixedOffsetY:)]) {
        
        fixedOffsetY = [self.customDataSource containerTableViewContentFixedOffsetY:self];
    }
    
    return CGRectGetHeight(self.bounds) - [self contentInsetTop] - [self contentInsetBottom] - [self segmentViewHeight] - [self bottomViewHeight] - fixedOffsetY;
}

- (void)containerWillScroll{
    
    for (id view in self.contentViewsArray) {
        UIScrollView *scrollView;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            scrollView = view;
        }
        else if ([view isKindOfClass:[WKWebView class]]) {
            
            scrollView = ((WKWebView *)view).scrollView;
        }
        else if([view respondsToSelector:@selector(scrollView)]){
            
            scrollView = [view scrollView];
        }
        
        if (scrollView) {
            
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)contentScrollToIndex:(NSInteger)index{
    
    [self.mMultiContentView scrollToIndex:index];
}

#pragma mark -

- (void)setTableHeaderView:(UIView *)tableHeaderView{
    [super setTableHeaderView:tableHeaderView];
    
    [self reloadData];
}

- (void)setBottomView:(UIView *)bottomView{
    _bottomView = bottomView;
    
    [self reloadData];
}

- (void)setSegmentView:(UIView *)segmentView{
    _segmentView = segmentView;
    
    [self reloadData];
}

- (void)setContentViewsArray:(NSArray *)contentViewsArray{
    _contentViewsArray = contentViewsArray;
    self.contentOffset = CGPointZero;
    
    [self.mMultiContentView reloadData];
}

- (void)setCanContainerScroll:(BOOL)canContainerScroll{
    
    if(_canContainerScroll == canContainerScroll)   return;
    
    _canContainerScroll = canContainerScroll;
    
    [self containerWillScroll];
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(containerViewContainerShouldScroll:)]){
        
        [self.customDelegate containerViewContainerShouldScroll:canContainerScroll];
    }
}

- (void)setShouldHideBottomView:(BOOL)shouldHideBottomView{
    
    if(_shouldHideBottomView == shouldHideBottomView)   return;
    
    _shouldHideBottomView = shouldHideBottomView;
    
    [self reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [self segmentViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [self bottomViewHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self contentViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(self.segmentView){
        
        return self.segmentView;
    }
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(self.bottomView &&
       !self.shouldHideBottomView){

        return self.bottomView;
    }
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if(!tableCell){
        
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableCell.backgroundColor = [UIColor clearColor];
        
        [tableCell.contentView addSubview:self.mMultiContentView];
    }
    
    self.mMultiContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self contentViewHeight]);
    
    return tableCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat criticalPointOffsetY = [self heightForContainerCanScroll];
    
    //DLOG(@"scrollViewDidScroll:%@:%@;%@", NSStringFromClass([self class]), @(criticalPointOffsetY), @(scrollView.contentOffset.y));
    
    if(scrollView.contentOffset.y >= criticalPointOffsetY){

        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        self.canContainerScroll = NO;
        self.canContentScroll = YES;

        if(self.customDelegate &&
           [self.customDelegate respondsToSelector:@selector(containerViewContentShouldScroll:)]){

            [self.customDelegate containerViewContentShouldScroll:self.canContentScroll];
        }
    }
    else {

        if(!self.canContainerScroll){

            scrollView.contentOffset = CGPointMake(0.f, criticalPointOffsetY);
        }
        else {
            
        }
    }

    scrollView.showsVerticalScrollIndicator = self.canContainerScroll;

    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(containerViewDidScroll:)]){

        [self.customDelegate containerViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        
        [self.customDelegate scrollViewWillBeginDragging:scrollView];
    }
    
    //DLOG(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        
        [self.customDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    //DLOG(@"scrollViewDidEndDragging(decelerate:%@)", decelerate ? @"YES" : @"NO");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        
        [self.customDelegate scrollViewDidEndDecelerating:scrollView];
    }
    
    //DLOG(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    //DLOG(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    //DLOG(@"scrollViewWillEndDragging");
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    id otherView = otherGestureRecognizer.view;
    
    if(self.contentViewsArray &&
       ([self.contentViewsArray containsObject:otherView] ||
        [self.contentViewsArray containsObject:[otherView superview]])){
           
           //NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer:%@;%@", NSStringFromClass([otherView class]), NSStringFromClass([[otherView superview] class]));
           return YES;
    }
    
    return NO;
}

#pragma mark - ABMultiContentViewDelegate & ABMultiContentViewDataSource

- (NSInteger)numberOfItemsInContentView:(ABMultiContentView *)contentView{
    
    return self.contentViewsArray.count;
}

- (UIView *)contentView:(ABMultiContentView *)contentView pageIndex:(NSInteger)index{
    
    return self.contentViewsArray[index];
}

- (void)contentView:(ABMultiContentView *)contentView didScrollToIndex:(NSInteger)index{
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(containerViewContentDidScrollToIndex:)]){
        
        [self.customDelegate containerViewContentDidScrollToIndex:index];
    }
}

- (void)contentView:(ABMultiContentView *)contentView willScrollToIndex:(NSInteger)index{
    
    if(self.customDelegate &&
       [self.customDelegate respondsToSelector:@selector(containerViewContentWillScrollToIndex:)]){
        
        [self.customDelegate containerViewContentWillScrollToIndex:index];
    }
}

#pragma - Getter

- (ABMultiContentView *)mMultiContentView{
    
    if(!_mMultiContentView){
        
        _mMultiContentView = [[ABMultiContentView alloc] initWithFrame:self.bounds];
        _mMultiContentView.dataSource = self;
        _mMultiContentView.delegate = self;
    }
    
    return _mMultiContentView;
}

@end


