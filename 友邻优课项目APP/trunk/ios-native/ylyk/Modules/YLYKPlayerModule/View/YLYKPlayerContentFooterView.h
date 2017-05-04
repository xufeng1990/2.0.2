//
//  YLYKPlayerContentFooterView.h
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYKCourseModel.h"

/*
 *底部视图控制事件
 */
typedef NS_ENUM(NSInteger, YLYKPlayerContentFooterEvent) {
    YLYKPlayerFooterEventPraise      = 170440,
    YLYKPlayerFooterEventFontSize    = 170441,
    YLYKPlayerFooterEventExperience  = 170442,
    YLYKPlayerFooterEventList        = 170443,
    YLYKPlayerFooterEventWriteExperience      = 170444,
};

typedef void(^YLYKPlayerFooterEventBlock)(YLYKPlayerContentFooterEvent footerEnventType);


@interface YLYKPlayerContentFooterView : UIView <UIGestureRecognizerDelegate>


/*
 *底部事件代码块
 */
@property(nonatomic,copy)YLYKPlayerFooterEventBlock footerEnventType;

/*
 *点赞label
 */
@property(nonatomic,strong)UILabel *linkCourseLbl;

/*
 *点赞btn
 */
@property(nonatomic,strong)UIButton *linkCourseBtn;

/*
 *字号btn
 */
@property(nonatomic,strong)UIButton *fontSizeBtn;

/*
 *心得Label
 */
@property(nonatomic,strong)UILabel *experienceLbl;


/*
 *视图  btn数据源
 */
@property (nonatomic,strong) NSArray * btnArr;

/*
 *视图 title数据源
 */
@property (nonatomic,strong) NSArray * titleArr;


#pragma mark - Public Method

- (void)loadView;

/*
 *刷新点赞
 */
- (void)refreshLinkCourse:(YLYKCourseModel *)courseModel;

/*
 *通过代码块获取回调方法
 */

- (void)getFooterEventCallBack:(YLYKPlayerFooterEventBlock)footerEnventType;


@end
