//
//  AGVideoPlayerViewController.m
//  Arcadegame
//
//  Created by Abner on 2023/10/01.
//

#import "AGVideoPlayerViewController.h"
#import "ABVideoPlayerView.h"

@interface AGVideoPlayerViewController ()

@property (strong, nonatomic) ABVideoPlayerView *player;

@end

@implementation AGVideoPlayerViewController

- (void)dealloc {
    [self.player removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [[ABVideoPlayerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.player];
    
    __WeakObject(self);
    [self.player videoPlayerFinished:^{
        __WeakStrongObject();
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [__strongObject.navigationController popViewControllerAnimated:YES];
        });
    }];
    
    //@"https://topic.setv.sh.cn/xiaoshennong/video/%E5%A4%8D%E8%B5%9B%E7%AC%AC%E4%B8%80%E5%9C%BA.mp4"
    [self.player setVideoData:[NSURL URLWithString:[NSString stringSafeChecking:self.videoURLStr]]];
    
    [self.mAGNavigateView bringToFront];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

@end
