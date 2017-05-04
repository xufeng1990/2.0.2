//
//  TraceModel.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TraceShowType) {
    TraceShowTypeCourse,
    TraceShowTypeNote
};

@interface YLYKTraceModel : NSObject

@property (nonatomic, assign) TraceShowType showType;
@property (nonatomic, assign) NSInteger listened_time;
@property (nonatomic, assign) NSInteger in_time;
@property (nonatomic, strong) NSDictionary *course;
@property (nonatomic, strong) NSMutableArray *noteImageArray;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *content;

@end
