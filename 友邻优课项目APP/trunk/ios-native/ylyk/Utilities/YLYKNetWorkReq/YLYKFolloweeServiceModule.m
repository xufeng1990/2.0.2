//
//  YLYKFolloweeServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKFolloweeServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKFolloweeServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark -获取指定用户的关注列表
RCT_EXPORT_METHOD(getFolloweeList:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@followee?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@followee?%@&%@",BASEURL_STRING,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark -关注指定用户
RCT_EXPORT_METHOD(createFollowee:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@followee?&%@",BASEURL_STRING,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark -取消关注指定的用户
RCT_EXPORT_METHOD(deleteFollowee:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@followee?&%@",BASEURL_STRING,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}
@end
