//
//  YLYKTokenServiceModule.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface YLYKTokenServiceModule : NSObject <RCTBridgeModule>
+ (void)getTokenFromWechat:(NSString *)code  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure;
+ (void)getTokenByMobilephone:(NSString *)mobilephone success:(void (^)(id))success
                      failure:(void (^)(NSError *))faliure;
+ (void)getTokenByMobilephoneWithCaptcha:(NSString *)mobilephone
                                 captcha:(NSString *)captcha
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))faliure;
@end
