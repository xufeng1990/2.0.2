//
//  SearchResultCell.h
//  ylyk
//
//  Created by 友邻优课 on 2017/3/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLYKSearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *teacherNmae;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *courseDuration;

@end
