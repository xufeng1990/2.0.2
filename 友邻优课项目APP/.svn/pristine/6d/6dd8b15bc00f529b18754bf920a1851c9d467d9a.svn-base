//
//  YLYKCourseServiceModule.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface YLYKCourseServiceModule : NSObject <RCTBridgeModule>
+ (void)unlikeCourse:(NSString *)courseId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure;
+ (void)likeCourse:(NSString *)courseId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure;
+ (void)getCourseById:(NSString *)courseId  success:(void (^)(id))success failure:(void (^)(NSError *))faliure;
+ (void)getCourseList:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))faliure;
@end
