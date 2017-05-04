//
//  Stroage.h
//  ylyk
//
//  Created by 友邻优课 on 2017/2/17.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface Storage : NSObject <RCTBridgeModule>

+ (instancetype)sharedInstance;

- (NSArray *)getAllKeys;

- (NSObject *)getItemByKey:(NSString *)key;

- (void)setItemByKey:(NSString *)key :(NSObject *)value;

- (void)removeItemByKey:(NSString *)key;

- (void)removeAllItems;

@end
