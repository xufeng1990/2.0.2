//
//  YLYKPlayerViewController.h
//  YLYK-App
//
//  Created by 友邻优课 on 2017/1/18.
//  Copyright © 2017年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLYKPlayerViewController : UIViewController

@property (nonatomic, assign) NSInteger courseID;

@property (nonatomic,assign) BOOL isFromDownload;

@property (nonatomic,copy) NSString * titleText;

@property (nonatomic,copy) NSString * command;

@property (nonatomic,copy) NSString * authorization;

@property (nonatomic,assign) NSUInteger useID;

@property (nonatomic,assign) BOOL isVip;

@property (nonatomic,strong) NSMutableArray * downloadedArray;

- (void)pause;

- (void)play;

- (void)loadDataWithCourseId:(NSInteger)courseId;

@end
