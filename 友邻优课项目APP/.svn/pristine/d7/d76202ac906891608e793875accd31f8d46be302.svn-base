//
//  XXZQNetworkCache.h
//  XXZQNetwork
//
//  Created by XXXBryant on 16/11/22.
//  Copyright © 2016年 张琦. All rights reserved.
//

#import <Foundation/Foundation.h>

//网络数据缓存


@interface XXZQNetworkCache : NSObject

/**
 *  缓存网络数据
 *  @param httpData         服务器返回的数据
 *  @param URLString        请求的URL地址
 *  @param parameters       请求的参数
 */

+ (void)setHttpCache:(id)httpData URLString: (NSString *)URLString parameters: (NSDictionary *)parameters;

/**
 *  根据请求的 URLString与parameters  取出缓存数据
 *
 *  @param URLString                请求的URL
 *  @param parameters               请求的参数
 *  @return                         缓存的服务器数据
 */
+ (id)httpCacheForURLString:(NSString *)URLString parameters:(NSDictionary *)parameters;

/**
 *  获取网络缓存的总大小
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 *  移除所有网络缓存
 */
+ (void)removeAllHttpCache;
@end
