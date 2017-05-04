//
//  YLYKCourseTraceCell.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKCourseTraceCell.h"
#import "UIImageView+WebCache.h"

@interface YLYKCourseTraceCell ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *opacityView;
@property (nonatomic, copy) NSString *courseId;
@end

@implementation YLYKCourseTraceCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"YLYKCourseTraceCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setTraceModel:(YLYKTraceModel *)traceModel {
    _timeLabel.text = [self dateWithDateString:traceModel.in_time];
    _learnTimeLabel.text = [self timeFormatted:traceModel.listened_time];
    self.layerView.layer.borderColor = [[UIColor colorWithRed:0.400 green:1.000 blue:1.000 alpha:1.000] CGColor];
    NSString *courseId = [NSString stringWithFormat:@"%@",[traceModel.course objectForKey:@"id"]];
    self.courseId = courseId;
    NSString *URLString = [NSString stringWithFormat:@"%@course/%@/cover",BASEURL_STRING, courseId];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPlayerController:)];
    _opacityView.userInteractionEnabled = YES;
    [_opacityView addGestureRecognizer:tap];
    [_courseImage sd_setImageWithURL:[NSURL URLWithString:URLString]];
    _teacherNameLabel.text = traceModel.teacherName;
    _courseNameLabel.text = [traceModel.course objectForKey:@"name"];
}

#pragma mark - 打开音频播放页
- (void)openPlayerController:(UITapGestureRecognizer *)tap {
    [self.courseDelegate open:self.courseId];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    NSInteger minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"学习%ld分钟",(long)minutes];
}

#pragma mark - 日期间隔转日期字符串
- (NSString *)dateWithDateString:(NSInteger)timeInteval {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger delta = [timeZone secondsFromGMT];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat =@"HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInteval+delta];
    NSString*timeStr = [matter stringFromDate:date];
    return timeStr;
}

@end
