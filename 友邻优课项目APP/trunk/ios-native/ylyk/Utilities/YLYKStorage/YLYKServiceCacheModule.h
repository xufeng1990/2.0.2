//
//  ServerCache.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
@interface YLYKServiceCacheModule : NSObject <RCTBridgeModule>
+ (void)writeToFileWithKey:(NSString *)key andResponseObj:(id)responseObject;
@end
