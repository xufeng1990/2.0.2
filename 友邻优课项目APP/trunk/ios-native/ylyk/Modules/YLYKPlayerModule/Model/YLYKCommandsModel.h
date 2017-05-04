//
//  CommandsModel.h
//  YLYK-App
//
//  Created by 友邻优课 on 2017/1/19.
//  Copyright © 2017年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYKCommandsModel : NSObject

/*
 *认证信息
 */
@property (nonatomic,copy) NSString * authorization;

/*
 *评论
 */
@property (nonatomic,assign) NSString *  command;

/*
 *课程ID
 */
@property (nonatomic,assign) NSInteger  courseId;

/*
 *用户ID
 */
@property (nonatomic,assign) NSUInteger userId;

/*
 *是否VIP用户
 */
@property (nonatomic,assign) BOOL isVip;

@end
