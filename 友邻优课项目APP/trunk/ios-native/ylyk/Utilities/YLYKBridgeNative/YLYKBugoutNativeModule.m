//
//  YLYKBugoutNativeModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/20.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKBugoutNativeModule.h"
#import "Bugout/Bugout.h"
@implementation YLYKBugoutNativeModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(openOrCloseBugoutFeedBack:(BOOL)state) {
//    [BugoutConfig defaultConfig].enabledShakeFeedback = state;
    BugoutConfig *config = [BugoutConfig defaultConfig];
//    if (USERID) {
//        [Bugout setUserData:USERID forKey:@"user_id"];
//    }
    config.enabledShakeFeedback = state;
    config.alertBtnCloseShakeFeedback = YES;
    [Bugout init:@"8f62460aa4a70ff2bb7f67b0b1a68707" channel:@"AppStore" config:config];
    NSString *stateStr = [NSString stringWithFormat:@"bugoutstate%d",state];
    [[NSUserDefaults standardUserDefaults] setObject:stateStr forKey:@"bugoutFeedBackState"];
}

RCT_REMAP_METHOD(bugoutFeedbackState, resolvedsa:(RCTPromiseResolveBlock)resolve rejecterds:(RCTPromiseRejectBlock)reject) {
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:@"bugoutFeedBackState"];
    if (state) {
        if ([state isEqualToString:@"bugoutstate1"]) {
            resolve(@YES);
        } else if ([state isEqualToString:@"bugoutstate0"]) {
            resolve(@NO);
        }
    } else {
        resolve(@YES);
    }
}

@end
