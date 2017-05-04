//
//  YLYKOrderServiceModule.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYKOrderServiceModule : NSObject
+ (void)createOrderWithParameters:(NSDictionary *)parameters
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))faliure;
+ (void)getOrderById:(NSString *)orderId
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))faliure;
@end
