//
//  YLYKImagePickerModule.m
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKImagePickerModule.h"
#import "YLYKImagePickerViewController.h"
#import "AppDelegate.h"

@implementation YLYKImagePickerModule

RCT_EXPORT_MODULE();

#pragma mark -选择图片类型 (相册 和 相机)

RCT_EXPORT_METHOD(selectImageFromAlbumOrCamera:(NSString *)selectType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    YLYKImagePickerViewController *imagePickerVC = [[YLYKImagePickerViewController alloc]init];
    imagePickerVC.selectType = selectType;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UINavigationController *nav1 = (UINavigationController *)window.rootViewController;
    [nav1 pushViewController:imagePickerVC animated:NO];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.imagePickerResolve = resolve;
    appDelegate.imagePickerReject = reject;

    if ([selectType isEqualToString:@"album"]) {//从相册选择
        NSLog(@"从相册选择");
        //resolve(@true);
    } else if ([selectType isEqualToString:@"camera"]) {//从相机拍照
        NSLog(@"从相机拍照");
    }else {
       // resolve(@false);
    }
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}


@end
