
//
//  YLYKServiceModule.m
//  TestYlykProject
//
//  Created by 友邻优课 on 2016/12/30.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "YLYKServiceModule.h"
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridge.h>
#import "XXZQNetwork.h"
#import "NSStringTools.h"
#import "CBLProgressHUD.h"
#import "AppDelegate.h"
#import "OAuthAndErrorString.h"

@interface YLYKServiceModule ()

@property (nonatomic, copy) NSDictionary * responseDict;
@property (nonatomic, copy) NSString * captcha;

@end

@implementation YLYKServiceModule
@synthesize bridge = _bridge;

static id _instance = nil;

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

//导出模块
RCT_EXPORT_MODULE();    //此处不添加参数即默认为这个OC类的名字

- (void)getWithURLString:(NSString *)object success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"query"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * urlString = nil;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@?%@&%@",BASEURL_STRING,path,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

#pragma mark -GET请求
RCT_EXPORT_METHOD(get:(NSString *)object resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"query"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * urlString = nil;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@?%@&%@",BASEURL_STRING,path,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

- (void)postWithURLString:(NSString *)object success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"body"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

#pragma mark -POST请求
RCT_EXPORT_METHOD(post:(NSString *)object  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"body"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark -DELETE请求
RCT_EXPORT_METHOD(delete:(NSString *)object resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"body"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError * error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark -PUT请求
RCT_EXPORT_METHOD(put:(NSString *)object resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"body"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError * error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

- (void)put:(NSString *)object success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:object];
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSDictionary * parameters = [dict objectForKey:@"body"];
    NSString * path = [OAuthAndErrorString getPathUrlWithObj:[dict objectForKey:@"url"]];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@%@?%@",BASEURL_STRING,path,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError * error) {
        faliure(error);
    }];
}

+ (void)getSystemVersionsuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * urlString = [NSString stringWithFormat:@"%@system/version",BASEURL_STRING];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}


//RCT_EXPORT_METHOD(getSystemNetworkState:(RCTResponseSenderBlock)callback) {
//    NSString * networkstate = [self getSystemNetworkState];
//    callback(@[[NSNull null], networkstate]);
//}



+ (NSString *)getSystemNetworkState {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"wifi";
    switch (type) {
            case 0:
            stateString = @"notReachable";
            break;
            
            case 1:
            stateString = @"2G";
            break;
            
            case 2:
            stateString = @"3G";
            break;
            
            case 3:
            stateString = @"4G";
            break;
            
            case 4:
            stateString = @"LTE";
            break;
            
            case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
    
    return stateString;
}



@end

