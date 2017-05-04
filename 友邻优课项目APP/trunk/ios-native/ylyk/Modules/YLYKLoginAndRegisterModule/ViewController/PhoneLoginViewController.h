//
//  PhoneLoginViewController.h
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

@interface PhoneLoginViewController : UIViewController

/*
 *标题
 */
@property (nonatomic , copy) NSString *title;

/*
 *约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highLayout;

/*
 *标签
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, copy) loginSuccess loginSuccess;

@end
