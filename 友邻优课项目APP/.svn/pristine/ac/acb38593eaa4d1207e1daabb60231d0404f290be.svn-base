//
//  YLYKCourseServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKCourseServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"

@implementation YLYKCourseServiceModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getCourseList:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@course?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@course?%@&%@",BASEURL_STRING,string,dicturl];
    }
    
    NSString *key = [NSString stringWithFormat:@"%@course?%@",BASEURL_STRING,string];
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        [OAuthAndErrorString writeToFileWithKey:key andResponseObj:responseObject];
        //        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:key];
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)getCourseList:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@course?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@course?%@&%@",BASEURL_STRING,string,dicturl];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}



+ (void)getCourseById:(NSString *)courseId  success:(void (^)(id))success failure:(void (^)(NSError *))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(getCourseById:(NSString *)courseId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}


+ (void)likeCourse:(NSString *)courseId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@/like?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(likeCourse:(NSString *)courseId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@/like?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)unlikeCourse:(NSString *)courseId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@/like?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(unlikeCourse:(NSString *)courseId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@course/%@/like?%@",BASEURL_STRING,courseId,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}


@end
