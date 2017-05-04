//
//  NSDateFormatter+shared.h
//  YLYKPlayer
//
//  Created by 友邻优课 on 2017/1/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (shared)

/** 对于重大开销对象最好使用单例管理 */
+ (instancetype)sharedDateFormatter;

@end

