//
//  YLYKCreateBasicControlManager.m
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKCreateBasicControlManager.h"
#import "YLYKUserInterfaceConstant.h"

@implementation YLYKCreateBasicControlManager

/*
 *创建一个Button
 *@prama view           需要显示的父视图
 *@prama buttonType     Btn类型
 *@prama rect           frame
 *@prama title          显示标题
 *@prama tcolor         字体颜色
 *@prama font           字体大小
 *@prama tInset         标题字体位置
 *@prama imgName        btn显示图片
 *@prama iInset         btn图片位置
 *@prama tag            btn tag值
 *@prama target         target目标
 *@prama action         方法名
 *@prama color          背景颜色
 *@prama bgImg          背景图片
 */
+ (UIButton *)showInView:(UIView *)view buttonType:(UIButtonType)buttonType rect:(CGRect)rect title:(NSString *)title textColor:(UIColor *)tcolor textFont:(UIFont *)font titleEdgeInsets:(UIEdgeInsets)tInset imageName:(NSString *)imgName imageEdgeInsets:(UIEdgeInsets)iInset tag:(int)tag addTarget:(id)target action:(SEL)action bgColor:(UIColor *)color bgImageName:(id)bgImg {
    //bgImgName:  @[normal图，高亮图，selected图];
    if (!title)         title   = @"";
    if (!imgName)       imgName = @"";
    if (!tcolor)        tcolor  = [UIColor whiteColor];
    if (!color)         color   = [UIColor clearColor];
    if (!font)          font    = [UIFont systemFontOfSize:17.0];
    
    UIButton *btn = [UIButton buttonWithType:buttonType];
    btn.tag = tag;
    btn.frame = rect;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    UIImage *img = [UIImage imageNamed:imgName];
    
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:img forState:UIControlStateHighlighted];
    
    
    NSString *highLightedImgName = @"";
    NSString *selectedImgName    = @"";
    NSString *bgImgName          = @"";
    if (bgImg){
        if ([bgImg isKindOfClass:[NSString class]]) {
            bgImgName          = bgImg;
            highLightedImgName = bgImgName;
            selectedImgName    = bgImgName;
        }else if([bgImg isKindOfClass:[NSArray class]]){
            NSArray *imgArr = (NSArray *)bgImg;
            if (imgArr.count == 2) {
                bgImgName = [imgArr firstObject];
                highLightedImgName = [imgArr lastObject];
                selectedImgName = bgImgName;
            }else if(imgArr.count == 3){
                bgImgName = [imgArr firstObject];
                highLightedImgName = [imgArr objectAtIndex:1 isArray:NULL];
                selectedImgName = [imgArr lastObject];
            }
        }
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highLightedImgName] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    [btn setTitleColor:tcolor forState:UIControlStateHighlighted];
    
    btn.titleLabel.font = font;
    
    btn.titleEdgeInsets = tInset;
    btn.imageEdgeInsets = iInset;
    
    btn.backgroundColor = color;
    if (view) {
        [view addSubview:btn];
    }
    return btn;
}

/*
 *创建一个Label
 *@prama view           需要显示的父视图
 *@prama rect           frame
 *@prama text           显示内容
 *@prama color          字体颜色
 *@prama font           字体大小
 *@prama textAligment   居中位置
 *@prama numberOfLines  是否分行
 */
+ (UILabel *)showLabInView:(UIView *)view rect:(CGRect)rect text:(NSString *)text textColor:(UIColor *)color textFont:(UIFont *)font textAligment:(NSTextAlignment)textAligment numberOfLines:(NSInteger)numberOfLines {
    if (!text) text = @"";
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAligment;
    label.numberOfLines = numberOfLines;
    if (view) {
        [view addSubview:label];
    }
    return label;
}


@end
