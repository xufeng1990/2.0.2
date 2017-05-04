//
//  YLYKUserServiceModule.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface YLYKUserServiceModule : NSObject <RCTBridgeModule>

+ (void)getUserById:(NSString *)userId
            success:(void (^)(id))success
            failure:(void (^)(NSError *))faliure;

+ (void)getUserTraceById:(NSString *)userId
              parameters:(NSDictionary *)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))faliure;

+ (void)updateUserMobilephoneWithCaptcha:(NSString *)userId
                                        :(NSDictionary *)parameters
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))faliure;

+ (void)updateUserMobilephone:(NSString *)userId
                             :(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))faliure;

+ (void)getuseInfo:(NSString *)openid
       accessToken:(NSString *)accessToken
           unionId:(NSString *)unionId
           success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))faliure;
@end
