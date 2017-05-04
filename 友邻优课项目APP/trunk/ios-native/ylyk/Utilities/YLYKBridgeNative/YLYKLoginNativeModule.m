//
//  LoginBridge.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKLoginNativeModule.h"
#import "LoginViewController.h"
#import "PhoneLoginViewController.h"

@implementation YLYKLoginNativeModule 

RCT_EXPORT_MODULE();

#pragma mark -登录
RCT_REMAP_METHOD(openLoginViewController, resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
        LoginViewController *login = [[LoginViewController alloc] init];
        
        [nav presentViewController:login animated:YES completion:nil];
    });
}

#pragma mark -更改绑定手机
RCT_REMAP_METHOD(changeBandPhoneNumber, resolver:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
        PhoneLoginViewController *login = [[PhoneLoginViewController alloc] init];
        login.title = @" 绑定手机号";
        [nav pushViewController:login animated:YES];
    });
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
