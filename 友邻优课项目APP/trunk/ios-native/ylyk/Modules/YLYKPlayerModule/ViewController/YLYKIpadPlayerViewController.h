//
//  YLYKIpadPlayerViewController.h
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLYKIpadPlayerViewController : UIViewController

/*
 *课程ID  
 */
@property (nonatomic, assign) NSInteger courseID;

/*
 *是否来自下载
 */
@property (nonatomic,assign) BOOL isFromDownload;

/*
 *标题
 */
@property (nonatomic,copy) NSString * titleText;

/*
 *用户ID
 */
@property (nonatomic,assign) NSUInteger useID;
@property (nonatomic,copy) NSString * authorization;
/*
 *是否是VIP 会员
 */
@property (nonatomic,assign) BOOL isVip;

/*
 *已下载音频数组
 */
@property (nonatomic,strong) NSMutableArray * downloadedArray;

#pragma mark - public method

/*
 *暂停播放音频
 */
- (void)pause;

/*
 *开始播放音频
 */
- (void)play;

/*
 *加载音频数据
 *@prama courseId 课程ID
 */
- (void)loadDataWithCourseId:(NSInteger)courseId;

@end
