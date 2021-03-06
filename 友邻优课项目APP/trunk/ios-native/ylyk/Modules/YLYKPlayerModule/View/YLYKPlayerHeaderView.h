//
//  YLYKPlayerHeaderView.h
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYKCourseModel.h"

@interface YLYKPlayerHeaderView : UIView

@property (nonatomic,strong) YLYKCourseModel *courseModel;

/*
 *标题
 */
@property (nonatomic,strong) UILabel * titleLbl;

/*
 *介绍
 */
@property (nonatomic,strong) UILabel * introduceLbl;


/*
 *专辑
 */
@property (nonatomic,strong) UILabel * albumLbl;

/*
 *作者
 */
@property (nonatomic,strong) UILabel * authorLbl;

#pragma mark - Public Method

- (void)setItem:(YLYKCourseModel *)courseModel;

- (void)updateFrame;

@end
