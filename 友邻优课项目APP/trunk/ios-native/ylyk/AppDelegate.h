//
//  AppDelegate.h
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import "YLYKPlayerViewController.h"

typedef void(^PaymentState)(NSDictionary *state);
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UINavigationController * nav;
@property (nonatomic,copy) PaymentState paymentStateBlock;
@property (nonatomic,assign) BOOL allowRotation;

@property (nonatomic,copy)RCTPromiseResolveBlock imagePickerResolve;
@property (nonatomic,copy)RCTPromiseRejectBlock  imagePickerReject;

@end

