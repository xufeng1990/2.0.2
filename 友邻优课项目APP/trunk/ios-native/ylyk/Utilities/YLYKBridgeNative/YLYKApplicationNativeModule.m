//
//  YLYKApplicationNativeModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKApplicationNativeModule.h"
#import "YLYKServiceModule.h"
#import "NSStringTools.h"
#include <sys/param.h>
#include <sys/mount.h>

@implementation YLYKApplicationNativeModule

RCT_EXPORT_MODULE();
#pragma mark -获取版本号 2.0.0
RCT_REMAP_METHOD(getVersion, resolved:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    resolve([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
}

#pragma mark -获取build号 1702101
RCT_REMAP_METHOD(getBuild, re:(RCTPromiseResolveBlock)resolve jecter:(RCTPromiseRejectBlock)reject) {
    resolve([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
}

#pragma mark -是否review
RCT_REMAP_METHOD(getReviewVersion, reso:(RCTPromiseResolveBlock)resolve jecter:(RCTPromiseRejectBlock)reject) {
    NSString *reviewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"review_version_code"];
    NSString *CurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (!reviewVersion) {
        resolve(@{@"isReview":@false});
        [YLYKServiceModule getSystemVersionsuccess:^(id responseObject) {
            NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:responseObject];
            NSDictionary *client = [dict objectForKey:@"client"];
            NSDictionary *iosClient = [client objectForKey:@"ios"];
            NSString *reviewVersionCode = [[iosClient objectForKey:@"review"] objectForKey:@"version_code"];
            [[NSUserDefaults standardUserDefaults] setObject:reviewVersionCode forKey:@"review_version_code"];
        } failure:^(NSError *error) {
        }];
    } else {
        if ([reviewVersion integerValue] <= [CurrentVersion integerValue]) {
            resolve(@{@"isReview":@true});
        } else {
            resolve(@{@"isReview":@false});
        }
    }
}

#pragma mark -查询手机剩余空间
RCT_REMAP_METHOD(freeDiskSpaceInBytes, resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    NSString *disk = [NSString stringWithFormat:@"%qi" ,freespace/1024/1024];
    resolve(disk);
}
#pragma mark -查询手机总空间大小
RCT_REMAP_METHOD(getTotalDiskSize, resolved:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    
    NSString *disk = [NSString stringWithFormat:@"%qi" ,freeSpace/1024/1024];
    resolve(disk);
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}
@end
