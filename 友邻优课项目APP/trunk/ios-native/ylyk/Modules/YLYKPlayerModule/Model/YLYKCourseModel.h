//
//  AppDelegate.m
//  YLYKPlayer
//
//  Created by 友邻优课 on 2017/1/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    YLYKCourseTypeLocal,
    YLYKCourseTypeRemote
}YLYKCourseType;

@interface YLYKCourseModel : NSObject

/*
 *courseID 课程ID
 */
@property (nonatomic,assign) NSInteger courseId;

/*
 *课程名称
 */
@property (nonatomic,copy) NSString * name;

/*
 *课程图片地址
 */
@property (nonatomic,copy) NSString * image;

/*
 *课程图片相集
 */
@property (nonatomic,copy) NSDictionary * album;

/*
 *老师数组
 */
@property (nonatomic,copy) NSArray * teachers;

/*
 *课程内容
 */
@property (nonatomic,copy) NSString * content;

/*
 *专辑名称
 */
@property (nonatomic,copy) NSString * media;

/*
 *专辑图片地址
 */
@property (nonatomic,copy) NSString * media_url;

/*
 *课程持续时长
 */
@property (nonatomic,assign) NSInteger duration;

/*
 *关注数量
 */
@property (nonatomic,assign) NSInteger  like_count;

/*
 *用户数量
 */
@property (nonatomic,assign) NSInteger  user_count;

/*
 *笔记数量
 */
@property (nonatomic,assign) NSInteger note_count;

/*
 *是否关注
 */
@property (nonatomic,assign) BOOL is_liked;

@property (nonatomic,assign) NSInteger in_time;


/*
 * 类型 
 *YLYKCourseTypeLocal 本地缓存课程
 *YLYKCourseTypeRemote
 */
@property (nonatomic,assign) YLYKCourseType type;

@end
