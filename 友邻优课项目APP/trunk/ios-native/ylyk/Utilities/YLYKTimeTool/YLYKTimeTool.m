//
//  YLYKTimeTool.m
//  YLYKPlayer
//
//  Created by 友邻优课 on 2017/1/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKTimeTool.h"

@implementation YLYKTimeTool

+ (NSString *)stringWithTime:(NSTimeInterval)time {
    
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}
@end
