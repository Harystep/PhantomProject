//
//  UIScrollView+ABProgressRefresh.m
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import "UIScrollView+ABProgressRefresh.h"
#import "ABInsertProgressView.h"
#import "ABPullProgressView.h"
#import <objc/runtime.h>

static char ABPullProgressViewKey;
static char ABInsertProgressViewKey;

@interface UIScrollView()

@property (nonatomic, strong, readonly) ABPullProgressView *pullProgressView;
@property (nonatomic, strong, readonly) ABInsertProgressView *insertProgressView;

@end

@implementation UIScrollView (ABProgressRefresh)

#pragma mark -
#pragma mark - Pull
- (void)addPullToRefreshActionHandler:(void(^)())handle{
    
    if(!self.pullProgressView){
        
        // ABPullProgressView *pullProgressView = [[ABPullProgressView alloc] initWithImage:[UIImage imageNamed:@"centerIcon.png"]];
        
        ABPullProgressView *pullProgressView = [[ABPullProgressView alloc] initWithFrame:CGRectMake(0, - kPullProgressViewHeight, self.frame.size.width, kPullProgressViewHeight) animateType:ABProgressAnimateStyleNormal withObjects:nil];
        
        pullProgressView.scrollView = self;
        pullProgressView.beginRefreshingHandle = handle;
        pullProgressView.originalTopInset = self.contentInset.top;
        
        [self addSubview:pullProgressView];
        self.pullProgressView = pullProgressView;
    }
}

- (void)triggerPullToRefresh{
    
    if(self.pullProgressView){
        
        [self.pullProgressView manuallyTriggered];
    }
}

- (void)stopPullRefreshAnimation{
    
    if(self.pullProgressView){
        
        [self.pullProgressView stopIndicatorAnimation];
    }
}

- (void)removePullRefreshView{
    
    [self.pullProgressView removeFromSuperview];
    self.pullProgressView = nil;
}

#pragma mark Pull Getter
- (void)setPullProgressView:(ABPullProgressView *)pullProgressView{
    
    [self willChangeValueForKey:@"ABPullProgressView"];
    objc_setAssociatedObject(self, &ABPullProgressViewKey, pullProgressView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ABPullProgressView"];
}

- (ABPullProgressView *)pullProgressView{
    
    return objc_getAssociatedObject(self, &ABPullProgressViewKey);
}

- (void)setPullRefreshing:(BOOL)pullRefreshing{
    
}

- (BOOL)isPullRefreshing{
    
    return YES;
}

#pragma mark -
#pragma mark - Insert
- (void)addInsertToRefreshActionHandler:(void(^)())handle{
    
    if(!self.insertProgressView){
        
        ABInsertProgressView *insertProgressView = [[ABInsertProgressView alloc] init];
        
        //insertProgressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        
        insertProgressView.scrollView = self;
        insertProgressView.frame = CGRectMake((self.bounds.size.width - insertProgressView.bounds.size.width)/2, insertProgressView.frame.origin.y, insertProgressView.bounds.size.width, insertProgressView.bounds.size.height);
        insertProgressView.originalTopInset = self.contentInset.top;
        insertProgressView.originalBottomInset = self.contentInset.bottom;
        insertProgressView.beginRefreshingHandle = handle;
        
        [self addSubview:insertProgressView];
        self.insertProgressView = insertProgressView;
    }
}

- (void)stopInsertRefreshAnimation{
    
    if(self.insertProgressView){
        
        [self.insertProgressView stopIndicatorAnimation];
    }
}

- (void)removeInsertRefreshView{
    
    [self stopInsertRefreshAnimation];
    [self.insertProgressView removeFromSuperview];
    self.insertProgressView = nil;
}

- (void)setMoreInfoString:(NSString *)moreInfoString{
    
    self.insertProgressView.moreInfoString = moreInfoString;
}

#pragma mark Inster Getter
- (void)setInsertProgressView:(ABInsertProgressView *)insertProgressView{
    
    [self willChangeValueForKey:@"ABInsertProgressView"];
    objc_setAssociatedObject(self, &ABInsertProgressViewKey, insertProgressView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"ABInsertProgressView"];
}

- (ABInsertProgressView *)insertProgressView{
    
    return objc_getAssociatedObject(self, &ABInsertProgressViewKey);
}

- (void)setInsertMore:(BOOL)insertMore{
    
    if(self.insertProgressView){
        
        [self stopInsertRefreshAnimation];
        self.insertProgressView.insertMore = insertMore;
    }
}

- (BOOL)isInsertMore{
    
    if(self.insertProgressView){
        
        return self.insertProgressView.insertMore;
    }
    
    return NO;
}

- (void)setInsertRefreshing:(BOOL)insertRefreshing{
    
}

- (BOOL)isInsertRefreshing{
    
    return NO;
}

#pragma mark -
#pragma mark -
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    if(self.insertProgressView){
        
        self.insertProgressView.isScrollDecelerating = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.insertProgressView){
        
        self.insertProgressView.isScrollDecelerating = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    DLOG(@"scrollViewDidEndScrollingAnimation");
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    LOG(@"scrollViewWillBeginDragging");
//}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
//    LOG(@"scrollViewWillEndDragging");
//}
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    LOG(@"scrollViewDidEndDragging::%@", decelerate?@"YES":@"NO");
//}

@end
