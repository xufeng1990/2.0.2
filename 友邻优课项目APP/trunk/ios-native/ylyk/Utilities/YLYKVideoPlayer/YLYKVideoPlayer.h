//
//  YLYKVideoPlayer.h
//  NativeTest
//
//  Created by 许锋 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKVideoPlayerView.h"

#import <React/RCTComponent.h>
#import <React/UIView+React.h>

@interface YLYKVideoPlayer : YLYKVideoPlayerView

/*
 *开始播放事件
 */
@property (nonatomic, copy) RCTBubblingEventBlock onClickPlayBtn;

/*
 *播放完成事件
 */
@property (nonatomic, copy) RCTBubblingEventBlock onClickPlayCompleteBtn;


@end
