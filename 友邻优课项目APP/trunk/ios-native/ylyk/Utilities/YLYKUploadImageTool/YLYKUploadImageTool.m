//
//  YLYKUploadImageTool.m
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import "YLYKUploadImageTool.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "QiniuUploadHelper.h"


#define QiNiuBaseUrl @"http://7xozpn.com2.z0.glb.qiniucdn.com/"
@implementation YLYKUploadImageTool

//上传单张图片
+ (void)uploadImage:(UIImage *)image withKey:(NSString *)key andToken:(NSString *)token success:(void (^)(NSString *url))success failure:(void (^)())failure {
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    [uploadManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.statusCode == 200 && resp) {
            NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
            if (success) {
                success(url);
            }
        } else {
            if (failure) {
                failure();
            }
        }
        } option:nil];
}

//上传多张图片
+ (void)uploadImages:(NSArray *)imageArray withKeys:(NSArray *)key andTokens:(NSArray *)token success:(void (^)(NSArray *))success failure:(void (^)())failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            if (imageArray.count > 0 && key.count > 0 && token.count > 0) {
                if (currentIndex<imageArray.count) {
                    [YLYKUploadImageTool uploadImage:imageArray[currentIndex] withKey:key[currentIndex] andToken:token[currentIndex] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
                }
                
            }
        }
    };
    if (imageArray.count > 0 && key.count > 0 && token.count > 0) {
        [YLYKUploadImageTool uploadImage:imageArray[0] withKey:key[0] andToken:token[0] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
    }
}

@end
