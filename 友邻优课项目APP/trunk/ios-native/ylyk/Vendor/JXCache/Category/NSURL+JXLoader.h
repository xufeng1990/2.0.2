//
//  NSURL+JXLoader.h
//  JesseMusic
//
//  Created by 张明辉 on 16/7/19.
//  Copyright © 2016年 jesse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JXLoader)
/**
 *  自定义scheme
 */
- (NSURL *)customSchemeURL;

/**
 *  还原scheme
 */
- (NSURL *)originalSchemeURL;

@end
