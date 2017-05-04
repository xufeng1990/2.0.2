//
//  XXZQNetworkCache.m
//  XXZQNetwork
//
//  Created by XXXBryant on 16/11/22.
//  Copyright © 2016年 张琦. All rights reserved.
//

#import "XXZQNetworkCache.h"
#import "YYCache.h"


@implementation XXZQNetworkCache

static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;

+ (void)initialize {
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

#pragma mark - 设置网络请求缓存
+ (void)setHttpCache:(id)httpData URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSString * cacheKey = [self cacheKeyWithURLString:URLString parameters:parameters];
    [_dataCache setObject:httpData forKey:cacheKey withBlock:nil];
}
#pragma mark - 获取网络请求缓存
+ (id)httpCacheForURLString:(NSString *)URLString parameters:(NSDictionary *)parameter {
    NSString * cacheKey =[self cacheKeyWithURLString:URLString parameters:parameter];
    return [_dataCache objectForKey:cacheKey];
}
#pragma mark -获取缓存大小
+ (NSInteger)getAllHttpCacheSize {
    return [_dataCache.diskCache totalCost];
}
#pragma mark -移除缓存
+ (void)removeAllHttpCache {
    [_dataCache.diskCache removeAllObjects];
}
#pragma mark -获取缓存
+ (NSString *)cacheKeyWithURLString: (NSString *)URLString parameters: (NSDictionary *)parameters {
    if (!parameters) {
        return URLString;
    }
    //将参数转换成字符串
    NSData * stringData  = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *paraString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    //将URL与转换好的参数字符串拼接在一起
    NSString * cacheKey  = [NSString stringWithFormat:@"%@%@",URLString,paraString];
    return cacheKey;
}

@end
