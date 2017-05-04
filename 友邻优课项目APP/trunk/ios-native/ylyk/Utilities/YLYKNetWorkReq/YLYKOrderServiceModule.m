//
//  YLYKOrderServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKOrderServiceModule.h"
#import "XXZQNetwork.h"
#import "OAuthAndErrorString.h"

@implementation YLYKOrderServiceModule

+ (void)createOrderWithParameters:(NSDictionary *)parameters
                          success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@order?%@",BASEURL_STRING,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

+ (void)getOrderById:(NSString *)orderId
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@order/%@/like?%@",BASEURL_STRING,orderId,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

@end
