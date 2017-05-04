//
//  YLYKServiceModule.h
//  TestYlykProject
//
//  Created by 友邻优课 on 2016/12/30.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface YLYKServiceModule: NSObject <RCTBridgeModule>

+ (instancetype)sharedInstance;

- (void)postWithURLString:(NSString *)object
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))faliure;

- (void)getWithURLString:(NSString *)object
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))faliure;

- (void)put:(NSString *)object
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))faliure;

+ (NSString *)getSystemNetworkState;

+ (void)getSystemVersionsuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure;
@end
