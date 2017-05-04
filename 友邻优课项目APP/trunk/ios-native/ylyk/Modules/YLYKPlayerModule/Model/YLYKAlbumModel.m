//
//  Album.m
//  YLYK-App
//
//  Created by 友邻优课 on 2017/2/2.
//  Copyright © 2017年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import "YLYKAlbumModel.h"

@implementation YLYKAlbumModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"albumId": @"id"};
}

@end
