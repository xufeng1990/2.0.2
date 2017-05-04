//
//  YLYKUmoneyServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKUmoneyServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKUmoneyServiceModule

+ (void)getReward:(NSDictionary *)parameters
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@umoney/reward?%@",BASEURL_STRING,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

@end
