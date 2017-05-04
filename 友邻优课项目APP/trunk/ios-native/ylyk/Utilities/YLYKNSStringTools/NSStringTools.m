//
//  NSStringTools.m
//  XXZQNetwork
//
//  Created by 友邻优课 on 2016/12/30.
//  Copyright © 2016年 张琦. All rights reserved.
//

#import "NSStringTools.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "RCTEventDispatcher.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <sys/utsname.h>

@interface NSStringTools()

@end

@implementation NSStringTools

@synthesize bridge= _bridge;

//导出模块
RCT_EXPORT_MODULE();

+ (instancetype)sharedInstance
{
    static NSStringTools * tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [NSStringTools new];
    });
    return tools;
    
}

+ (NSString *)getRandomString {
    NSString *string = [[NSString alloc]init];
    
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
//    NSLog(@"%@", string);
    return string;
}

RCT_EXPORT_METHOD(getRandomString:(RCTResponseSenderBlock)callback)
{
  NSString *string = [[NSString alloc]init];
  
  for (int i = 0; i < 32; i++) {
    int number = arc4random() % 36;
    if (number < 10) {
      int figure = arc4random() % 10;
      NSString *tempString = [NSString stringWithFormat:@"%d", figure];
      string = [string stringByAppendingString:tempString];
    }else {
      int figure = (arc4random() % 26) + 97;
      char character = figure;
      NSString *tempString = [NSString stringWithFormat:@"%c", character];
      string = [string stringByAppendingString:tempString];
    }
  }
//  NSLog(@"%@", string);
  
  NSArray * arr = [NSArray arrayWithObject:string];
  callback(@[[NSNull null], arr]);
}

+ (NSString *)getTimeString {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

RCT_EXPORT_METHOD(getTimeString:(RCTResponseSenderBlock)callback)
{
  NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval a=[date timeIntervalSince1970];
  NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
  NSArray * arr = [NSArray arrayWithObject:timeString];
  callback(@[[NSNull null], arr]);
}

+ (NSString *)getMD5String:(NSString *)str {
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

RCT_EXPORT_METHOD(getMD5String:(NSString *)str callback:(RCTResponseSenderBlock)callback)
{
  //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
  const char *fooData = [str UTF8String];
  
  //2.然后创建一个字符串数组,接收MD5的值
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  
  //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
  CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
  /**
   第一个参数:要加密的字符串
   第二个参数: 获取要加密字符串的长度
   第三个参数: 接收结果的数组
   */
  
  //4.创建一个字符串保存加密结果
  NSMutableString *saveResult = [NSMutableString string];
  
  //5.从result 数组中获取加密结果并放到 saveResult中
  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [saveResult appendFormat:@"%02x", result[i]];
  }
  /*
   x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
   NSLog("%02X", 0x888);  //888
   NSLog("%02X", 0x4); //04
   */
  NSArray * arr = [NSArray arrayWithObject:saveResult];
  callback(@[[NSNull null], arr]);
}

+ (NSDictionary *)getDictionaryWithJsonstring:(NSString *)jsonString {

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:
                          NSJSONReadingMutableContainers error:&err];
    return dict;
}

+ (NSMutableArray *)getArrayWithJSONString:(NSString *)jsonString {
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:
                          NSJSONReadingMutableContainers error:&err];
    return arr;
}

RCT_EXPORT_METHOD(getBase64EncodeStringWithString:(NSString *)str callback:(RCTResponseSenderBlock)callback){
  NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSString * hash = [data base64EncodedStringWithOptions:0];
  NSArray * arr = [NSArray arrayWithObject:hash];
  callback(@[[NSNull null], arr]);
}

RCT_EXPORT_METHOD(getBase64DecodeStringWithString:(NSString *)str callback:(RCTResponseSenderBlock)callback)
{
  NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:0];
  NSString * hash = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  NSArray * arr = [NSArray arrayWithObject:hash];
  callback(@[[NSNull null], arr]);
}


RCT_EXPORT_METHOD(getSha1EncodeStringWithString: (NSString *)str callback:(RCTResponseSenderBlock)callback) {
  //  const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
  const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
  
  NSData *data = [NSData dataWithBytes:cstr length:str.length];
  //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
  CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  NSArray * arr = [NSArray arrayWithObject:output];
  callback(@[[NSNull null], arr]);
}

RCT_EXPORT_METHOD(getHmacSha1EncodeWithKey:(NSString *)key andStr:(NSString *)str callback:(RCTResponseSenderBlock)callback) {
  const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
  const char *cData = [str cStringUsingEncoding:NSASCIIStringEncoding];
  //Sha256:
  // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
  //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
  
  //sha1
  unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
  CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
  
  NSString *hash;
  NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [output appendFormat:@"%02x", cHMAC[i]];
  }
  hash = output;
  NSArray * arr = [NSArray arrayWithObject:hash];
  callback(@[[NSNull null], arr]);
}

RCT_EXPORT_METHOD(getHMACMD5WithStringWithKey:(NSString *)key andStr:(NSString *)str callback:(RCTResponseSenderBlock)callback) {
  const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
  const char *cData = [str cStringUsingEncoding:NSUTF8StringEncoding];
  const unsigned int blockSize = 64;
  char ipad[blockSize];
  char opad[blockSize];
  char keypad[blockSize];
  
  unsigned int keyLen = (CC_LONG)strlen(cKey);
  CC_MD5_CTX ctxt;
  if (keyLen > blockSize) {
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, cKey, keyLen);
    CC_MD5_Final((unsigned char *)keypad, &ctxt);
    keyLen = CC_MD5_DIGEST_LENGTH;
  }
  else {
    memcpy(keypad, cKey, keyLen);
  }
  
  memset(ipad, 0x36, blockSize);
  memset(opad, 0x5c, blockSize);
  
  int i;
  for (i = 0; i < keyLen; i++) {
    ipad[i] ^= keypad[i];
    opad[i] ^= keypad[i];
  }
  
  CC_MD5_Init(&ctxt);
  CC_MD5_Update(&ctxt, ipad, blockSize);
  CC_MD5_Update(&ctxt, cData, (CC_LONG)strlen(cData));
  unsigned char md5[CC_MD5_DIGEST_LENGTH];
  CC_MD5_Final(md5, &ctxt);
  
  CC_MD5_Init(&ctxt);
  CC_MD5_Update(&ctxt, opad, blockSize);
  CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
  CC_MD5_Final(md5, &ctxt);
  
  const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
  char hex[hex_len];
  for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
  }
  
  NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
  //  NSString *hash = [[[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding]];
  NSString * hash = [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding];
  
  NSArray * arr = [NSArray arrayWithObject:hash];
  callback(@[[NSNull null], arr]);
}

+ (NSString *)jsonToString:(id)data
{
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

@end
