//
//  YLYKUserServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKUserServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKUserServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark +获取指定用户信息

#pragma mark + 从服务器取数据

+ (void)getuseInfo:(NSString *)openid accessToken:(NSString *)accessToken unionId:(NSString *)unionId success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@token?%@",BASEURL_STRING,dicturl];
    NSDictionary * requestBody = [NSDictionary dictionaryWithObjectsAndKeys:APP_KEY,@"app_key",unionId,@"union_id",openid,@"open_id",accessToken,@"access_token", nil];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:requestBody authorization:nil success:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"has_login"];
        [OAuthAndErrorString getAuthorization];
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

#pragma mark +获取用户推荐列表
RCT_EXPORT_METHOD(getUserHotList:(NSDictionary *)parameters
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@user?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@user?%@&%@",BASEURL_STRING,string,dicturl];
    }
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)getUserById:(NSString *)userId success:(void (^)(id))success
            failure:(void (^)(NSError *))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
    
}

RCT_EXPORT_METHOD(getUserById:(NSString *)userId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark +修改指定用户信息
RCT_EXPORT_METHOD(updateUser:(NSString *)userId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark +修改用户头像
RCT_EXPORT_METHOD(updateUserAvatar:(NSString *)userId image:(UIImage *)image resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] uploadImageWithURLString:urlString parameters:nil image:image authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError * error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}
#pragma mark +修改指定用户的绑定手机获得验证码
RCT_EXPORT_METHOD(updateUserMobilephone:(NSString *)userId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/mobilephone?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)updateUserMobilephone:(NSString *)userId :(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/mobilephone?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

#pragma mark +修改指定用户的绑定手机 传验证码
RCT_EXPORT_METHOD(updateUserMobilephoneWithCaptcha:(NSString *)userId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/mobilephone?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)updateUserMobilephoneWithCaptcha:(NSString *)userId :(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/mobilephone?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
        if ([[OAuthAndErrorString getErrorCodeWithError:error] isEqualToString:@"401"]) {
            [CBLProgressHUD showTextHUDInWindowWithText:@"验证码不正确或已过期"];
        }
    }];
}

#pragma mark +修改指定用户的代言人
RCT_EXPORT_METHOD(updateUserDealer:(NSString *)userId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/dealer?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] putWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark +获取指定用户的学习记录
RCT_EXPORT_METHOD(getUserTraceById:(NSString *)userId parameters:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/trace?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

+ (void)getUserTraceById:(NSString *)userId parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/trace?%@&%@",BASEURL_STRING,userId,string,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

#pragma mark +获取指定用户的任务
RCT_EXPORT_METHOD(getUserTaskById:(NSString *)userId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@user/%@/task?%@",BASEURL_STRING,userId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

@end
