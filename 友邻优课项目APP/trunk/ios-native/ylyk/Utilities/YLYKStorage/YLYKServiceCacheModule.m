//
//  ServerCache.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKServiceCacheModule.h"
#import "NSStringTools.h"
#import "Storage.h"

@implementation YLYKServiceCacheModule

RCT_EXPORT_MODULE();

+ (void)writeToFileWithKey:(NSString *)key andResponseObj:(id)responseObject {
    key = [NSStringTools getMD5String:key];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",key]];
    [responseObject writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 获取课程缓存列表
RCT_EXPORT_METHOD(getCacheCourseList:(NSDictionary *)parameters resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    NSString * string = [self getParametersWithDictionary:parameters];
    NSString *key = [NSString stringWithFormat:@"%@course?%@",BASEURL_STRING,string];
    [self getItemByKey:key resolver:^(id result) {
        resolve(result);
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        reject(code,message,error);
    }];
}

#pragma mark - 获取相簿缓存列表
RCT_EXPORT_METHOD(getCacheAlbumList:(NSDictionary *)parameters resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    NSString * string = [self getParametersWithDictionary:parameters];
    NSString *key     = [NSString stringWithFormat:@"%@album?%@",BASEURL_STRING,string];
    [self getItemByKey:key resolver:^(id result) {
        resolve(result);
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        reject(code,message,error);
    }];
}

RCT_EXPORT_METHOD(getCacheAlbumById:(NSString *)albumId resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    NSString *key = [NSString stringWithFormat:@"%@album/%@",BASEURL_STRING,albumId];
    [self getItemByKey:key resolver:^(id result) {
        resolve(result);
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        reject(code,message,error);
    }];
}

RCT_EXPORT_METHOD(getItemByKey:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    key = [NSStringTools getMD5String:key];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",key]];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",str);
    if (str) {
        resolve(str);
    } else {
        NSError *error=[NSError errorWithDomain:@"我是Promise回调错误信息..." code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    }
}

#pragma mark - 获取心得缓存列表
RCT_EXPORT_METHOD(getCacheNoteList:(NSDictionary *)parameters resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    NSString *string = [self getParametersWithDictionary:parameters];
    NSString *key    = [NSString stringWithFormat:@"%@note?%@",BASEURL_STRING,string];
    [self getItemByKey:key resolver:^(id result) {
        resolve(result);
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        reject(code,message,error);
    }];
}
#pragma mark - 获取参数
- (NSString *)getParametersWithDictionary:(NSDictionary *)dict {
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSString * parastr;
    NSString * string = nil;
    for (int i = 0; i < arr.count; i++) {
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


@end
