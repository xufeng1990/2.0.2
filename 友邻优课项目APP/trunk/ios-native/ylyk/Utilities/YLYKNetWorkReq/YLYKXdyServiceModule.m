//
//  YLYKXdyServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKXdyServiceModule.h"
#import "XXZQNetwork.h"
#import "OAuthAndErrorString.h"
@implementation YLYKXdyServiceModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getXdyById :(NSString *)xdyId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@xdy/%@?%@",BASEURL_STRING,xdyId,dicturl];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        resolve(responseObject);
    } failure:^(NSError *error) {
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
    }];
}

@end
