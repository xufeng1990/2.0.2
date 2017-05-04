//
//  YLYKNoteServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKNoteServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"


@implementation YLYKNoteServiceModule
RCT_EXPORT_MODULE();
+ (void)getNoteList:(NSDictionary *)parameters
            success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))faliure {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@note?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@note?%@&%@",BASEURL_STRING,string,dicturl];
    }
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        faliure(error);
    }];
}

RCT_EXPORT_METHOD(getNoteList:(NSDictionary *)parameters
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:parameters];
    NSString * string = [OAuthAndErrorString getParametersWithDictionary:parameters];
    NSString * urlString;
    if (string==nil) {
        urlString = [NSString stringWithFormat:@"%@note?%@",BASEURL_STRING,dicturl];
    } else {
        urlString = [NSString stringWithFormat:@"%@note?%@&%@",BASEURL_STRING,string,dicturl];
    }
    NSString *key = [NSString stringWithFormat:@"%@note?%@",BASEURL_STRING,string];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        [OAuthAndErrorString writeToFileWithKey:key andResponseObj:responseObject];
        resolve(responseObject);
    } failure:^(NSError *error) {
        
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(getNoteById:(NSString *)noteId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@note/%@?%@",BASEURL_STRING,noteId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

//TODO 创建新的笔记


RCT_EXPORT_METHOD(deleteNote:(NSString *)noteId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@note/%@?%@",BASEURL_STRING,noteId,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(likeNote:(NSString *)noteId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    //    NSString * string = [self getParametersWithDictionary:parameters];
    NSString * urlString = [NSString stringWithFormat:@"%@note/%@/like?%@",BASEURL_STRING,noteId,dicturl];
    [[XXZQNetwork sharedInstance] postWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

RCT_EXPORT_METHOD(unlikeNote:(NSString *)noteId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    
    NSString * urlString = [NSString stringWithFormat:@"%@note/%@/like?%@",BASEURL_STRING,noteId,dicturl];
    [[XXZQNetwork sharedInstance] deleteWithURLString:urlString parameters:nil
                                        authorization:authorization
                                              success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

@end
