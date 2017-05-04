//
//  AlbumListModel.h
//  YLYK-App
//
//  Created by 友邻优课 on 2017/1/22.
//  Copyright © 2017年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYKAlbumListModel : NSObject

/*
 *课程ID
 */
@property (nonatomic,assign) NSInteger courseId;

/*
 *标题
 */
@property (nonatomic,copy) NSString * title;

/*
 *持续时间
 */
@property (nonatomic,copy) NSString * duration;

@end
