//
//  CourseViewController.h
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import "YLYKPlayerViewController.h"


typedef void (^RCTPromiseResolveBlock)(id result);
typedef void (^RCTPromiseRejectBlock)(NSString *code, NSString *message, NSError *error);

@interface CourseViewController : UIViewController <RCTBridgeModule> {
    RCTPromiseResolveBlock _resolveBlock;
    RCTPromiseRejectBlock _rejectBlock;
}

/*
 *打开音频播放页
 *@prama courseId  音频Id
 */
- (void)openPlayerController:(NSString *)courseId fromHomeOrDownload:(BOOL)state courseListString:(NSString *)listArrString resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

@end
