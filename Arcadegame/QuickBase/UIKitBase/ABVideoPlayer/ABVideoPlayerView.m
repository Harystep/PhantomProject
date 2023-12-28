//
//  ABVideoPlayerView.m
//  AvPlayerDemo
//
//  Created by Abner on 14/10/17.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "ABVideoPlayerView.h"
#import "ABValueSlider.h"
@class PlayRecordManager;

#define TIMESLIDERLABEL_TEXT(a, b) [NSString stringWithFormat:@"%@ / %@", a, b]
#define BTN_PALY_TAG    8765
#define BTN_RELOAD_TAG  8763

typedef void(^PlayFinishBlock)(void);

typedef NS_ENUM(NSInteger, VideoPlayerViewMode){
    VideoPlayerViewModeNetWork = 0, //播放网络视频
    VideoPlayerViewModeLocal        //播放本地视频
};

typedef NS_ENUM(NSInteger, TouchGestureType){
    TouchGestureTypeOfNone = 0,     //无触摸手势
    TouchGestureTypeOfVolume,       //音量区触发
    TouchGestureTypeOfProgress,     //进度条区触发
    TouchGestureTypeOfBrightness    //屏幕亮度区触发
};

@interface  ABVideoPlayerView(){
    UIButton *_playButton;
    UIButton *_fullScreenButton;
    UILabel *_timeSliderLabel;
    UILabel *_currentTimeSliderLabel;
    NSDateFormatter *_dateFormatter;
    ABValueSlider *_sliderView;
    PlayFinishBlock _playFinishBlock;
}

@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL isFullscreen;
@property(nonatomic, assign) BOOL isFirstOpen;
@property(nonatomic, assign) BOOL isAutoDismissPeriod; //是否在计时中
@property(nonatomic, assign) BOOL isClickDismissed;    //是否已消失
@property(nonatomic, assign) BOOL isPlayerDestroy;     //是否被销毁
@property(nonatomic, assign) BOOL isLoadFailed;        //加载失败
@property(nonatomic, assign) CGRect playerViewFrame;
@property(nonatomic, assign) CGFloat videoLength;
@property(nonatomic, assign) NSInteger currentPlayingItem;
@property(nonatomic, assign) CGFloat sliderBeginValue;
@property(nonatomic, strong) NSArray *videoList;
@property(nonatomic, strong) NSMutableArray *itemTimeList;
@property(nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;
@property(nonatomic, strong) AVPlayer *videoPlayer;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *currentSuperView;
@property(nonatomic, assign) id periodicTimeObserver;
@property(nonatomic, assign) TouchGestureType touchGestureType;
@property(nonatomic, assign) VideoPlayerViewMode videoPlayerMode;
@property(nonatomic) UIDeviceOrientation playerDeviceOrientation;

@end

@implementation ABVideoPlayerView

- (void)removeFromSuperview{
    [super removeFromSuperview];
    
    [self destroyPlayer:YES];
}

- (void)dealloc{
    [self destroyPlayer:YES];
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame withVideoUrl:(NSURL *)url{
    self = [self initWithFrame:frame];
    if(self){
        _videoPlayerMode = VideoPlayerViewModeNetWork;
        self.videoList = @[url];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withLocalVideoPath:(NSString *)videoPath{
    self = [self initWithFrame:frame];
    if(self){
        _videoPlayerMode = VideoPlayerViewModeLocal;
        self.videoList = @[[NSURL fileURLWithPath:videoPath]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withLocalVideoList:(NSArray *)videoList{
    self = [self initWithFrame:frame];
    if(self){
        _videoPlayerMode = VideoPlayerViewModeLocal;
        self.videoList = videoList;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _isPlaying = NO;
        _isFirstOpen = YES;
        _isFullscreen = NO;
        _isLoadFailed = NO;
        _isPlayerDestroy = NO;
        _topViewHeight = 44.0;
        _bottomViewHeight = 44.0;
        _playerViewFrame = self.frame;
        _autoSizeForDeviceOrientation = YES;
        _playerDeviceOrientation = UIDeviceOrientationPortrait;
        _videoPlayerViewStyle = VideoPlayerViewStyleNormal;
        _playFinishBlock = nil;
        _videoList = [[NSArray alloc] init];
        _itemTimeList = [[NSMutableArray alloc] init];
        self.currentSuperView = nil;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(deviceOrientationDidChange:)
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    self.isPlayerDestroy = NO;
    self.isLoadFailed = NO;
    self.isFirstOpen = YES;
    
    [self creatBottomView];
    [self asynchronousCreateAVPlayer];
}

- (void)bringViewToFront{
    [self bringSubviewToFront:_bottomView];
    [self bringSubviewToFront:_playButton];
    //[self autoHidenOverlayer];
}

#pragma mark - Interface
- (void)setVideoData:(id)videoData{
    if([videoData isKindOfClass:[NSURL class]]) {
        NSURL *url = (NSURL *)videoData;
        self.videoList = @[url];
    }
    else if([videoData isKindOfClass:[NSString class]]) {
        NSString *videoPath = (NSString *)videoData;
        self.videoList = @[[NSURL fileURLWithPath:videoPath]];
    }
    else if([videoData isKindOfClass:[NSArray class]]) {
        self.videoList = (NSArray *)videoData;
    }
    
    [self reloadPlayer];
}

- (void)pausePlayer{
    if(_playButton){
        [self showOverlayer];
    }
    
    if(_isPlaying){
        [self playBtnAction:nil];
    }
}

- (void)startPlayer{
    if(_playButton){
        [self showOverlayer];
    }
    
    if(!_isPlaying){
        [self playBtnAction:nil];
    }
}

- (void)stopPlayer{
    /*add by zhenglinqin  2014-11-13 停止播放时需要重设一些设置*/
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerFinished)]) {
        [self.delegate videoPlayerFinished];
    }
    /* 如果使用block，在全局使用一个播放器的时候 其它地方会crash，使用delegate可避免
     if(_playFinishBlock){
        _playFinishBlock();
    }*/
    /*end*/
    [self destroyPlayer:NO];
}

- (void)videoPlayerFinished:(void(^)(void))finished{
    if(finished){
        _playFinishBlock = [finished copy];
    }
}

#pragma mark - Privated
- (void)destroyPlayer:(BOOL)isClassDestroy{
    if(!self.videoPlayer ||
       !self.periodicTimeObserver){
        return;
    }
    
    [self storePlayerHistory];
    
    if(isClassDestroy){
        self.videoList = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
    [self.videoPlayer pause];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [self.itemTimeList removeAllObjects];
    self.currentPlayingItem = 0;
    self.videoLength = 0;
    self.isPlaying = NO;
    /*
    self.isFirstOpen = YES;
    self.isFullscreen = NO;
    self.isLoadFailed = NO;
     */
    self.isPlayerDestroy = YES;
    [_sliderView resetSliderWithRatio:0.0];
    [_sliderView setSliderViewEnabled:NO];
    _currentTimeSliderLabel.text = @"00:00";
    _timeSliderLabel.text = @"00:00";
    [self resetPlayButton:BTN_PALY_TAG];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [_videoPlayer.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [_videoPlayer removeTimeObserver:_periodicTimeObserver];
    [_videoPlayer replaceCurrentItemWithPlayerItem:nil];
    self.periodicTimeObserver = nil;
    self.videoPlayer = nil;
}

- (void)reloadPlayer{
    if([self.videoList count] > 0){
        [self destroyPlayer:NO];
        [self setNeedsDisplay];
    }
}

- (void)asynchronousCreateAVPlayer{
    if([self.videoList count] <= 0){
        return;
    }
    
    __weak __typeof(self) __blockSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CMTime totalTime = CMTimeMake(0, 0);
        
        __strong __typeof(__blockSelf) __blockBlockSelf = __blockSelf;
        
        [__blockSelf.videoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSURL *url = (NSURL *)obj;
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
            CMTimeValue value = playerItem.asset.duration.value;
            totalTime.value += value;
            totalTime.timescale = playerItem.asset.duration.timescale;
            
            CMTimeScale totalTime_timescale = totalTime.timescale;
            CMTimeValue totalTime_value = totalTime.value;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [__blockBlockSelf.itemTimeList addObject:[NSNumber numberWithDouble:((double)value/totalTime_timescale)]];
                if(totalTime_value/totalTime_timescale == 0){
                    __blockBlockSelf.videoLength = 0;
                }
                else {
                    __blockBlockSelf.videoLength = (CGFloat)totalTime_value/totalTime_timescale;
                }
                
                [__blockBlockSelf createAVPlayer];
                [__blockBlockSelf bringViewToFront];
            });
        }];
    });
    
    [self showLoadingView:YES];
}

- (void)createAVPlayer{
    if([self.videoList count] <= 0){
        return;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGRect playerFrame = self.bounds;
    
    _videoPlayer = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:(NSURL *)self.videoList[0]]];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    _playerLayer.frame = playerFrame;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    
    [_videoPlayer play];
    _isPlaying = YES;
    
    //[_sliderView setSliderViewEnabled:YES];
    _playButton.enabled = YES;
    
    _currentPlayingItem = 0;
    
    //注册检测视频加载状态的通知
    [_videoPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    __weak __typeof(self) __blockSelf = self;
    __weak __typeof(_videoPlayer) __blockVideoPlayer = _videoPlayer;
    __weak __typeof(_sliderView) __blockSliderView = _sliderView;
    __weak __typeof(_timeSliderLabel) __blockTimeSliderLabel = _timeSliderLabel;
    __weak __typeof(_currentTimeSliderLabel) __blockCurrentTimeSliderLabel = _currentTimeSliderLabel;
    __weak __typeof(_itemTimeList) __blockItemTimeList = _itemTimeList;
    __typeof(_videoLength) *__blockVideoLength = &_videoLength;
    __typeof(_touchGestureType) *__blockGestureType = &_touchGestureType;
    __typeof(_currentPlayingItem) *__blockCurrentPlayingItem = &_currentPlayingItem;
    __typeof(_videoPlayerViewStyle) *__blockVideoPlayerViewStyle = &_videoPlayerViewStyle;
    //第一个参数反应了检测的频率
    _periodicTimeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(3, 30) queue:NULL usingBlock:^(CMTime time){
        if ((*__blockGestureType) != TouchGestureTypeOfProgress) {
            //获取当前时间
            CMTime currentTime = __blockVideoPlayer.currentItem.currentTime;
            double currentPlayTime = (double)currentTime.value/currentTime.timescale;
            
            NSInteger currentTemp = *__blockCurrentPlayingItem;
            
            while (currentTemp > 0) {
                currentPlayTime += [(NSNumber *)__blockItemTimeList[currentTemp-1] doubleValue];
                --currentTemp;
            }
            
            if(*__blockVideoLength != 0){
                [__blockSliderView resetSliderWithRatio:currentPlayTime/(*__blockVideoLength)];
            }
            
            CGFloat remainingTime = (*__blockVideoLength) - currentPlayTime;
            NSDate *totalDate = [NSDate dateWithTimeIntervalSince1970:(*__blockVideoLength)];
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
            NSDate *remainingDate = [NSDate dateWithTimeIntervalSince1970:remainingTime];
            NSDateFormatter *formatter = [__blockSelf creatDateFormatter];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            //总时间
            [formatter setDateFormat:((*__blockVideoLength)/3600 >= 1)? @"h:mm:ss":@"mm:ss"];
            NSString *totalTimeString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:totalDate]];
            //当前时间
            [formatter setDateFormat:(currentPlayTime/3600 >= 1)? @"h:mm:ss":@"mm:ss"];
            NSString *currentTimeString = [formatter stringFromDate:currentDate];
            //剩余时间
            [formatter setDateFormat:(remainingTime/3600 >= 1)? @"h:mm:ss":@"mm:ss"];
            __unused NSString *remainingTimeString = [NSString stringWithFormat:@"-%@",[formatter stringFromDate:remainingDate]];
            
            __blockTimeSliderLabel.text = TIMESLIDERLABEL_TEXT(currentTimeString, totalTimeString);
            if(VideoPlayerViewStyleValue1 == *__blockVideoPlayerViewStyle){
                __blockCurrentTimeSliderLabel.text = currentTimeString;
                __blockTimeSliderLabel.text = totalTimeString;
            }
        }
    }];
}

- (void)creatTopView{
    if(!_topView){
        _topView = [[UIView alloc] init];
    }
}

- (void)creatBottomView{
    [self creatTopView];
    if(self.bottomView){
        [self resetPlayButton:BTN_PALY_TAG];
        return;
    }
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(videoPlayerBottomOverLayerView:)]) {
        self.bottomView = [self.dataSource videoPlayerBottomOverLayerView:self];
        if(self.bottomView) {
            self.bottomView.center = CGPointMake(self.bottomView.center.x, CGRectGetHeight(self.bottomView.frame)/2);
            self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            [self addSubview:self.bottomView];
        }
        return;
    }
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/* - _bottomViewHeight*/, CGRectGetWidth(self.frame), _bottomViewHeight)];
    _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:_bottomView];
    // top
    UIImage *playBtnImage = [UIImage imageNamed:@"player_play.png"];
    UIImage *pauseBtnImage = [UIImage imageNamed:@"player_pause.png"];
    UIImage *fullscreenBtnImage = [UIImage imageNamed:@"player_fullscreen.png"];
    UIImage *fullscreenBtnImage_high = nil;
    if(VideoPlayerViewStyleValue1 == _videoPlayerViewStyle){
        playBtnImage = [UIImage imageNamed:@"discover_play"];
        pauseBtnImage = [UIImage imageNamed:@"discover_play"];
        fullscreenBtnImage = [UIImage imageNamed:@"player_value1_fullscreen_normal.png"];
        fullscreenBtnImage_high = [UIImage imageNamed:@"player_value1_fullscreen_high.png"];
    }
    
    CGFloat padding = 10;
    CGFloat buttonHeight = (pauseBtnImage.size.height > 50)?50:pauseBtnImage.size.height;
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, (CGRectGetHeight(_bottomView.frame) - buttonHeight)/2, buttonHeight*(pauseBtnImage.size.width/pauseBtnImage.size.height), buttonHeight)];
    _playButton.enabled = NO;
    _playButton.alpha = 0;
    //_playButton.tag = BTN_PALY_TAG;
    _playButton.backgroundColor = [UIColor clearColor];
    _playButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    //[_playButton setImage:pauseBtnImage forState:UIControlStateNormal];
    //[_playButton setImage:playBtnImage forState:UIControlStateSelected];
    [_playButton setExclusiveTouch:YES];
    [self resetPlayButton:BTN_PALY_TAG];
    [_playButton addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(VideoPlayerViewStyleValue1 == _videoPlayerViewStyle){
        _playButton.center = CGPointMake(self.bounds.size.width/2, (self.bounds.size.height)/2);
        [self addSubview:_playButton];
    }
    else {
        [_bottomView addSubview:_playButton];
    }
    
    _fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_bottomView.frame) - padding/2 - buttonHeight, (CGRectGetHeight(_bottomView.frame) - buttonHeight)/2, buttonHeight*(fullscreenBtnImage.size.width/fullscreenBtnImage.size.height), buttonHeight)];
    _fullScreenButton.backgroundColor = [UIColor clearColor];
    _fullScreenButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_fullScreenButton setExclusiveTouch:YES];
    [_fullScreenButton setImage:fullscreenBtnImage forState:UIControlStateNormal];
    if(fullscreenBtnImage_high){
        [_fullScreenButton setImage:fullscreenBtnImage_high forState:UIControlStateHighlighted];
    }
    [_fullScreenButton addTarget:self action:@selector(fullScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_fullScreenButton];
    
    __weak __typeof(self) __blockSelf = self;
    
    _sliderView = [[ABValueSlider alloc] initWithSize:CGSizeMake(CGRectGetWidth(_bottomView.bounds) - padding*4 - buttonHeight*2, 1) currentValue:0 withPlusBtn:NO];
    _sliderView.center = CGPointMake(CGRectGetWidth(_bottomView.frame)/2, CGRectGetHeight(_bottomView.frame)/2);
    _sliderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_sliderView setSliderViewEnabled:NO];
    [_sliderView resetCaptureFocus:^(double slideRatio, SliderTouchType touchType) {
        switch (touchType) {
            case SliderTouchTypeBegin:{
                __blockSelf.touchGestureType = TouchGestureTypeOfProgress;
                __blockSelf.sliderBeginValue = slideRatio;
                
                break;
            }
            case SliderTouchTypeEnd:{
                __blockSelf.touchGestureType = TouchGestureTypeOfNone;
                
            }
            case SliderTouchTypeMoved:{
                [__blockSelf updateTimeSliderLable:slideRatio];
                
                break;
            }
            default:
                break;
        }
    }];
    [_bottomView addSubview:_sliderView];
    
    UIFont *labelFont = [UIFont systemFontOfSize:12];
    _timeSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_sliderView.frame), labelFont.lineHeight)];
    _timeSliderLabel.center = CGPointMake(CGRectGetWidth(_bottomView.frame)/2, CGRectGetHeight(_bottomView.frame)/2 + CGRectGetHeight(_sliderView.frame));
    _timeSliderLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _timeSliderLabel.backgroundColor = [UIColor clearColor];
    _timeSliderLabel.textAlignment = NSTextAlignmentRight;
    _timeSliderLabel.textColor = [UIColor whiteColor];
    _timeSliderLabel.text = TIMESLIDERLABEL_TEXT(@"00:00", @"00:00");
    _timeSliderLabel.font = labelFont;
    [_bottomView addSubview:_timeSliderLabel];
    
    _currentTimeSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_sliderView.frame), labelFont.lineHeight)];
    _currentTimeSliderLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    _currentTimeSliderLabel.backgroundColor = [UIColor clearColor];
    _currentTimeSliderLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeSliderLabel.textColor = [UIColor whiteColor];
    _currentTimeSliderLabel.text = @"00:00";
    _currentTimeSliderLabel.font = labelFont;
    
    CGFloat timeLabelWidth = [@"00:00:00" sizeWithFont:labelFont constrainedToSize:CGSizeMake(MAXFLOAT, labelFont.lineHeight) lineBreakMode:NSLineBreakByCharWrapping].width;
    if(VideoPlayerViewStyleValue1 == _videoPlayerViewStyle){
        _currentTimeSliderLabel.frame = CGRectMake(padding, (CGRectGetHeight(_bottomView.frame) - labelFont.lineHeight)/2, timeLabelWidth, labelFont.lineHeight);
        [_bottomView addSubview:_currentTimeSliderLabel];
        
        _timeSliderLabel.frame = CGRectMake(CGRectGetMidX(_fullScreenButton.frame) - padding - timeLabelWidth, (CGRectGetHeight(_bottomView.frame) - labelFont.lineHeight)/2, timeLabelWidth, labelFont.lineHeight);
        _timeSliderLabel.textAlignment = NSTextAlignmentCenter;
        _timeSliderLabel.text = @"00:00";
        
        [_sliderView setSliderSize:CGSizeMake(CGRectGetMinX(_timeSliderLabel.frame) - CGRectGetMaxX(_currentTimeSliderLabel.frame) - padding*2, 1)];
        _sliderView.center = CGPointMake((CGRectGetMinX(_timeSliderLabel.frame) - CGRectGetMaxX(_currentTimeSliderLabel.frame))/2 + CGRectGetMaxX(_currentTimeSliderLabel.frame), CGRectGetHeight(_bottomView.frame)/2);
    }
}

- (void)updateTimeSliderLable:(double)slideRatio{
    /*add by zheng linqin 如果不是ready状态， [_videoPlayer seekToTime:会crash*/
    if (_videoPlayer.currentItem.status != AVPlayerItemStatusReadyToPlay) {
        return;
    }
    /*end*/
    if(_videoPlayerMode == VideoPlayerViewModeNetWork) {
        //[self showLoadingView:YES];
    }
    
    double currentTime = floor(_videoLength * slideRatio);
    
    int i = 0;
    double temp = [((NSNumber *)_itemTimeList[i]) doubleValue];
    while (currentTime > temp) {
        ++i;
        temp += [((NSNumber *)_itemTimeList[i]) doubleValue];
    }
    if (i != _currentPlayingItem) {
        [_videoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:(NSURL *)_videoList[i]]];
        //[_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        _currentPlayingItem = i;
    }
    temp -= [((NSNumber *)_itemTimeList[i]) doubleValue];
    
    //player控制播放进度需转换成CMTime
    __typeof(_isPlaying) *__blockIsPlaying = &_isPlaying;
    __weak __typeof(_videoPlayer) __blockVideoPlayer = _videoPlayer;
    CMTime dragedCMTime = CMTimeMake(currentTime - temp, 1);
    [_videoPlayer seekToTime:dragedCMTime
           completionHandler:^(BOOL finish) {
               if(*__blockIsPlaying == YES) {
                   [__blockVideoPlayer play];
               }
           }];
    
    double currentPlayTime = floor(_videoLength * slideRatio);
    double changeTime = floor(_videoLength * ABS(slideRatio - _sliderBeginValue));
    //转成秒数
    NSDate *totalDate = [NSDate dateWithTimeIntervalSince1970:_videoLength];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
    NSDate *changeDate = [NSDate dateWithTimeIntervalSince1970:changeTime];
    NSDateFormatter *formatter = [self creatDateFormatter];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    //总时间
    [formatter setDateFormat:(_videoLength/3600 >= 1)? @"h:mm:ss":@"mm:ss"];
    NSString *totalTimeString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:totalDate]];
    //当前时间
    [formatter setDateFormat:(currentPlayTime/3600>=1)? @"h:mm:ss":@"mm:ss"];
    NSString *currentTimeString = [formatter stringFromDate:currentDate];
    //改变时间
    [formatter setDateFormat:(changeTime/3600>=1)? @"h:mm:ss":@"mm:ss"];
    __unused NSString *changeTimeString = [formatter stringFromDate:changeDate];
    
    _timeSliderLabel.text = TIMESLIDERLABEL_TEXT(currentTimeString, totalTimeString);
    if(VideoPlayerViewStyleValue1 == _videoPlayerViewStyle){
        _currentTimeSliderLabel.text = currentTimeString;
        _timeSliderLabel.text = totalTimeString;
    }
}

- (void)refreshViewFrame{
    _playerLayer.frame = self.bounds;
    _playButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _loadingIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)resetPlayButton:(int)btnTag{
    _playButton.tag = btnTag;
    if(btnTag == BTN_PALY_TAG){
        [_playButton setImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"player_play.png"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
    else {
        [_playButton setImage:[UIImage imageNamed:@"player_reload_normal.png"] forState:UIControlStateNormal];
        //[_playButton setImage:[UIImage imageNamed:@"player_reload_high.png"] forState:UIControlStateHighlighted];
        [_playButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    }
}

- (void)resetFullScreenBtnImage:(BOOL)isFullScreen{
    if(VideoPlayerViewStyleValue1 == _videoPlayerViewStyle){
        UIImage *btnImage = nil;
        UIImage *btnImage_high = nil;
        if(isFullScreen){
            btnImage = [UIImage imageNamed:@"player_value1_desfullscreen_normal.png"];
            btnImage_high = [UIImage imageNamed:@"player_value1_desfullscreen_high.png"];
        }
        else {
            btnImage = [UIImage imageNamed:@"player_value1_fullscreen_normal.png"];
            btnImage_high = [UIImage imageNamed:@"player_value1_fullscreen_high.png"];
        }
        
        [_fullScreenButton setImage:btnImage forState:UIControlStateNormal];
        [_fullScreenButton setImage:btnImage_high forState:UIControlStateHighlighted];
    }
}

- (NSDateFormatter *)creatDateFormatter{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

- (void)storePlayerHistory{
    if(([self.videoList count] > 0) && _sliderView && (_currentPlayingItem < [self.videoList count]) && (_currentPlayingItem >= 0)){
        NSURL *videoUrl = self.videoList[_currentPlayingItem];
        if(videoUrl) {
            [[PlayRecordManager defaultPlayRecordManager] addPlayRecordWithIdentifier:[videoUrl absoluteString] progress:_sliderView.sliderValue];
        }
    }
}

#pragma mark - Selector
- (void)playBtnAction:(UIButton *)button{
    if(button.tag == BTN_RELOAD_TAG){
        [self reloadPlayer];
        
        return;
    }
    
    if(!_playerLayer) return;
    
    _isPlaying = !_isPlaying;
    if(_isPlaying) {
        [_videoPlayer play];
        _playButton.selected = NO;
    }
    else {
        [_videoPlayer pause];
        _playButton.selected = YES;
    }
}

- (void)fullScreenBtnAction:(UIButton *)button{
    [self resetViewSizeForOrientation:UIDeviceOrientationLandscapeLeft];
}

- (void)resetViewSizeForOrientation:(UIDeviceOrientation)orientation{
    _isFullscreen = !_isFullscreen;
    if(_isFullscreen){
        [self resetFullScreenBtnImage:YES];
        self.currentSuperView = self.superview;
        
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        [self.window addSubview:self];
        self.window.windowLevel = UIWindowLevelStatusBar;
        
        [UIView animateWithDuration:0.35 animations:^{
            self.frame = CGRectMake(0, 0, screenFrame.size.height, screenFrame.size.width);
            self.center = CGPointMake(screenFrame.size.width/2, screenFrame.size.height/2);
            if(orientation == UIDeviceOrientationLandscapeRight){
                self.transform = CGAffineTransformMakeRotation(-M_PI/2);
            }
            else {
                self.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
            
            [self refreshViewFrame];
        }];
    }
    else {
        [self resetFullScreenBtnImage:NO];
        self.window.windowLevel = UIWindowLevelNormal;
        if(self.currentSuperView){
            [self.currentSuperView addSubview:self];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI*2);
            self.frame = self.playerViewFrame;
            self.center = CGPointMake(self.playerViewFrame.origin.x + self.playerViewFrame.size.width/2, self.playerViewFrame.origin.y + self.playerViewFrame.size.height/2);
            
            [self refreshViewFrame];
        }];
    }
}

#pragma mark TouchEvent
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //[super touchesMoved:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (_touchGestureType == TouchGestureTypeOfNone && !CGRectContainsPoint(_bottomView.frame, point) && !CGRectContainsPoint(_topView.frame, point)) {
        //单击
        [self showOverlayer];
    }
    else if(_touchGestureType == TouchGestureTypeOfProgress){
        _touchGestureType = TouchGestureTypeOfNone;
    }
    else {
        _touchGestureType = TouchGestureTypeOfNone;
    }
}

- (void)autoHidenOverlayer{
    if(!_isAutoDismissPeriod){
        _isAutoDismissPeriod = YES;
        [self performSelector:@selector(hideOverlayerWithAnimation) withObject:nil afterDelay:2.0];
    }
}

- (void)showOverlayer{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect topFrame = self.topView.frame;
        CGRect bottomFrame = self.bottomView.frame;
        if(((self.topView && topFrame.origin.y < 0) ||
           (self.bottomView && bottomFrame.origin.y >= self.bounds.size.height))) {
            //NSLog(@"showOverlayer NO");
            self.isClickDismissed = NO;
            topFrame.origin.y = 0;
            bottomFrame.origin.y = self.bounds.size.height - self.bottomViewHeight;
            
            if(VideoPlayerViewStyleValue1 == self.videoPlayerViewStyle){
                self -> _playButton.alpha = 1;
            }
            
            [self autoHidenOverlayer];
        }
        //else {
        else if(!self.isLoadFailed){
            //隐藏
            //NSLog(@"showOverlayer YES");
            self.isClickDismissed = YES;
            topFrame.origin.y = -self.topViewHeight;
            bottomFrame.origin.y = self.bounds.size.height;
            
            if(VideoPlayerViewStyleValue1 == self.videoPlayerViewStyle){
                self -> _playButton.alpha = 0;
            }
        }
        
        self.topView.frame = topFrame;
        self.bottomView.frame = bottomFrame;
    } completion:^(BOOL finished) {
        if(self.isLoadFailed && self.isAutoDismissPeriod && self.isClickDismissed){
        //if(_isAutoDismissPeriod && _isClickDismissed){
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideOverlayerWithAnimation) object:nil];
            self.isAutoDismissPeriod = NO;
        }
    }];
}

- (void)hideOverlayerWithAnimation{
    [self hideOverlayer:YES];
}

- (void)hideOverlayer:(BOOL)isAnimation{
    if(_isAutoDismissPeriod && !_isLoadFailed){
        //if(_isAutoDismissPeriod){
        NSTimeInterval timeInterval = 0.35;
        if(!isAnimation){
            _playButton.alpha = 0;
        }
        
        [UIView animateWithDuration:timeInterval animations:^{
            if(VideoPlayerViewStyleValue1 == self.videoPlayerViewStyle){
                self -> _playButton.alpha = 0;
            }
            
            CGRect topFrame = self.topView.frame;
            CGRect bottomFrame = self.bottomView.frame;
            topFrame.origin.y = -self.topViewHeight;
            bottomFrame.origin.y = self.frame.size.height;
            self.topView.frame = topFrame;
            self.bottomView.frame = bottomFrame;
        } completion:^(BOOL finished) {
            self.isClickDismissed = YES;
        }];
    }
    
    _isAutoDismissPeriod = NO;
}

#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        [self showLoadingView:NO];
        
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        NSString *alertString = nil;
        
        switch (playerItem.status) {
            case AVPlayerItemStatusReadyToPlay:{
                //获取本地视频前次播放进度
                _isLoadFailed = NO;
                [_sliderView setSliderViewEnabled:YES];
                
                if (_isFirstOpen) {
                    _isFirstOpen = NO;
                    
                    NSURL *videoUrl = self.videoList[_currentPlayingItem];
                    if(videoUrl && ([self.videoList count] > 0) && (_currentPlayingItem < [self.videoList count])){
                        CGFloat progress = [[PlayRecordManager defaultPlayRecordManager] getProgressByIdentifier:[videoUrl absoluteString]];
                        [self updateTimeSliderLable:progress];
                        [_sliderView resetSliderWithRatio:progress];
                    }
                }
                
                break;
            }
            case AVPlayerItemStatusUnknown:{
                //视频加载异常
                alertString = @"未知错误";
                _isLoadFailed = YES;
                [self showOverlayer];
                [self destroyPlayer:NO];
                [self resetPlayButton:BTN_RELOAD_TAG];
                break;
            }
            case AVPlayerItemStatusFailed:{
                //视频加载失败
                alertString = @"加载失败";
                _isLoadFailed = YES;
                [self showOverlayer];
                [self destroyPlayer:NO];
                [self resetPlayButton:BTN_RELOAD_TAG];
                break;
            }
            default:
                break;
        }
        
        if(alertString){
            NSLog(@"player loading failed:%@",alertString);
        }
    }
}

- (void)playerItemFinished:(NSNotification *)notification{
    if(notification.name == AVPlayerItemNewAccessLogEntryNotification){
        
    }
    else if(notification.name == AVPlayerItemTimeJumpedNotification){
        
    }
    else if(notification.name == AVPlayerItemDidPlayToEndTimeNotification){
        NSURL *videoUrl = self.videoList[_currentPlayingItem];
        if(videoUrl) {
            [[PlayRecordManager defaultPlayRecordManager] removePlayRecordWithIdentifier:[videoUrl absoluteString]];
        }
        
        if((_currentPlayingItem + 1) == self.videoList.count) {
            [self destroyPlayer:NO];
            
            if(_playFinishBlock){
                _playFinishBlock();
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(videoPlayerFinished:)]){
                [self.delegate videoPlayerFinished];
            }
        }
        else {
            ++_currentPlayingItem;
            [_videoPlayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:self.videoList[_currentPlayingItem]]];
            if (_isPlaying == YES){
                [_videoPlayer play];
            }
            //[_videoPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)applicationBecomeActive:(NSNotification *)notifi{
    if(!_isFirstOpen){
        [self playBtnAction:nil];
    }
}

- (void)applicationResignActive:(NSNotification *)notifi{
    if(!_isFirstOpen){
        [self playBtnAction:nil];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notifi{
    if(!_autoSizeForDeviceOrientation || (self.hidden || (self.alpha == 0))){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        if(!_isFullscreen){
            [self resetViewSizeForOrientation:orientation];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = rotateTransformForOrientation(interfaceOrientation);
            }];
        }
    }
    
    if((UIInterfaceOrientationPortrait == orientation) && _isFullscreen){
        [self fullScreenBtnAction:nil];
    }
}

CGAffineTransform rotateTransformForOrientation(UIInterfaceOrientation orientation) {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    }
    else {
        return CGAffineTransformIdentity;
    }
}

#pragma mark - 
- (void)showLoadingView:(BOOL)show{
    if(!_loadingIndicatorView) {
        CGFloat viewWidth = 24.0;
        CGRect viewFrame = CGRectMake(self.bounds.size.width/2 - viewWidth/2, self.bounds.size.height/2 - viewWidth/2, viewWidth, viewWidth);
        _loadingIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:viewFrame];
        _loadingIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    
    __weak __typeof(self) __blockSelf = self;
    if(show) {
        [self hideOverlayer:NO];
        
        [self.loadingIndicatorView startAnimating];
        [self addSubview:self.loadingIndicatorView];
        self.loadingIndicatorView.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            __blockSelf.loadingIndicatorView.alpha = 1.0;
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            __blockSelf.loadingIndicatorView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [__blockSelf.loadingIndicatorView stopAnimating];
            [__blockSelf.loadingIndicatorView removeFromSuperview];
        }];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end

/**
 *  记录播放记录
 */
NSString *const PlayRecordArchiveKey_Identifier = @"recordIdentifier";
NSString *const PlayRecordArchiveKey_Progress = @"recordProgress";
NSString *const PlayRecordArchiveKey_Date = @"recordDate";

NSInteger const PlayRecordArchiveKey_MaxRecord = 30; //最多存放记录数,超过的会删除

@implementation PlayRecordManager

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (PlayRecordManager *)defaultPlayRecordManager{
    static PlayRecordManager *manager = nil;
    if (!manager) {
        manager = [[PlayRecordManager alloc] init];
    }
    return manager;
}

+ (NSString *)pathOfArchiveFile{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath lastObject];
    NSString *recordFilePath = [documentPath stringByAppendingPathComponent:@"playRecord.plist"];
    
    return recordFilePath;
}

- (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress{
    
    NSMutableArray *recardList = [[NSMutableArray alloc] initWithContentsOfFile:[PlayRecordManager pathOfArchiveFile]];
    if(!recardList) {
        recardList = [[NSMutableArray alloc] init];
    }
    
    if(recardList.count == PlayRecordArchiveKey_MaxRecord) {
        [recardList removeObjectAtIndex:0];
    }
    
    NSDictionary *recordDic = @{PlayRecordArchiveKey_Identifier:identifier,
                          PlayRecordArchiveKey_Date:[NSDate date],
                          PlayRecordArchiveKey_Progress:@(progress)};
    [recardList addObject:recordDic];
    
    __unused BOOL isSuccess = [recardList writeToFile:[PlayRecordManager pathOfArchiveFile] atomically:YES];
}

- (void)removePlayRecordWithIdentifier:(NSString *)identifier{
    NSMutableArray *recardList = [[NSMutableArray alloc] initWithContentsOfFile:[PlayRecordManager pathOfArchiveFile]];
    
    __block NSInteger index = -1;
    [recardList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        
        if([dic[PlayRecordArchiveKey_Identifier] isEqualToString:identifier]) {
            index = abs(idx);
            
            *stop = YES;
        }
    }];
    
    if((index > 0) && (index < [recardList count])){
        [recardList removeObjectAtIndex:index];
        [recardList writeToFile:[PlayRecordManager pathOfArchiveFile] atomically:YES];
    }
}

- (CGFloat)getProgressByIdentifier:(NSString *)identifier{
    NSMutableArray *recardList = [[NSMutableArray alloc] initWithContentsOfFile:[PlayRecordManager pathOfArchiveFile]];
    __block CGFloat progress = 0;
    [recardList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        if([dic[PlayRecordArchiveKey_Identifier] isEqualToString:identifier]) {
            progress = [dic[PlayRecordArchiveKey_Progress] floatValue];
            
            *stop = YES;
        }
    }];
    
    if(progress > 0.9 || progress < 0.05) {
        
        return 0;
    }
    return progress;
}

@end
