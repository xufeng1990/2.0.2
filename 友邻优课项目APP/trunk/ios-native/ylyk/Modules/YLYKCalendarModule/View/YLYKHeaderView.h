//
//  HeaderView.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLYKHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLearnTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLearnTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *continuityDays;
@property (weak, nonatomic) IBOutlet UIView *learnTimeView;
@property (weak, nonatomic) IBOutlet UIView *continuityView;

@end
