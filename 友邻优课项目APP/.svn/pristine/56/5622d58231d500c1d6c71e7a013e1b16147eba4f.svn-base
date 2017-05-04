//
//  YLYKVideoPlayerManager.m
//  NativeTest
//
//  Created by 许锋 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKVideoPlayerManager.h"
#import "YLYKVideoPlayer.h"

#import <React/RCTBridge.h>//进行通信的头文件
#import <React/RCTEventDispatcher.h>//事件派发，不导入会引起Xcode警告
//#import "RCTBridge.h"           //进行通信的头文件
//#import "RCTEventDispatcher.h"  //事件派发，不导入会引起Xcode警告

@interface YLYKVideoPlayerManager() <YLYKVideoPlayerViewDelegate>

@end

@implementation YLYKVideoPlayerManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(videoURLString,NSString);

RCT_EXPORT_VIEW_PROPERTY(onClickPlayBtn, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onClickPlayCompleteBtn, RCTBubblingEventBlock);


- (UIView *)view {
    YLYKVideoPlayer *videoPlayer = [YLYKVideoPlayer videoPlayerViewWithFrame:CGRectZero delegate:self];
    return videoPlayer;
}

#pragma mark - YLYKVideoPlayerViewDelegate

- (void)videoPlayerViewPlayCompleted:(YLYKVideoPlayer *)videoPlayer {
    if (!videoPlayer.onClickPlayCompleteBtn) {
        return;
    }
    videoPlayer.onClickPlayCompleteBtn(@{@"target": videoPlayer.reactTag,
                                         @"value": [NSNumber numberWithInteger:1]});
}

@end
