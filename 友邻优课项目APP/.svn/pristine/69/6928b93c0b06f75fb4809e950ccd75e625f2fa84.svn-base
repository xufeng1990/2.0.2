//
//  YLYKImagePickerViewController.h
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>

@interface YLYKImagePickerViewController : UIViewController <RCTBridgeModule>


@property (nonatomic ,copy) NSString *selectType;
/*
 *从相册获取图片
 */
- (void)selectImageFromAlbum;

/*
 *从摄像头获取图片
 */
- (void)selectImageFromCamera;

- (void)openImagePickerViewController:(NSString *)openImageType;
@end
