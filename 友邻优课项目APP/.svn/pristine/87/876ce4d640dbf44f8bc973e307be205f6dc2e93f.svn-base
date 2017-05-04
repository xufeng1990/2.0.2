//
//  YLYKListenedAlbumNativeModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKListenedAlbumNativeModule.h"

@implementation YLYKListenedAlbumNativeModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_REMAP_METHOD(getListenAlbumList, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSDictionary *listenedAlbumList = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastListenedAlbumList"];
    NSArray *array = [listenedAlbumList allValues];
    resolve(array);
}

@end
