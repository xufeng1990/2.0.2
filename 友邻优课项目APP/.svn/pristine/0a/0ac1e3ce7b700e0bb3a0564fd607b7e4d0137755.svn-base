//
//  YLYKAlbumServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKAlbumServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
@implementation YLYKAlbumServiceModule
RCT_EXPORT_MODULE(); 
#pragma mark - 获取专辑列表（）
RCT_EXPORT_METHOD(getAlbumList:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString =  [NSString stringWithFormat:@"%@album?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@album?%@&%@",BASEURL_STRING,string,dicturl];
    }
    
    NSString *key = [NSString stringWithFormat:@"%@album?%@",BASEURL_STRING,string];
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        
        [OAuthAndErrorString writeToFileWithKey:key andResponseObj:responseObject];
        
        //          [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:key];
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}


+ (void)getAlbumById:(NSString *)albumId success:(void (^)(id))success failure:(void (^)(NSError *))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@album/%@?%@",BASEURL_STRING,albumId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
    
}

RCT_EXPORT_METHOD(getAlbumById:(NSString *)albumId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@album/%@?%@",BASEURL_STRING,albumId,dicturl];
    
    NSString *key = [NSString stringWithFormat:@"%@album/%@",BASEURL_STRING,albumId];
    
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        [OAuthAndErrorString writeToFileWithKey:key andResponseObj:responseObject];
        //    [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:key];
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(likeAlbum:(NSString *)albumId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@album/%@/like?%@",BASEURL_STRING,albumId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}


RCT_EXPORT_METHOD(getAlbumCommentList:(NSString *)albumId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@album/%@/comment?%@",BASEURL_STRING,albumId,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@album/%@/comment?%@&%@",BASEURL_STRING,albumId,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(createAlbumComment:(NSString *)albumId :(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@album/%@/comment?%@",BASEURL_STRING,albumId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:parameters authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}
@end
