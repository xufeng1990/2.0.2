//
//  ClearCacheBridge.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKCacheNativeModule.h"

@implementation YLYKCacheNativeModule

RCT_EXPORT_MODULE();

#pragma mark -获取总的下载文件的大小
RCT_EXPORT_METHOD(getDownloadCacheSize:(NSString *)download resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    //获取缓存沙盒路径
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接缓存文件文件夹路径
    NSString * fileCachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0"]];
    
    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
    //    self.fileCachePath = fileCachePath;
    
    //获取到该缓存目录下的所有子文件（只是文件名并不是路径，后面要拼接）
    NSArray * subFilePath = [fileManger subpathsAtPath:fileCachePath];
    
    //先定义一个缓存目录总大小的变量
    NSInteger fileTotalSize = 0;
    
    for (NSString * fileName in subFilePath) {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
        
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //获取单个文件大小,并累加到总大小
        fileTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    NSString *downloadSize = [NSString stringWithFormat:@"%.2fM",fileTotalSize/1000.0/1000];
    resolve(downloadSize);
}

#pragma mark -获取缓存大小
RCT_REMAP_METHOD(getCacheSize, cache:(RCTPromiseResolveBlock)resolve size:(RCTPromiseRejectBlock)reject ) {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    //获取缓存沙盒路径
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接缓存文件文件夹路径
    NSString * fileCachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    
    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
    //    self.fileCachePath = fileCachePath;
    
    //获取到该缓存目录下的所有子文件（只是文件名并不是路径，后面要拼接）
    NSArray * subFilePath = [fileManger subpathsAtPath:fileCachePath];
    
    //先定义一个缓存目录总大小的变量
    NSInteger fileTotalSize = 0;
    
    for (NSString * fileName in subFilePath) {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
        
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //获取单个文件大小,并累加到总大小
        fileTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    
    
    NSString * downloadPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0"]];
    
    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
    //    self.fileCachePath = fileCachePath;
    
    //获取到该缓存目录下的所有子文件（只是文件名并不是路径，后面要拼接）
    NSArray * subDownloadPath = [fileManger subpathsAtPath:downloadPath];
    
    //先定义一个缓存目录总大小的变量
    NSInteger downloadTotalSize = 0;
    
    for (NSString * fileName in subDownloadPath) {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [downloadPath stringByAppendingPathComponent:fileName];
        
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //获取单个文件大小,并累加到总大小
        downloadTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    NSString *downloadSize = [NSString stringWithFormat:@"%.2fM",(fileTotalSize - downloadTotalSize)/1000.0/1000];
    
    resolve(downloadSize);
}


#pragma mark -获取总缓存大小
RCT_REMAP_METHOD(getTotalCacheSize, cacheresolver:(RCTPromiseResolveBlock)resolve sizerejecter:(RCTPromiseRejectBlock)reject) {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    //获取缓存沙盒路径
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    
    //拼接缓存文件文件夹路径
    NSString * fileCachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    
    //将缓存文件夹路径赋值给成员属性(后面删除缓存文件时需要用到)
    //    self.fileCachePath = fileCachePath;
    
    //获取到该缓存目录下的所有子文件（只是文件名并不是路径，后面要拼接）
    NSArray * subFilePath = [fileManger subpathsAtPath:fileCachePath];
    
    //先定义一个缓存目录总大小的变量
    NSInteger fileTotalSize = 0;
    
    for (NSString * fileName in subFilePath) {
        //拼接文件全路径（注意：是文件）
        NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
        
        //获取文件属性
        NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:filePath error:nil];
        
        //根据文件属性判断是否是文件夹（如果是文件夹就跳过文件夹，不将文件夹大小累加到文件总大小）
        if ([fileAttributes[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        //获取单个文件大小,并累加到总大小
        fileTotalSize += [fileAttributes[NSFileSize] integerValue];
    }
    NSString *cacheSize = [NSString stringWithFormat:@"%.2fM",fileTotalSize/1000.0/1000];
    //将字节大小转为MB，然后传出去
    //        return fileTotalSize/1000.0/1000;
    resolve(cacheSize);
}

RCT_EXPORT_METHOD(clearCache) {
    //获取文件管理器对象
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    //获取缓存沙盒路径
    NSString * cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * fileCachePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@""]];
    NSArray * subFilePath = [fileManger subpathsAtPath:fileCachePath];
    for (NSString * fileName in subFilePath) {
        if (![fileName containsString:@"Pandora"]) {
            //拼接文件全路径（注意：是文件）
            NSString * filePath = [fileCachePath stringByAppendingPathComponent:fileName];
            [fileManger removeItemAtPath:filePath error:nil];
        }
    }
    // 清除音频缓存
    NSString *musicCache =  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *musicCachePath = [musicCache stringByAppendingPathComponent:@"MusicCaches"];
    NSArray *subMusicPath = [fileManger subpathsAtPath:musicCachePath];
    for (NSString *musicName in subMusicPath) {
        NSString *filePath = [musicCachePath stringByAppendingPathComponent:musicName];
        [fileManger removeItemAtPath:filePath error:nil];
    }
}

- (void)clearDownloadedCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *musicCache =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *musicCachePath = [musicCache stringByAppendingPathComponent:@"Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0"];
    NSArray *subMusicPath = [fileManager subpathsAtPath:musicCachePath];
    for (NSString *musicName in subMusicPath) {
        NSString *filePath = [musicCachePath stringByAppendingPathComponent:musicName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

@end
