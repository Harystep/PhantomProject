//
//  ABPullProgressView.m
//  TreasureHunter
//
//  Created by Abner on 14/10/11.
//
//

#import "ABPullProgressView.h"
#import <SDWebImage/UIImage+GIF.h>
#import "UIImageView+ABCicleImageView.h"

@interface ABPullProgressView()

@property (nonatomic, assign) ABProgressAnimateStyle animateStyle;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) UIImage *imageIcon;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) NSString *gifName;

@end

@implementation ABPullProgressView

- (instancetype)initWithFrame:(CGRect)frame
                  animateType:(ABProgressAnimateStyle)style
                  withObjects:(id)objects{
    
    if(self = [super initWithFrame:frame]){
        
        self.animateStyle = style;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        if(ABProgressAnimateStyleImage == style){
        
            self.imageIcon = [UIImage imageNamed:kPullRefreshImageName];
            [self commonInit];
        }
        else if(ABProgressAnimateStyleGifImage == style){
            
            self.gifName = kPullRefreshImageName;
            [self commonInitForGif];
        }
        else if(ABProgressAnimateStyleNormal == style){
            
            [self commonDefault];
        }
    }
    
    return self;
}

- (void)commonInitForGif{
    
    self.contentMode = UIViewContentModeRedraw;
    self.state = ABProgressRefreshStateNone;
    
    NSData *gifImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.gifName ofType:@"gif"]];
    if(gifImageData){
        
        _gifImageView = [[UIImageView alloc] initWithImage:[UIImage sd_imageWithGIFData:gifImageData]];
        _gifImageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + kPadding);
        [self addSubview:_gifImageView];
    }
}

- (void)commonInit{
    
    self.contentMode = UIViewContentModeRedraw;
    self.state = ABProgressRefreshStateNone;
    
    //init actitvity indicator
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"centerIcon_cicle.png"]];
    [_imageView hidesWhenStopped];
    [self addSubview:_imageView];
    
    if(!self.imageIcon)
        self.imageIcon = [UIImage imageNamed:@"centerIcon.png"];
    
    //init icon layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.frame = self.bounds;
    imageLayer.contents = (id)self.imageIcon.CGImage;
    [self.layer addSublayer:imageLayer];
    
    self.imageLayer = imageLayer;
    //self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180),0,0,1);
}

- (void)commonDefault{
    
    self.contentMode = UIViewContentModeRedraw;
    self.state = ABProgressRefreshStateNone;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + kPadding);
    [self addSubview:_indicatorView];
    
    [_indicatorView startAnimating];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setOriginalTopInset:(CGFloat)originalTopInset{
    _originalTopInset = originalTopInset;
    
    self.indicatorView.centerY = (self.bounds.size.height / 2 + kPadding) - originalTopInset;
}

- (void)setupScrollViewContentInsetForLoadingIndicator:(void(^)(void))handler{
    //CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height;// + TEMP_OFFSET;//MIN(offset, self.originalTopInset + self.bounds.size.height + TEMP_OFFSET);
    [self setScrollViewContentInset:currentInsets handler:handler];
}

- (void)resetScrollViewContentInset:(void(^)(void))handler{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets handler:handler];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(void(^)(void))handler{
    //UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                         float contentTop = self.scrollView.contentOffset.y;
                         [self.scrollView setContentOffset:CGPointMake(0, contentTop) animated:NO];
                     }
                     completion:^(BOOL finished) {
                         if(handler)
                             handler();
                     }];
}

#pragma mark - property
double prevProgress = 0.0;
- (void)setProgress:(double)progress{
    //static double prevProgress = 0.0;
    
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    
    //self.alpha = 1.0 * progress;
    
    if(self.alpha < 0.1 && progress < 0.1) return;
    
    if(progress == 1.0 && prevProgress == 0.0){
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180*prevProgress)];//(180-180*prevProgress)
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180*progress)];
        animationImage.duration = 0.15;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        /*
         [CATransaction setDisableActions:YES];
         self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180-180*progress), 0, 0, 1);
         [CATransaction setDisableActions:NO];
         */
        [self.imageLayer addAnimation:animationImage forKey:@"animation"];
        prevProgress = 1.0;
    }
    else if (progress >= 0 && progress < 1.0 && prevProgress == 1.0) {
        //rotation Animation
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180*prevProgress)];//(180-180*prevProgress)
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180*0)];
        animationImage.duration = 0.15;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        /*
         [CATransaction setDisableActions:YES];
         self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180-180*progress), 0, 0, 1);
         [CATransaction setDisableActions:NO];
         */
        [self.imageLayer addAnimation:animationImage forKey:@"animation"];
        prevProgress = 0.0;
    }
    _progress = progress;
    //prevProgress = progress;
}

- (void)setLayerOpacity:(CGFloat)opacity{
    self.imageLayer.opacity = opacity;
}

- (void)setLayerHidden:(BOOL)hidden{
    self.imageLayer.hidden = hidden;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    else if([keyPath isEqualToString:@"frame"])
    {
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset{
    static double prevProgress;
    //NSLog(@"dragging %d",self.scrollView.dragging);
    CGFloat yOffset = contentOffset.y;
    
    self.progress = - ((yOffset + self.originalTopInset) / self.frame.size.height);
    //LOG(@"%f", self.progress);
    
    //self.center = CGPointMake(self.center.x, MIN(-self.bounds.size.height/2, (contentOffset.y+ self.originalTopInset)/2));
    switch (_state) {
        case ABProgressRefreshStateStopped:{ //finish
            //NSLog(@"StateStop");
            //[self actionStopState];
            break;
        }
        case ABProgressRefreshStateNone:{ //detect action
            //NSLog(@"StateNone");
            if(self.scrollView.isDragging && yOffset <0 )
            {
                self.state = ABProgressRefreshStateTriggering;
            }
            break;
        }
        case ABProgressRefreshStateTriggering:{ //progress
            //NSLog(@"StateTrigering");
            if(self.progress >= 1.0)
                self.state = ABProgressRefreshStateTriggered;
            break;
        }
        case ABProgressRefreshStateTriggered:{ //fire actionhandler
            //NSLog(@"StateTrigered %f dragging %d",prevProgress,self.scrollView.dragging);
            if(self.scrollView.dragging == NO && prevProgress > 0.99)
            {
                [self actionTriggeredState:YES];
            }
            break;
        }
        case ABProgressRefreshStateLoading:{ //wait until stopIndicatorAnimation
            //NSLog(@"PullToRefreshStateLoading");
            break;
        }
        default:
            break;
    }
    //because of iOS6 KVO performance
    prevProgress = self.progress;
}

- (void)actionStopState{
    self.state = ABProgressRefreshStateNone;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        self.imageView.transform = CGAffineTransformIdentity;
        [self.imageView stopCicleAnimation];
        
        //加载完之后不返回到scrollView顶部
        /*
         [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
         LOG(@"%f",(self.originalTopInset + self.bounds.size.height + TEMP_OFFSET));
         */
        
        [self resetScrollViewContentInset:^{
            [self setLayerHidden:NO];
            [self setLayerOpacity:1.0];
        }];
        
    }];
}

- (void)actionTriggeredState:(BOOL)isSound{
    self.state = ABProgressRefreshStateLoading;
    
    //UIViewAnimationOptionCurveEaseInOut|
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [self setLayerOpacity:0.0];
    } completion:^(BOOL finished) {
        
        [self setLayerHidden:YES];
    }];
    
    [self.imageView startCicleAnimation];
    [self setupScrollViewContentInsetForLoadingIndicator:nil];
    
    if(self.beginRefreshingHandle){
        //播放声音代码
        
        self.beginRefreshingHandle();
    }
}

#pragma mark - public method
- (void)stopIndicatorAnimation{
    [self actionStopState];
}

- (void)manuallyTriggered{
    [self setLayerOpacity:0.0];
    
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height + TEMP_OFFSET;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top);
    } completion:^(BOOL finished) {
        
        [self actionTriggeredState:NO];
    }];
    //[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top) animated:YES];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        CGRect newRect = self.frame;
        // 设置宽度
        newRect.size.width = newSuperview.frame.size.width;
        // 设置位置
        self.frame = newRect;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
//        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

@end

