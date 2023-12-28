//
//  LoadingView.m
//  Interactive
//
//  Created by Abner on 15/12/29.
//  Copyright © 2015年 Abner. All rights reserved.
//

#import "LoadingView.h"

#import <SDWebImage/UIImage+GIF.h>

static const CGFloat kLoadingWidth = 80.f;
static const CGFloat kInnerCircleWidth = 72.f;
static const CGFloat kProgressWidth = 4.f;
static const NSInteger kLodingViewTag = 70707;

@interface LoadingView()

@property (nonatomic, strong) NSMutableArray *loadingViewList;
//@property (nonatomic, strong) UIImageView *loadingBackView;
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL stopFlag;
@property (nonatomic, assign) NSInteger showNum;
@property (nonatomic, assign) NSInteger showProgressNum;

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) NSArray *loadingImageArray;

@property (nonatomic, strong) UILabel *textInfoLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)startAnimationWithScale:(CGFloat)scale;
- (void)stopTimer;

@end

@implementation LoadingView

+ (LoadingView *)sharedLoadingView{
    
    static LoadingView *sharedLoadingView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoadingView = [LoadingView new];
    });
    
    return sharedLoadingView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.showProgressNum = 0;
        self.showNum = 0;
        
        self.loadingViewList = [NSMutableArray array];
    }
    
    return self;
}

- (void)showLoadingForView:(UIView *)view{
    self.frame = view.bounds;
    self.userInteractionEnabled = YES;
    
    UIView *gifBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74.f + 40.f, 74.f + 45.f)];
    gifBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];//UIColorFromRGB_ALPHA(0x666666, 0.8);
    gifBackView.layer.cornerRadius = 10.f;
    gifBackView.center = self.center;
    [self addSubview:gifBackView];
    
    [gifBackView addSubview:self.activityIndicatorView];
    self.activityIndicatorView.center = CGPointMake(gifBackView.width / 2.f, gifBackView.height / 2.f);
    [self.activityIndicatorView startAnimating];
    
#ifdef GIFIMAGEVIEW
    if(!self.gifImageView){
        
        // UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"loading1"];
        
        self.gifImageView = [UIImageView new];
        // gifImageView.clipsToBounds = YES;
        self.gifImageView.frame = CGRectMake(0, 0, 74.f, 40.f);
        self.gifImageView.backgroundColor = [UIColor clearColor];
        // self.gifImageView.image = gifImage;
        self.gifImageView.animationDuration = 1.5f;
        self.gifImageView.animationRepeatCount = 0;
        self.gifImageView.animationImages = self.loadingImageArray;
    }
    
//    UIImageView *gifMaskImageView = [UIImageView new];
//    gifMaskImageView.clipsToBounds = YES;
//    gifMaskImageView.frame = CGRectMake(0, 0, 40, 19);
//    gifMaskImageView.backgroundColor = [UIColor clearColor];
//    gifMaskImageView.image = IMAGE_NAMED(@"img_loading");
    
    UIView *gifBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74.f + 40.f, 74.f + 45.f)];
    gifBackView.backgroundColor = [UIColor whiteColorffffffAlpha:0.8];//UIColorFromRGB_ALPHA(0x666666, 0.8);
    gifBackView.layer.cornerRadius = 10.f;
    [self addSubview:gifBackView];
    
    self.textInfoLabel.origin = CGPointMake((gifBackView.width - self.textInfoLabel.width) / 2.f, CGRectGetHeight(gifBackView.frame) - self.textInfoLabel.height - 25.f);
    [gifBackView addSubview:self.textInfoLabel];
    
    if(!self.progressView){
        self.progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 0, kProgressWidth + kInnerCircleWidth, kProgressWidth + kInnerCircleWidth)];
    }
    self.progressView.center = self.gifImageView.center = gifBackView.center = self.center;
    self.gifImageView.centerY -= 15.f;
    
    [self.gifImageView startAnimating];
    [self addSubview:self.gifImageView];
    // [self addSubview:gifMaskImageView];
    [self addSubview:self.progressView];
#endif
}

#pragma mark - Interface
+ (LoadingView *)startLoadingForView:(UIView *)view withProgress:(CGFloat)progress{
    
    LoadingView *loadingView;
    
    if(!view){
        loadingView = [LoadingView sharedLoadingView];
    }
    else {
        loadingView = [view viewWithTag:kLodingViewTag];
        
        if(!loadingView){
            
            loadingView = [LoadingView new];
            loadingView.tag = kLodingViewTag;
        }
    }
    
    //[[LoadingView alloc] initWithFrame:view.bounds];
    
    if(loadingView.showNum == 0){
        
        [loadingView showLoadingForView:view];
        
        loadingView.stopFlag = NO;
        loadingView.lastScale = 1.0f;
        [view addSubview:loadingView];
    }
    
    if(progress >= 0){
        [loadingView.progressView setProgress:progress];
    }
    //[loadingView startAnimationWithScale:1.25f];
    
    loadingView.showNum += 1;
    [loadingView setNeedsDisplay];
    [loadingView.activityIndicatorView startAnimating];
    
    DLOG(@"loadingView show:%@", @(loadingView.showNum));
    
    return loadingView;
}

+ (void)stopLoadingForView:(UIView *)view{
    LoadingView *loadingView;
    
    if(!view){
        loadingView = [LoadingView sharedLoadingView];
    }
    else {
        loadingView = [view viewWithTag:kLodingViewTag];
        
        if(!loadingView){
            
            return;
        }
    }
    
    if(loadingView.showNum == 1){
        
        [loadingView stopTimer];
        [loadingView.activityIndicatorView stopAnimating];
        loadingView.showNum = 0;
        
        [loadingView removeFromSuperview];
        // [loadingView.progressView setProgress:1.f];
    }
    else{
        
        loadingView.showNum -= 1;
    }
    
    DLOG(@"loadingView hide:%@", @(loadingView.showNum));
    
    /*
    NSArray *allLoadingViews = [self allLoadingForView:view];
    for(LoadingView *loadingView in allLoadingViews){
        [loadingView stopTimer];
        [loadingView removeFromSuperview];
    }
     */
}

+ (void)stopLoadingForcible{
    
    LoadingView *loadingView = [LoadingView sharedLoadingView];
    
    [loadingView stopTimer];
    [loadingView removeFromSuperview];
    
    // [loadingView.progressView setProgress:1.f];
    loadingView.showNum = 0;
}

+ (void)stopLoadingForcibleWithView:(UIView *)view{
    LoadingView *loadingView;
    
    if(!view){
        loadingView = [LoadingView sharedLoadingView];
    }
    else {
        loadingView = [view viewWithTag:kLodingViewTag];
        
        if(!loadingView){
            
            return;
        }
    }
    
    [loadingView.activityIndicatorView stopAnimating];
    [loadingView removeFromSuperview];
    loadingView.showNum = 0;
}

//+ (void)stopProgressLoadingView{
//    LoadingView *loadingView = [LoadingView sharedLoadingView];
//    
//    if(loadingView.showProgressNum == 1){
//        
//        if(loadingView.showNum == 0){
//            
//            [loadingView stopTimer];
//            [loadingView.progressView setProgress:0.f];
//            [loadingView removeFromSuperview];
//            
//            loadingView.showProgressNum = 0;
//        }
//        else {
//            
//            loadingView.showProgressNum += 1;
//        }
//    }
//    
//    loadingView.showProgressNum -= 1;
//}

//+ (LoadingView *)startLoadingForView:(UIView *)view withProgress:(CGFloat)progress{
//   
//    LoadingView *loadingView = [LoadingView sharedLoadingView];
//    //[[LoadingView alloc] initWithFrame:view.bounds];
//    
//    if(loadingView.showProgressNum == 0){
//        
//        if(loadingView.showNum == 0){
//            
//            [loadingView showLoadingForView:view];
//            
//            loadingView.stopFlag = NO;
//            loadingView.lastScale = 1.0f;
//            [view addSubview:loadingView];
//        }
//        
//        [loadingView.progressView setProgress:progress];
//        //[loadingView startTimer];
//    }
//    
//    loadingView.showProgressNum += 1;
//    
//    return loadingView;
//}

+ (id)loadingForView:(UIView *)view{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LoadingView *)subview;
        }
    }
    
    return nil;
}

+ (NSArray *)allLoadingForView:(UIView *)view{
    NSMutableArray *loadingViews = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [loadingViews addObject:aView];
        }
    }
    
    return [NSArray arrayWithArray:loadingViews];
}

#pragma mark - Layout
- (void)willMoveToSuperview:(UIView *)newSuperview{
    
//    if (newSuperview == nil) {
//        return;
//    }
//    
//    self.alpha = 0.0f;
//    [UIView animateWithDuration:0.15f animations:^{
//        self.alpha = 1.0f;
//    }];
    
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    
    for(UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    
    self.showNum = 0;
    
    [super removeFromSuperview];
    
//    [UIView animateWithDuration:0.15f animations:^{
//        self.alpha = 0.0f;
//    } completion:^(BOOL finished) {
//        
//        for(UIView *subView in self.subviews){
//            [subView removeFromSuperview];
//        }
//        
//        [super removeFromSuperview];
//    }];
}

/*
- (void)drawRect:(CGRect)rect{
    
    if(self.progress > 0){
        
        self.gifImageView.hidden = YES;
        
        CGFloat viewAlpha = 0.5f;
        CGFloat inner_radius = kInnerCircleWidth;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetRGBStrokeColor(context, 255, 204, 0, viewAlpha);
        CGContextSetLineWidth(context, kProgressWidth);
        CGContextAddArc(context, self.center.x, self.center.y, kLoadingWidth/2, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        CGContextSetFillColorWithColor(context, RGB_COLOR_ALPHA(255, 204, 0, viewAlpha).CGColor);
        CGContextSetLineWidth(context, 0.f);
        CGContextAddArc(context, self.center.x, self.center.y, inner_radius/2, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else {
        self.gifImageView.hidden = NO;
    }
}
 */

#pragma mark - Privated
- (void)startAnimationWithScale:(CGFloat)scale{
    
//    [self animationWithScale:scale];
//    [self startTimer];
}

//- (void)animationWithScale:(CGFloat)scale{
//    [self.imageView.layer removeAllAnimations];
//    
//    UIViewAnimationOptions option;
//    NSTimeInterval durationTime;
//    if(scale == 1.0){
//        durationTime = 0.5f;
//        option = UIViewAnimationOptionCurveEaseOut;
//    }
//    else {
//        durationTime = 1.f;
//        option = UIViewAnimationOptionCurveEaseInOut;
//    }
//    
//    [UIView animateWithDuration:durationTime delay:0.f options:option animations:^{
//        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
//    } completion:^(BOOL finished) {
//        if(!_stopFlag && finished){
//            _stopFlag = YES;
//            
//            [self animationWithScale:self.lastScale];
//            self.lastScale = scale;
//        }
//    }];
//}

#pragma mark - Timer
- (void)startTimer{
    __BlockObject(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!__blockObject.timer){
            __blockObject.timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:__blockObject.timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        }
    });
}

- (void)stopTimer{
    if(self.timer && [self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    _stopFlag = YES;
}

- (void)timerAction:(id)sender{
    
    _stopFlag = NO;
    //[self animationWithScale:self.lastScale];
    
//    if(self.lastScale > 1.0){
//        self.lastScale = 1.0f;
//    }
//    else {
//        self.lastScale = 1.25f;
//    }
    
    self.progress += 0.01;
    [HelpTools setLoadingProgress:self.progress];
}

- (NSArray *)loadingImageArray{
    
    if(!_loadingImageArray){
        
        _loadingImageArray = [NSArray arrayWithObjects:
                              IMAGE_NAMED(@"loading_image_10001"),
                              IMAGE_NAMED(@"loading_image_10002"),
                              IMAGE_NAMED(@"loading_image_10003"),
                              IMAGE_NAMED(@"loading_image_10004"),
                              IMAGE_NAMED(@"loading_image_10005"),
                              IMAGE_NAMED(@"loading_image_10006"),
                              IMAGE_NAMED(@"loading_image_10007"),
                              IMAGE_NAMED(@"loading_image_10008"),
                              IMAGE_NAMED(@"loading_image_10009"),
                              IMAGE_NAMED(@"loading_image_10010"),
                              IMAGE_NAMED(@"loading_image_10011"),
                              IMAGE_NAMED(@"loading_image_10012"),
                              nil];
    }
    
    return _loadingImageArray;
}

- (UIActivityIndicatorView *)activityIndicatorView{
    
    if(!_activityIndicatorView){
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.color = [UIColor blackColor333333];
    }
    
    return _activityIndicatorView;
}

- (UILabel *)textInfoLabel{
    
    if(!_textInfoLabel){
        
        _textInfoLabel = [UILabel new];
        _textInfoLabel.textColor = [UIColor whiteColorffffffAlpha:0.8];
        _textInfoLabel.textAlignment = NSTextAlignmentCenter;
        _textInfoLabel.font = [UIFont font14];
        _textInfoLabel.text = @"加载中......";
        
        [_textInfoLabel sizeToFit];
    }
    
    return _textInfoLabel;
}

@end

#pragma mark -
/**
 *  ProgressView
 */
@interface ProgressView()

@property (nonatomic, strong) UILabel *processLabel;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        //self.layer.cornerRadius = frame.size.width/2;
        self.userInteractionEnabled = YES;
        // self.clipsToBounds = YES;
        // self.progress = 1.f;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    if(self.progress > 0){
        
        if(self.progress != 1){
            NSString *progressStr = [NSString stringWithFormat:@"%.1f%s", self.progress * 100, "\%"];
            //progressStr = [NSString stringWithFormat:@"%@%s", @([progressStr floatValue]), "\%"];
            [self setCenterProgressText:progressStr];
        }
        else if(_processLabel){
            _processLabel.text = @"";
        }
    }
}

/*
- (void)drawRect:(CGRect)rect{
    
    if(self.progress > 0){
    
        CGFloat viewAlpha = 0.5f;
        CGFloat view_radius = self.frame.size.width - kProgressWidth + 2.f;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2;
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0, viewAlpha);
        CGContextSetLineWidth(context, kProgressWidth - 1.915);//1.915
        CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, view_radius/2, - M_PI * 0.5, to, 0);
        CGContextDrawPath(context, kCGPathStroke);
        
        if(self.progress != 1){
            NSString *progressStr = [NSString stringWithFormat:@"%.1f%s", self.progress * 100, "\%"];
            //progressStr = [NSString stringWithFormat:@"%@%s", @([progressStr floatValue]), "\%"];
            [self setCenterProgressText:progressStr];
        }
        else if(_processLabel){
            _processLabel.text = @"";
        }
    }
}
 */

- (void)setCenterProgressText:(NSString *)progressStr{
    
    if(!_processLabel){
        UIFont *labelFont = FONT_SYSTEM(12.f);
        
        _processLabel = [UILabel new];
        _processLabel.frame = CGRectMake(0, labelFont.lineHeight * -1.0, self.width, labelFont.lineHeight);
        _processLabel.textAlignment = NSTextAlignmentCenter;
        _processLabel.textColor = [UIColor mainYellowColor];
        _processLabel.font = labelFont;
        [self addSubview:_processLabel];
        _processLabel.alpha = 0.5f;
    }
    
    _processLabel.text = progressStr;
}

#pragma mark -
- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    [self setNeedsDisplay];
    
    //DLOG(@"onArDownloadProgress::::%f", progress);
}

@end

