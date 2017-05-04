//
//  Album.h
//  YLYK-App
//
//  Created by 友邻优课 on 2017/2/2.
//  Copyright © 2017年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYKAlbumModel : NSObject

/*
 *专辑ID
 */
@property (nonatomic,assign) NSInteger albumId;

/*
 *是否免费
 */
@property (nonatomic,assign) BOOL is_free;

/*
 *专辑名称
 */
@property (nonatomic,copy) NSString * name;

@end
