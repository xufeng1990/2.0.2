//
//  YLYKTeacherServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKTeacherServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKTeacherServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark  -获取指定教师的信息
RCT_EXPORT_METHOD(getTeacherById:(NSString *)teacherId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@teacher/%@?%@",BASEURL_STRING,teacherId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(getTeacherList:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString = nil;
    if (string==nil) {
        urlString =  [NSString stringWithFormat:@"%@teacher?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@teacher?%@&%@",BASEURL_STRING,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}
@end
