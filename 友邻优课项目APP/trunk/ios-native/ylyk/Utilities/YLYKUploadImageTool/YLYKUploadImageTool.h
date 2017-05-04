//
//  UploadImageTool.h
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Qiniu/QiniuSDK.h>
#import <UIKit/UIKit.h>
@interface YLYKUploadImageTool : NSObject
/**
 *  上传图片
 *
 *  @param image    需要上传的image
 *  @param progress 上传进度block
 *  @param success  成功block 返回url地址
 *  @param failure  失败block
 */
+ (void)uploadImage:(UIImage *)image success:(void (^)(NSString *url))success failure:(void (^)())failure;

//上传单张图片
+ (void)uploadImage:(UIImage *)image withKey:(NSString *)key andToken:(NSString *)token success:(void (^)(NSString *url))success failure:(void (^)())failure;

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray withKeys:(NSArray *)key andTokens:(NSArray *)token  success:(void (^)(NSArray *))success failure:(void (^)())failure ;
@end
