//
//  NSString+JXLoader.h
//  JesseMusic
//
//  Created by 张明辉 on 16/7/19.
//  Copyright © 2016年 jesse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JXLoader)
/**
 *  临时文件路径
 */
+ (NSString *)tempFilePath;

/**
 *  缓存文件夹路径
 */
+ (NSString *)cacheFolderPath;

/**
 *  获取网址中的文件名
 */
+ (NSString *)fileNameWithURL:(NSURL *)url;


@end
