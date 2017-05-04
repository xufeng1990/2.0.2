//
//  FileCache.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKFileStorageModule.h"
#import "UIImageView+WebCache.h"
#import "CBLProgressHUD.h"

@implementation YLYKFileStorageModule

RCT_EXPORT_MODULE();
#pragma mark - 保存图片
RCT_EXPORT_METHOD(saveImage:(NSString *)imageURLString  resolve:(RCTPromiseResolveBlock)resolve rejecte:(RCTPromiseRejectBlock)rejec) {
    NSURL *URL = [NSURL URLWithString:imageURLString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block UIImage *img;
    [manager diskImageExistsForURL:URL completion:^(BOOL isInCache) {
        if (isInCache) {
            img =  [[manager imageCache] imageFromDiskCacheForKey:URL.absoluteString];
        } else {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            img = [UIImage imageWithData:data];
        }
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
        if (img) {
            resolve(@"success");
        } else {
            resolve(@"error");
        }
    }];
}

#pragma mark - 图片保存错误回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        [CBLProgressHUD showTextHUDInWindowWithText:@"保存失败"];
    }   else {
        [CBLProgressHUD showTextHUDInWindowWithText:@"保存成功"];
    }
}

#pragma mark - 获取缓存图片
RCT_EXPORT_METHOD(imageCache:(NSString *)URLString resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSURL *URL = [NSURL URLWithString:URLString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block UIImage *img;
    [manager diskImageExistsForURL:URL completion:^(BOOL isInCache) {
        if (isInCache) {
            img =  [[manager imageCache] imageFromDiskCacheForKey:URL.absoluteString];
            NSString*cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
            if(cacheImageKey.length) {
                NSString*cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
                resolve(cacheImagePath);
            }
        } else {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            img = [UIImage imageWithData:data];
        }
    }];
}

@end
