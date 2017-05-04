//
//  OAuthString.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthAndErrorString : NSObject

+ (instancetype)sharedInstance;

+ (NSString *)getErrorMessageWithError:(NSError *)error;

+ (NSString *)getErrorCodeWithError:(NSError *)error;

+ (NSString *)getSecurtyUrlString: (NSString *)urlstring withParameters: (NSDictionary *)parameters;

+ (NSString *)getAuthorization;

+ (NSString *)getParametersWithDictionary:(NSDictionary *)dict;

+ (NSString *)getPathUrlWithObj:(id)obj;

+ (void)writeToFileWithKey:(NSString *)key andResponseObj:(id)responseObject;

@end
