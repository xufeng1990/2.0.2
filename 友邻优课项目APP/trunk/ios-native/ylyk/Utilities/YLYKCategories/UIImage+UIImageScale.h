//
//  UIImage+UIImageScale.h
//  ylyk
//
//  Created by 许锋 on 2017/4/26.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)

- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage*)scaleToSize:(CGSize)size;

@end
