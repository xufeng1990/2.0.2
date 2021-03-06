//
//  YLYKOAuthModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKOAuthModule.h"
#import "YLYKPlayerManager.h"
#import "YLYKUserServiceModule.h"
#import <QYSDK.h>
#import "LogoutEvent.h"
#import "NSStringTools.h"

@implementation YLYKOAuthModule

RCT_EXPORT_MODULE();

#pragma mark -退出登录
RCT_EXPORT_METHOD(logout) {
    [[YLYKPlayerManager sharedPlayer] pause];
    // 注销则需要清除所有与用户相关的信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_id"];
    [defaults removeObjectForKey:@"xdy_id"];
    [defaults removeObjectForKey:@"userInfo"];
    [defaults removeObjectForKey:@"authorization"];
    [defaults removeObjectForKey:@"isVip"];
    [defaults removeObjectForKey:@"has_login"];
    [defaults removeObjectForKey:@"DownloadManager_downloadList"];
    [defaults synchronize];
    
    //注销七鱼
    [[QYSDK sharedSDK] logout:nil];
    // 将音频缓存清除
    [self clearDownloadedCache];
    [self clearCache];
    if (!USERID) {
        LogoutEvent *events = [[LogoutEvent alloc] init];
        [LogoutEvent application:[UIApplication sharedApplication] withLogout:@{@"LogoutSuccess":@true}];
        [events startObserving];
    } else {
        LogoutEvent *events = [[LogoutEvent alloc] init];
        [LogoutEvent application:[UIApplication sharedApplication] withLogout:@{@"LogoutSuccess":@false}];
        [events startObserving];
    }
}

RCT_REMAP_METHOD(getUserID, resolvedsa:(RCTPromiseResolveBlock)resolve rejecterds:(RCTPromiseRejectBlock)reject) {
    NSString *user_id = USERID;
    if (user_id) {
        resolve(user_id);
    } else {
        resolve(@"0");
    }
}

RCT_REMAP_METHOD(getUserInfo, resolve:(RCTPromiseResolveBlock)resolve rejecterds:(RCTPromiseRejectBlock)reject) {
    [YLYKUserServiceModule getUserById:USERID success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userInfo"];
        NSString * xdyId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"xdy_id"]];
        if ([dict objectForKey:@"vip"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isVip"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:xdyId forKey:@"xdy_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *user_info = [NSStringTools jsonToString:USER_INFO];
        resolve(user_info);
    } failure:^(NSError *error) {
        NSString *user_info = [NSStringTools jsonToString:USER_INFO];
        if (user_info) {
            resolve(user_info);
        } else {
            resolve(@"0");
        }
    }];
}

- (void)clearCache {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    //获取缓存沙盒路径
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * fileCachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSArray * subFilePath = [fileManger subpathsAtPath:fileCachePath];
    for (NSString * fileName in subFilePath) {
        if (![fileName containsString:@"Pandora"]) {
            //拼接文件全路径（注意：是文件）
            NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
            [fileManger removeItemAtPath:filePath error:nil];
        }
    }
    // 清除音频缓存
    NSString *musicCache =  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *musicCachePath = [musicCache stringByAppendingPathComponent:@"MusicCaches"];
    NSArray *subMusicPath = [fileManger subpathsAtPath:musicCachePath];
    for (NSString *musicName in subMusicPath) {
        NSString *filePath = [musicCachePath stringByAppendingPathComponent:musicName];
        [fileManger removeItemAtPath:filePath error:nil];
    }
}

- (void)clearDownloadedCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *musicCache =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *musicCachePath = [musicCache stringByAppendingPathComponent:@"Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0"];
    NSArray *subMusicPath = [fileManager subpathsAtPath:musicCachePath];
    for (NSString *musicName in subMusicPath) {
        NSString *filePath = [musicCachePath stringByAppendingPathComponent:musicName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
