//
//  YLYKTokenServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKTokenServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"

@implementation YLYKTokenServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark -获取微信登录token
+ (void)getTokenFromWechat:(NSString *)code  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))faliure {
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHAT_APP_ID,WECHAT_APP_SECRECT,code];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}
RCT_EXPORT_METHOD(getTokenFromWechat:(NSString *)code resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHAT_APP_ID,WECHAT_APP_SECRECT,code];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:nil success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}
#pragma mark -获取手机登录验证码
+ (void)getTokenByMobilephone:(NSString *)mobilephone success:(void (^)(id))success
                      failure:(void (^)(NSError *))faliure {
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@token?%@",BASEURL_STRING,dicturl];
    NSDictionary * requestBody = [NSDictionary dictionaryWithObjectsAndKeys:@"398374a3b6bb1d1238a1e3dd1af6bcf2",@"app_key",mobilephone,@"mobilephone", nil];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:requestBody authorization:nil success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(getTokenByMobilephone:(NSString *)mobilephone resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@token?%@",BASEURL_STRING,dicturl];
    NSDictionary * requestBody = [NSDictionary dictionaryWithObjectsAndKeys:@"398374a3b6bb1d1238a1e3dd1af6bcf2",@"app_key",mobilephone,@"mobilephone", nil];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:requestBody authorization:nil success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

#pragma mark -手机验证码登录获取token
+ (void)getTokenByMobilephoneWithCaptcha:(NSString *)mobilephone
                                 captcha:(NSString *)captcha
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))faliure {
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@token?%@",BASEURL_STRING,dicturl];
    NSDictionary * requestBody = [NSDictionary dictionaryWithObjectsAndKeys:@"398374a3b6bb1d1238a1e3dd1af6bcf2",@"app_key",mobilephone,@"mobilephone",captcha,@"captcha", nil];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:requestBody authorization:nil success:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"has_login"];
        [OAuthAndErrorString getAuthorization];
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(getTokenByMobilephoneWithCaptcha:(NSString *)mobilephone captcha:(NSString *)captcha resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@token?%@",BASEURL_STRING,dicturl];
    NSDictionary * requestBody = [NSDictionary dictionaryWithObjectsAndKeys:@"398374a3b6bb1d1238a1e3dd1af6bcf2",@"app_key",mobilephone,@"mobilephone",captcha,@"captcha", nil];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:requestBody authorization:nil success:^(id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"has_login"];
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

@end
