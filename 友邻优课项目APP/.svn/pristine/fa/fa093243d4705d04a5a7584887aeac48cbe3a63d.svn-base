//
//  YLYKBannerServiceModule.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKBannerServiceModule.h"
#import "OAuthAndErrorString.h"
#import "XXZQNetwork.h"
#import "NSStringTools.h"
@implementation YLYKBannerServiceModule

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(getBannerList, resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSString * authorization = [OAuthAndErrorString getAuthorization];
    NSString * dicturl = [OAuthAndErrorString getSecurtyUrlString:BASEURL_STRING withParameters:nil];
    NSString * urlString = [NSString stringWithFormat:@"%@banner?%@",BASEURL_STRING,dicturl];
    NSString *key = [NSString stringWithFormat:@"%@banner",BASEURL_STRING];
    [[XXZQNetwork sharedInstance] getWithURLString:urlString parameters:nil authorization:authorization success:^(id responseObject) {
        [OAuthAndErrorString writeToFileWithKey:key andResponseObj:responseObject];
        resolve(responseObject);
    } failure:^(NSError *error) {
        
        reject([OAuthAndErrorString getErrorCodeWithError:error],[OAuthAndErrorString getErrorMessageWithError:error],error);
        
    }];
}

@end
