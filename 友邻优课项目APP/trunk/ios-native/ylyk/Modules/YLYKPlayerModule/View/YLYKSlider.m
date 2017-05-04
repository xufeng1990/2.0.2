//
//  YLYKSlider.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/4.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKSlider.h"

@implementation YLYKSlider



- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame), 3);
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.5);
}
- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.5);
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//    //y轴方向改变手势范围
//    rect.origin.y = rect.origin.y - 10;
//    rect.size.height = rect.size.height + 10;
//    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 20 ,20);
//}
@end
