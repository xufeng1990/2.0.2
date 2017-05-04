//
//  YLYKSigninServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKSigninServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"

@implementation YLYKSigninServiceModule
RCT_EXPORT_MODULE(); 

RCT_REMAP_METHOD(createSignin,
                 resolveBlock:(RCTPromiseResolveBlock)resolve
                 rejecteBlock:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@signin?%@",BASEURL_STRING,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}


RCT_EXPORT_METHOD(getSigninCalendar:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@signin?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@signin?%@&%@",BASEURL_STRING,string,dicturl];
    }
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark 打卡日历
+ (void)getSigninCalendar:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@signin?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@signin?%@&%@",BASEURL_STRING,string,dicturl];
    }
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

@end
