//
//  NSDateFormatter+shared.m
//  YLYKPlayer
//
//  Created by 友邻优课 on 2017/1/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "NSDateFormatter+shared.h"

@implementation NSDateFormatter (shared)

+ (instancetype)sharedDateFormatter {
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[self alloc]  init];
    });
    return _dateFormatter;
}

@end
