//
//  OAuthString.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "OAuthAndErrorString.h"
#import "NSStringTools.h"

@implementation OAuthAndErrorString

+ (instancetype)sharedInstance {
    static OAuthAndErrorString * OAuth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OAuth = [OAuthAndErrorString new];
    });
    return OAuth;
}

+ (NSString *)getSecurtyUrlString: (NSString *)urlstring withParameters: (NSDictionary *)parameters {
    
    // 获得时间参数与随机数
    NSString * timeString = [NSStringTools getTimeString];
    NSString * randomStr = [NSStringTools getRandomString];
    
    // 拼接字典 ，并按照ascii排序
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:timeString forKey:@"timestamp"];
    [dict setObject:randomStr forKey:@"nonce"];
    [dict addEntriesFromDictionary:parameters];
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    NSString * parastr;
    NSString * string = nil;
    for (int i=0; i<arr.count; i++) {
        NSString * value = [dict valueForKey:arr[i]];
        parastr = [NSString stringWithFormat:@"%@=%@",arr[i],value];
        if (string != nil) {
            string = [NSString stringWithFormat:@"%@&%@",string,parastr];
        } else {
            string = [NSString stringWithFormat:@"%@",parastr];
        }
        
    }
    // 将拼接好的字符串MD5运算
    NSString * md5String = [NSStringTools getMD5String:string];
    // 将运算好的MD5值拼接到url中
    md5String = [NSString stringWithFormat:@"timestamp=%@&nonce=%@&signature=%@",timeString,randomStr,md5String];
    return md5String;
    
}

// 判断是否登录 如果登录通过用户的userid,app_token,app_key来获取请求头部的另一个内容
+ (NSString *)getAuthorization {
    
    NSString * jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:@"has_login"];
    
    if (jsonString == nil) {
        NSString * authorization = @"USERID NjFhNDI1ZTYwMjdjNDY4Yzg3NWVmNjIyZWY0ZDcxY2I6YW5vbnltb3VzOi0x";
        return authorization;
    }
    
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:jsonString];
    
    
    NSString * userID = dict[@"user_id"];
    
    NSString * apptoken = dict[@"app_token"];
    NSString * app_key = dict[@"app_key"];
    
    NSString * str = [NSString stringWithFormat:@"%@:%@:%@",app_key,apptoken,userID];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    NSString * authorization = [NSString stringWithFormat:@"USERID %@",base64String];
    [[NSUserDefaults standardUserDefaults] setObject:authorization forKey:@"authorization"];
    return authorization;
}

#pragma mark -拆分字典将参数拼接
+ (NSString *)getParametersWithDictionary:(NSDictionary *)dict {
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    NSString * parastr;
    NSString * string = nil;
    for (int i=0; i<arr.count; i++) {
        NSString * value = [dict valueForKey:arr[i]];
        parastr = [NSString stringWithFormat:@"%@=%@",arr[i],value];
        if (string != nil) {
            string = [NSString stringWithFormat:@"%@&%@",string,parastr];
        } else {
            string = [NSString stringWithFormat:@"%@",parastr];
        }
    }
    return string;
}

#pragma mark -解析url，拼接url
+ (NSString *)getPathUrlWithObj:(id)obj {
    NSString * path = @"";
    if ([obj isKindOfClass: [NSArray class]]) {
        NSArray * urlPath = obj;
        for (int i=0; i<urlPath.count;i++) {
            path = [NSString stringWithFormat:@"%@/%@",path,urlPath[i]];
        }
    }
    return path;
}

+ (NSString *)getErrorMessageWithError:(NSError *)error {
    NSData * errmessageData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString * errorString = [[NSString alloc] initWithData:errmessageData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:errorString];
    NSString *errorMessage = [dict objectForKey:@"error_message"];
    return errorMessage;
}

+ (NSString *)getErrorCodeWithError:(NSError *)error {
    NSData * errmessageData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString * errorString = [[NSString alloc] initWithData:errmessageData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:errorString];
    NSString * errorCode = [dict objectForKey:@"error_code"];
    return errorCode;
}

+ (void)writeToFileWithKey:(NSString *)key andResponseObj:(id)responseObject {
    key = [NSStringTools getMD5String:key];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",key]];
    [responseObject writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
