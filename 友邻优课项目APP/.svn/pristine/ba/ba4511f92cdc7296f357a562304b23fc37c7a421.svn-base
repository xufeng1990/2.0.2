//
//  YLYKBaseTraceCell.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYKTraceModel.h"

#pragma mark - ImageDelegate
@protocol ImageDelegate <NSObject>

-(void)change:(NSString*)courseId;

@end

#pragma mark - ImageDelegate
@protocol CourseDelegate <NSObject>

-(void)open:(NSString*)courseId;

@end

@interface YLYKBaseTraceCell : UITableViewCell

- (void)setTraceModel:(YLYKTraceModel *)traceModel;

@property (weak, nonatomic) id<CourseDelegate>courseDelegate;
@property (weak, nonatomic) id<ImageDelegate>myDelegate;

@end
