//
//  LoginViewController.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/6.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

/*
 *loginSuccess 代码块 回调 用户ID
 */
typedef void(^loginSuccess)(NSString *userId);

@interface LoginViewController : UIViewController <RCTBridgeModule>

/*
 *登陆成功回调
 */
@property (nonatomic, copy) loginSuccess loginSuccess;

/*
 *设置loginSuccess 代码块 值
 */
- (void)text:(loginSuccess)block;

@end
