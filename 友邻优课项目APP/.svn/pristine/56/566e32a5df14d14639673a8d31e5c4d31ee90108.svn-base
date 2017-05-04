//
//  UIImage+FromColor.m
//  ylyk
//
//  Created by 许锋 on 2017/4/28.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "UIImage+FromColor.h"

@implementation UIImage (FromColor)


//根据颜色获取图片
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
