//
//  YLYKTraceModel.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKTraceModel.h"
#import "YLYKNoteTraceCell.h"
#import "YLYKCourseTraceCell.h"

@implementation YLYKTraceModel

- (NSString *)cellIdentifier {
    if (_showType == TraceShowTypeNote) {
        return NSStringFromClass([YLYKNoteTraceCell class]);
    } else {
        return NSStringFromClass([YLYKCourseTraceCell class]);
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"traceId": @"id"};
}

@end
