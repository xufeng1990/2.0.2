//
//  JXResourceLoader.h
//  JesseMusic
//
//  Created by 张明辉 on 16/7/19.
//  Copyright © 2016年 jesse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JXRequestTask.h"

#define MimeType @"video/mp4"

@class JXResourceLoader;
@protocol JXLoaderDelegate <NSObject>

@required
- (void)loader:(JXResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(JXResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface JXResourceLoader : NSObject<AVAssetResourceLoaderDelegate,JXRequestTaskDelegate>

@property (nonatomic, weak) id <JXLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;

@end


