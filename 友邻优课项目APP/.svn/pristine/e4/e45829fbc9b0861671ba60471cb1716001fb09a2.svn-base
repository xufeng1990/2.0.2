//
//  YLYKVideoPlayerView.m
//  NativeTest
//
//  Created by 许锋 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKVideoPlayerView.h"
#import "AppDelegate.h"


@interface YLYKVideoPlayerView(){
    UIButton *playBtn;//播放按钮
}

@end

@implementation YLYKVideoPlayerView

#pragma mark -初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect frame = [UIScreen mainScreen].applicationFrame;
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _moviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:nil];
        _moviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
        [_moviePlayerController.view setFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        _moviePlayerController.initialPlaybackTime = -1;
        [self addSubview:_moviePlayerController.view];
        [self loadPlayBtn];

        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = YES;
        
        //注册手机屏幕旋转通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
        //注册视频播放点击完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(playBackDidFinsh:)
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _moviePlayerController = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_videoURLString]];
        _moviePlayerController.controlStyle = MPMovieControlStyleFullscreen;
        [_moviePlayerController.view setFrame:frame];
        _moviePlayerController.initialPlaybackTime = -1;
        [self addSubview:_moviePlayerController.view];
        [self loadPlayBtn];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = YES;

        //注册手机屏幕旋转通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        //注册视频播放点击完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playBackDidFinsh:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - setVideoRULString
/*
 *设置videoURLString的值  从RN传过来的
 */
- (void)setVideoURLString:(NSString *)videoUrlString{
    _videoURLString = videoUrlString;
    [self playVideo:_videoURLString];
}

/*
 * 初始视频播放视图
 */
+ (instancetype)videoPlayerViewWithFrame:(CGRect)frame delegate:(id<YLYKVideoPlayerViewDelegate>)delegate {
    frame = [UIScreen mainScreen].applicationFrame;
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 20);
    YLYKVideoPlayerView *videoPlayerView = [[self alloc] initWithFrame:frame];
    videoPlayerView.delegate = delegate;
    return videoPlayerView;
}

/*
 *加载播放按钮
 */
- (void)loadPlayBtn{
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setFrame:CGRectMake(0, 0, 100, 40)];
    playBtn.center = self.center;
    [playBtn setTitle:@"开始播放" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(beginPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
}

/*
 *点击播放按钮开始播放视频
 */
- (void)beginPlayVideo:(UIButton *)btn{
    [self playVideo:_videoURLString];
}

#pragma mark - 视频播放
/*
 *播放视频
 *@prama videoURL 视频播放地址 videoURLString
 */
- (void)playVideo:(NSString *)videoURL{
    [playBtn setHidden:YES];
    [_moviePlayerController setContentURL:[NSURL URLWithString:videoURL]];
    [_moviePlayerController play];
}


#pragma mark -MPMoviePlayerPlaybackDidFinishNotification 

/**  视频播放完成通知   **/
- (void)playBackDidFinsh:(NSNotification *)notification{
    if ([self.delegate respondsToSelector:@selector(videoPlayerViewPlayCompleted:)]) {
        [self.delegate videoPlayerViewPlayCompleted:self];
    }
}

/**  屏幕横竖屏切换通知   **/
- (void)changeRotate:(NSNotification*)notification {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 20);
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        [_moviePlayerController.view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + 20)];
    } else {
        //横屏
        [_moviePlayerController.view setFrame:CGRectMake(0, 0, frame.size.height + 20, frame.size.width)];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
