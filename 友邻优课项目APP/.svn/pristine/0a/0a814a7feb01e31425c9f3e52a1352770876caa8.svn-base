//
//  YLYKPlayerNativeModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKPlayerNativeModule.h"
#import "YLYKPlayerManager.h"
#import "CourseViewController.h"
@implementation YLYKPlayerNativeModule
RCT_EXPORT_MODULE();
// 该记录每次应该只在启动app时调用一次，其他时间不应该调用
RCT_REMAP_METHOD(isExistPlayedTrace,playing:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    // 判断是否有上次播放的记录
    NSString *courseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPlayCourseId"];
    // 去接收是否正在播放的通知
    if (courseId) {
        resolve(@true);
    } else {
        resolve(@false);
    }
}

RCT_REMAP_METHOD(isPlayingOrPause,playing:(RCTPromiseResolveBlock)resolve refuse:(RCTPromiseRejectBlock)reject) {
    BOOL isPlaying = [[YLYKPlayerManager sharedPlayer] isPlaying];
    resolve(@{@"isPlayingOrPause":[NSString stringWithFormat:@"%d",isPlaying]});
}


RCT_EXPORT_METHOD(openPlayerController:(NSString *)courseId fromHomeOrDownload:(BOOL)state courseListArrayString:(NSString *)listArrString) {
    
    CourseViewController *courseVC = [[CourseViewController alloc] init];
    
    [courseVC openPlayerController:courseId fromHomeOrDownload:state courseListString:listArrString resolver:^(id result) {
        
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        
    }];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
