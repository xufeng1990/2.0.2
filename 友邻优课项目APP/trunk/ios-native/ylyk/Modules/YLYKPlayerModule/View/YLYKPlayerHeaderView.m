//
//  YLYKPlayerHeaderView.m
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKPlayerHeaderView.h"

@implementation YLYKPlayerHeaderView

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    
    [self addSubview:self.titleLbl];
    [self addSubview:self.introduceLbl];
    //[self addSubview:self.albumLbl];
    //[self addSubview:self.authorLbl];
}

/*
 *界面填充数据
 */
- (void)setItem:(YLYKCourseModel *)courseModel {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 22);
    //标题
    self.titleLbl.frame = frame;
    self.titleLbl.text = courseModel.name;
    
    //介绍
    frame = CGRectMake(0, self.titleLbl.bottom + 14, self.frame.size.width, 13);
    self.introduceLbl.frame = frame;
    NSString *introduceStr = @"";
    NSDictionary *teacherInfoDic = [courseModel.teachers objectAtSafetyIndex:0];
    NSString *albumStr   = [courseModel.album objectForKey:@"name"];
    NSString *teacherStr = [teacherInfoDic objectForKey:@"name"];
    
    //拼接专辑名称和老师姓名
    if (albumStr != nil && ![albumStr isEqualToString:@""]) {
        introduceStr = [NSString stringWithFormat:@"#%@",albumStr];
        if (teacherStr != nil && ![teacherStr isEqualToString:@""]) {
            introduceStr = [NSString stringWithFormat:@"#%@    %@",albumStr,teacherStr];
        }
    } else {
        if (teacherStr != nil && ![teacherStr isEqualToString:@""]) {
            introduceStr = [NSString stringWithFormat:@"#%@",teacherStr];
        }
    }
    
    self.introduceLbl.text = introduceStr;
}

- (void)updateFrame {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 22);
    //标题
    self.titleLbl.frame = frame;
    //介绍
    frame = CGRectMake(0, self.titleLbl.bottom + 14, self.frame.size.width, 13);
    self.introduceLbl.frame = frame;
}

#pragma mark - Getter Methods

/*
 *标题
 */
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                            rect:CGRectZero
                                                            text:nil
                                                       textColor:KColor_5a5a5a
                                                        textFont:FONT22
                                                    textAligment:NSTextAlignmentCenter
                                                   numberOfLines:1];
        _titleLbl.backgroundColor = [UIColor whiteColor];
    }
    return _titleLbl;
}

/*
 *介绍
 */
- (UILabel *)introduceLbl{
    if (!_introduceLbl) {
        _introduceLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                                rect:CGRectZero
                                                                text:nil
                                                           textColor:KColor_9a9b9c
                                                            textFont:FONT13
                                                        textAligment:NSTextAlignmentCenter
                                                       numberOfLines:1];
        _introduceLbl.backgroundColor = [UIColor whiteColor];
    }
    return _introduceLbl;
}


/*
 *专辑
 */
- (UILabel *)albumLbl{
    if (!_albumLbl) {
        _albumLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                            rect:CGRectZero
                                                            text:nil
                                                       textColor:kBaseColor
                                                        textFont:kCellSmallFontSize
                                                    textAligment:NSTextAlignmentLeft
                                                   numberOfLines:1];
        _albumLbl.backgroundColor = [UIColor whiteColor];
    }
    return _albumLbl;
}

/*
 *作者
 */
- (UILabel *)authorLbl{
    if (!_authorLbl) {
        _authorLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                             rect:CGRectZero
                                                             text:nil
                                                        textColor:kBaseColor
                                                         textFont:kCellSmallFontSize
                                                     textAligment:NSTextAlignmentLeft
                                                    numberOfLines:1];
        _authorLbl.backgroundColor = [UIColor whiteColor];
    }
    return _authorLbl;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
