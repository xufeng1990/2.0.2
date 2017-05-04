//
//  YLYKVideoPlayerView.h
//  NativeTest
//
//  Created by 许锋 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class YLYKVideoPlayerView;
@protocol YLYKVideoPlayerViewDelegate <NSObject>

@optional

/*
 *视频播放完成
 */
- (void)videoPlayerViewPlayCompleted:(YLYKVideoPlayerView *)videoPlayerView;

@end


@interface YLYKVideoPlayerView : UIView

@property (nonatomic, weak) id<YLYKVideoPlayerViewDelegate> delegate;

/*
 *视频播放控制器
 */
@property(nonatomic,strong)MPMoviePlayerController *moviePlayerController;


/*
 *视频播放地址 URLString
 */
@property(nonatomic,strong)NSString *videoURLString;


/*
 * 初始视频播放视图
 */
+ (instancetype)videoPlayerViewWithFrame:(CGRect)frame delegate:(id<YLYKVideoPlayerViewDelegate>)delegate;

#pragma mark - 视频播放
/*
 *播放视频
 *@prama videoURL 视频播放地址 videoURLString
 */

- (void)playVideo:(NSString *)videoURL;

@end
