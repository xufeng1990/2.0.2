//
//  YLYLScreenChangeNativeModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/26.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYLScreenChangeNativeModule.h"
#import "AppDelegate.h"
@implementation YLYLScreenChangeNativeModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(landscapAction) {
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = YES;
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

RCT_EXPORT_METHOD(portraitAction) {
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
