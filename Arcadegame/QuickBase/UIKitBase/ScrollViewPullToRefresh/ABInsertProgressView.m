//
//  ABInsterProgressView.m
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import "ABInsertProgressView.h"

static CGFloat kInsertProgressHeight = 40.f;
static CGFloat kActivityIndicatorViewHeight = 30.f;

@interface ABInsertProgressView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *noticeInfoLabel;

@end

@implementation ABInsertProgressView

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"isScrollDecelerating" context:nil];

#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init{
    
    self = [super initWithFrame:CGRectMake(0, self.scrollView.contentSize.height, kInsertProgressHeight, kInsertProgressHeight)];
    
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.frame = CGRectMake((self.frame.size.width - kActivityIndicatorViewHeight) / 2, self.frame.size.height - kActivityIndicatorViewHeight - 5.f, kActivityIndicatorViewHeight, kActivityIndicatorViewHeight);
        [self addSubview:_activityIndicatorView];
        
        self.insertMore = YES;
        self.isScrollDecelerating = NO;
        
        [self addObserver:self forKeyPath:@"isScrollDecelerating" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

- (void)setInsertMore:(BOOL)insertMore{
    
    _insertMore = insertMore;
    
    if(insertMore){
        
        self.noticeInfoLabel.hidden = YES;
        self.activityIndicatorView.hidden = NO;
    }
    else {
        
        self.noticeInfoLabel.hidden = NO;
        self.activityIndicatorView.hidden = YES;
    }
}

- (UILabel *)noticeInfoLabel{

    if(!_noticeInfoLabel){
    
        UIFont *noticeInfoLabelFont = FONT_SYSTEM(13.f);
        _noticeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds)) / 2, 0.f, CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), noticeInfoLabelFont.lineHeight)];
//        _noticeInfoLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _noticeInfoLabel.textColor = [UIColor grayColor666666];
        _noticeInfoLabel.textAlignment = NSTextAlignmentCenter;
        _noticeInfoLabel.font = noticeInfoLabelFont;
        _noticeInfoLabel.text = @"没有更多了";
        
        [self addSubview:_noticeInfoLabel];
    }
    
    return _noticeInfoLabel;
}

- (void)adjustFrameWithContentSize{
    // 内容的高度
    CGFloat contentHeight = self.scrollView.contentSize.height+5;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.bounds.size.height - self.originalTopInset - self.originalBottomInset + 5;
    // 设置位置和尺
    CGRect newRect = self.frame;
    
    if(scrollHeight > contentHeight){
        
        newRect.origin.y = contentHeight;
    }
    else {
        newRect.origin.y = contentHeight;
    }
    //newRect.origin.y = MAX(contentHeight, scrollHeight);
    
    DLOG(@"observeValueForKeyPath<contentSize>:%@;%@", @(contentHeight), @(scrollHeight));
    self.frame = newRect;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //!self.insertMore ||
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if([@"contentSize" isEqualToString:keyPath]) {
        // 调整frame
        [self adjustFrameWithContentSize];
    }
    else if([@"contentOffset" isEqualToString:keyPath]) {
        // 调整状态
        if(!self.insertMore && (!self.scrollView.dragging || !self.scrollView.isDecelerating)){
            
            [self showNoticeInfoLabel];
        }
        else {
            
            [self adjustStateWithContentOffset];
        }
        
//        DLOG(@"observeValueForKeyPath<contentOffset>:%@", NSStringFromCGPoint(self.scrollView.contentOffset));
    }
    else if([@"isScrollDecelerating" isEqualToString:keyPath]) {
        DLOG(@"observeValueForKeyPath<isScrollDecelerating>:%@", [[change valueForKey:NSKeyValueChangeNewKey] boolValue]?@"YES":@"NO");
        if((self.state == ABProgressRefreshStateLoading) &&
           ![[change valueForKey:NSKeyValueChangeNewKey] boolValue]){
            [self actionTriggeredStateResetInset];
        }
    }
}

- (void)adjustStateWithContentOffset{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY < happenOffsetY) return;
    
    CGFloat normal2pullingOffsetY = happenOffsetY + 1;//self.bounds.size.height;
    
    switch (_state) {
        case ABProgressRefreshStateStopped:{ //finish
            //NSLog(@"StateStop");
            //[self actionStopState];
            break;
        }
        case ABProgressRefreshStateNone:{ //detect action
            //NSLog(@"StateNone");
            if((self.scrollView.isDragging || self.scrollView.isDecelerating) && (currentOffsetY > normal2pullingOffsetY))
            {
                self.state = ABProgressRefreshStateTriggering;
            }
            
            break;
        }
        case ABProgressRefreshStateTriggering:{ //progress
            //NSLog(@"StateTrigering");
            
            if((currentOffsetY - normal2pullingOffsetY) > 1.0){//25.0
                self.state = ABProgressRefreshStateTriggered;
            }
            
            break;
        }
        case ABProgressRefreshStateTriggered:{ //fire actionhandler
            //NSLog(@"StateTrigered %f dragging %d",prevProgress,self.scrollView.dragging);
            if(!self.scrollView.dragging || !self.scrollView.isDecelerating)
                [self actionTriggeredState];
            
            break;
        }
        case ABProgressRefreshStateLoading:{ //wait until stopIndicatorAnimation
            //NSLog(@"PullToRefreshStateLoading");
            break;
        }
        default:
            break;
    }
}

- (void)actionTriggeredStateResetInset{
    
}

- (void)showNoticeInfoLabel{
    
    __WeakObject(self);
    [UIView animateWithDuration:0.25 animations:^{
        
        __WeakStrongObject();
        CGFloat bottom = __strongObject.frame.size.height + __strongObject.originalBottomInset;
//        CGFloat deltaH = [__strongObject heightForContentBreakView];
//        if (deltaH < 0) {
//            // 如果内容高度小于view的高度
//            bottom -= deltaH;
//        }

        UIEdgeInsets inset = __strongObject.scrollView.contentInset;
        inset.bottom = bottom;
        __strongObject.scrollView.contentInset = inset;

        CGRect _NILabelRect = __strongObject.noticeInfoLabel.frame;
        _NILabelRect.origin.y = (inset.bottom - _NILabelRect.size.height) / 2.f;
        __strongObject.noticeInfoLabel.frame = _NILabelRect;
    }];
}

- (void)actionTriggeredState{
    self.state = ABProgressRefreshStateLoading;
    
    __block __typeof(self)__blockSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat bottom = __blockSelf.frame.size.height + __blockSelf.originalBottomInset;
        CGFloat deltaH = [__blockSelf heightForContentBreakView];
        if (deltaH < 0) { // 如果内容高度小于view的高度
            bottom -= deltaH;
        }
        
        UIEdgeInsets inset = __blockSelf.scrollView.contentInset;
        inset.bottom = bottom;
        __blockSelf.scrollView.contentInset = inset;
    }];
    
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.alpha = 0.0;
    [UIView animateWithDuration:0.24 animations:^{
        __blockSelf.activityIndicatorView.alpha = 1.0;
    } completion:nil];
    
    if (self.beginRefreshingHandle) {
        self.beginRefreshingHandle();
    }
}

- (void)stopIndicatorAnimation{
    self.state = ABProgressRefreshStateNone;
    [self.activityIndicatorView stopAnimating];
    
    __block __typeof(self)__blockSelf = self;
    
    [UIView animateWithDuration:0.24 animations:^{
        __blockSelf.activityIndicatorView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [__blockSelf.activityIndicatorView stopAnimating];
        __blockSelf.activityIndicatorView.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets inset = __blockSelf.scrollView.contentInset;
        inset.bottom = __blockSelf.originalBottomInset;
        __blockSelf.scrollView.contentInset = inset;
    }];
}

- (CGFloat)happenOffsetY{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.originalTopInset;
    }
    else {
        return -self.originalTopInset;
    }
}

- (CGFloat)heightForContentBreakView{
    CGFloat h = self.scrollView.frame.size.height - self.originalBottomInset - self.originalTopInset;
    return self.scrollView.contentSize.height - h;
}

- (void)setMoreInfoString:(NSString *)moreInfoString{
    
    if([NSString isValid:moreInfoString]){
        
        self.noticeInfoLabel.text = moreInfoString;
    }
}

@end
