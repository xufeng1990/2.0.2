//
//  YLYKNoteTraceCell.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKBaseTraceCell.h"
#import "YLYKTraceModel.h"

@interface YLYKNoteTraceCell : YLYKBaseTraceCell

@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;

- (void)setTraceModel:(YLYKTraceModel *)traceModel;

@end
