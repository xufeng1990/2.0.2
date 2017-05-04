//
//  YLYKPlayerContentFooterView.m
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKPlayerContentFooterView.h"

@implementation YLYKPlayerContentFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
 *加载视图
 */
- (void)loadView {
    UIView *view = nil;
    CGFloat space = 110;
    CGRect frame = CGRectMake(18, 31, 13, 48);
    NSInteger tag = 170440;
    for (int i = 0; i < _titleArr.count; i++) {
        frame = CGRectMake(i * space -3, 31, 60, 48);
        view = [self getIconAndCharacterView:[_btnArr objectAtSafetyIndex:i] title:[_titleArr objectAtSafetyIndex:i] frame:frame tag:(tag + i)];
        [self addSubview:view];
    }
}

/*
 *刷新点赞
 */
- (void)refreshLinkCourse:(YLYKCourseModel *)courseModel {
    self.linkCourseLbl.text = [NSString stringWithFormat:@"赞(%ld)",(long)courseModel.like_count];
}

#pragma mark - 通过代码块获取回调方法
/*
 *通过代码块获取回调方法
 */

- (void)getFooterEventCallBack:(YLYKPlayerFooterEventBlock)footerEnventType {
    self.footerEnventType = footerEnventType;
}

#pragma mark - UITapGestureDelegate

- (void)tapView:(UITapGestureRecognizer *)sender {
    self.footerEnventType([[sender view] tag]);
}

#pragma mark - Get  Methods

/*
 *获取带图标和文字的视图
 *@prama btnImgStr 按钮图片名称
 *@prama title     标题描述文字
 *@prama frame     视图frame
 */
- (UIView *)getIconAndCharacterView:(NSString *)btnImgStr title:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect btnFrame = CGRectMake(-3, 0, 60, 24);
    [btn setFrame:btnFrame];
    [btn setImage:[UIImage imageNamed:btnImgStr] forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [view addSubview:btn];
    
    btnFrame.origin.x = 0;
    btnFrame.origin.y = btn.bottom + 15;
    btnFrame.size.width  = 60 ;
    btnFrame.size.height = 11 ;
    
    UILabel *label = [YLYKCreateBasicControlManager showLabInView:view
                                                             rect:btnFrame
                                                             text:title
                                                        textColor:KColor_9a9b9c textFont:FONT11
                                                     textAligment:NSTextAlignmentCenter
                                                    numberOfLines:1];
    if (tag == YLYKPlayerFooterEventPraise) {
        self.linkCourseLbl = label;
        self.linkCourseBtn = btn;
    } else if (tag == YLYKPlayerFooterEventFontSize) {
        self.fontSizeBtn = btn;
    } else if (tag == YLYKPlayerFooterEventExperience) {
        self.experienceLbl = label;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    view.tag = tag;
    [view addGestureRecognizer:tapGesture];
    return  view;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
