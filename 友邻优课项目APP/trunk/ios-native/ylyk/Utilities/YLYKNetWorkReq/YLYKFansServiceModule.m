//
//  YLYKFansServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKFansServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKFansServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark -获取指定用户的粉丝列表
RCT_EXPORT_METHOD(getFansList:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@fans?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@fans?%@&%@",BASEURL_STRING,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

@end
