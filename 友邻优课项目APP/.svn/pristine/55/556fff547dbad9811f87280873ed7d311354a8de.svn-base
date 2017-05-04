//
//  NSString+Addition.h
//  BeiAi
//
//  Created by Apple on 14-3-11.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

// 随机生成多少位的字符串
+ (NSString *)randomStringWithLength:(int)length;

// 字符串转换成十六进制
+ (NSString *)stringToHex:(const char *)key len:(NSUInteger)len;

+ (NSString *)stringWithOutSpace:(NSString *)str ;  //去除前后的空格

+ (BOOL)isInt:(NSString *)str ;  //是否全数字

+ (BOOL)isFloat:(NSString *)str ; //是否小数

+ (BOOL)isEmptyOrNull:(NSString *)str;
+ (NSString *)getPromptStringWithCode:(long)aCode;
+ (NSString *)getPromptStringWithNumber:(NSNumber *)aNumber;
+ (NSString *)getStringWithString:(NSString *)aString;

- (NSData *)hexToBytes;
- (NSString *)stringByStrippingHTML;
- (CGSize)safeSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)constrainedToSize;
- (CGFloat)safeWidthWithFont:(UIFont *)font;
- (CGFloat)safeHeightWithFont:(UIFont *)font width:(CGFloat)width;

@end
