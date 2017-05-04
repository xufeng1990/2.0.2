//
//  Stroage.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "Storage.h"
#import "YLYKServiceModule.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
#import "NSStringTools.h"
#import "CBLProgressHUD.h"

@interface Storage()

@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, assign) NSString *saveSuccess;

@end

@implementation Storage

@synthesize bridge= _bridge;

//导出模块
RCT_EXPORT_MODULE();

- (NSMutableArray *)array {
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

+ (instancetype)sharedInstance
{
    static Storage * storage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [Storage new];
    });
    return storage;
}

- (NSObject *)getItemByKey:(NSString *)key {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
#pragma mark - getItem getItemByKey
RCT_EXPORT_METHOD(getItem:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (string) {
        resolve(string);
    } else {
        NSError *error=[NSError errorWithDomain:@"我是Promise回调错误信息..." code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    }
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

#pragma mark - setItem setItemByKey
RCT_EXPORT_METHOD(setItem:(NSString *)key :(NSString *)value  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [self.array addObject:key];
    NSArray *events = [NSArray arrayWithObjects: self.array,@"error", nil];
    if (events) {
        resolve(@"success");
    } else {
        NSError *error=[NSError errorWithDomain:@"false" code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    }
}

- (void)setItemByKey:(NSString *)key :(NSDictionary *)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [self.array addObject:key];
}

#pragma mark - removeItem removeItemByKey
// 只能移除RN调用该类生成的key
RCT_EXPORT_METHOD(removeItem:(NSString *)key  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if ([self.array containsObject:key]) {
        [self.array removeObject:key];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        resolve(@"success");
    } else {
        // 不存在
        NSError *error=[NSError errorWithDomain:@"false" code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    }
}

- (void)removeItemByKey:(NSString *)key {
    if ([self.array containsObject:key]) {
        [self.array removeObject:key];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    } else {
        // 不存在
    }
}

#pragma mark - removeAllItems
// 只能移除RN调用该类生成的key
RCT_REMAP_METHOD(removeAllItems, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.array.count>0) {
        for (int i = 0; i<self.array.count; i++) {
            [userDefaults removeObjectForKey:self.array[i]];
        }
        [userDefaults synchronize];
    }
    [self.array removeAllObjects];
    if (self.array.count>0) {
        NSError *error=[NSError errorWithDomain:@"false" code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    } else {
        resolve(@"removeallsuccess");
    }
}

- (void)removeAllItems {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.array.count>0) {
        for (int i = 0; i<self.array.count; i++) {
            [userDefaults removeObjectForKey:self.array[i]];
        }
        [userDefaults synchronize];
    }
    [self.array removeAllObjects];
}

#pragma mark - getAllKeys
// 只能获得RN调用该类生成的keys
RCT_REMAP_METHOD(getAllKeys, resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)reject) {
    if (self.array.count>0) {
        resolve(self.array);
    }else {
        NSError *error=[NSError errorWithDomain:@"false" code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    }
}

- (NSArray *)getAllKeys {
    return self.array;
}

#pragma mark - clearAllKeys
RCT_REMAP_METHOD(clearAllKeys, resolveBlock:(RCTPromiseResolveBlock)resolve rejecterBlock:(RCTPromiseRejectBlock)reject){
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        [defatluts removeObjectForKey:key];
        [defatluts synchronize];
    }
    if (!defatluts) {
        NSError *error=[NSError errorWithDomain:@"false" code:101 userInfo:nil];
        reject(@"no_events", @"There were no events", error);
    } else {
        resolve(@"removeallsuccess");
    }
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
