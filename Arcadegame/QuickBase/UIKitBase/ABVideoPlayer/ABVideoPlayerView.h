//
//  ABVideoPlayerView.h
//  AvPlayerDemo
//
//  Created by Abner on 14/10/17.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@protocol ABVideoPlayerViewDataSource;
@protocol ABVideoPlayerViewDelegate;

/**
 *  关联类
 *  AVFoundation.h
 *  ABValueSlider.h
 */

typedef NS_ENUM(NSInteger, VideoPlayerViewStyle){
    VideoPlayerViewStyleNormal, //播放器默认样式
    VideoPlayerViewStyleValue1, //播放器样式一
    VideoPlayerViewStyleValue2  //播放器样式二
};
/**
 *  注销PlayerView的时候,记得调用removeFromSuperview
 */
@interface ABVideoPlayerView : UIView

@property(nonatomic, assign) id<ABVideoPlayerViewDataSource> dataSource;
@property(nonatomic, assign) id<ABVideoPlayerViewDelegate> delegate;
//topView高度,默认44px
@property(nonatomic, assign) CGFloat topViewHeight;
//bottomView高度,默认44px
@property(nonatomic, assign) CGFloat bottomViewHeight;
//根据设备方向自动调整View,默认是YES
@property(nonatomic, assign) BOOL autoSizeForDeviceOrientation;
//播放器样式,默认为VideoPlayerViewStyleNormal
@property(nonatomic, assign) VideoPlayerViewStyle videoPlayerViewStyle;

//实例化时可以直接用initWithFrame
//播放网络视频
- (id)initWithFrame:(CGRect)frame withVideoUrl:(NSURL *)url;
//播放本地视频
- (id)initWithFrame:(CGRect)frame withLocalVideoPath:(NSString *)videoPath;
//自动连续播放本地视频片段(array类容为NSUrl)
- (id)initWithFrame:(CGRect)frame withLocalVideoList:(NSArray *)videoList;
//设置视频数据(可以是NSURL,videoPath,videoList这三种)
- (void)setVideoData:(id)videoData;
//开始播放
- (void)startPlayer;
//暂停
- (void)pausePlayer;
/*
 *  停止播放(注意区分暂停和停止播放的状态,取消播放的时候应该主动调用stop方法,
 *  如果已经使用了removeFromSuperview方法,则无需再次调用stop方法)
 */
- (void)stopPlayer;
//播放结束回调BLOCK,也可使用delegate
- (void)videoPlayerFinished:(void(^)(void))finished;

@end

@protocol ABVideoPlayerViewDataSource <NSObject>

@optional
/*
 *  自定义样式
 *  如果需要自定义TopView与BottomView就实现这个方法
 *  注意:自定义BottomView会覆盖掉原有的播放控制按钮
 *  注意内存管理
 */
- (UIView *)videoPlayerTopOverLayerView:(UIView *)playerView;
- (UIView *)videoPlayerBottomOverLayerView:(UIView *)playerView;

@end

@protocol ABVideoPlayerViewDelegate <NSObject>
@optional
/*
 *  播放结束
 */
- (void)videoPlayerFinished;

@end

/**
 *  记录播放记录
 *  identifier:视频URL
 */
@interface PlayRecordManager : NSObject
+ (PlayRecordManager *)defaultPlayRecordManager;
- (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress;
- (void)removePlayRecordWithIdentifier:(NSString *)identifier;
- (CGFloat)getProgressByIdentifier:(NSString *)identifier;
@end

