//
//  YLYKImagePickerViewController.m
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "NSStringTools.h"
#import "YLYKUploadImageTool.h"
#import "YLYKServiceModule.h"

@interface YLYKImagePickerViewController ()<UIImagePickerControllerDelegate , UINavigationControllerDelegate,UIActionSheetDelegate> {
    UIImagePickerController *_imagePickerController;
    NSURL *imagePathURL;
    NSString *_randomString;
}

@end

@implementation YLYKImagePickerViewController

RCT_EXPORT_MODULE();

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
    [self performSelector:@selector(openImagePicker) withObject:nil afterDelay:0.5];
    
}
- (void)openImagePicker {
    if ([self.selectType isEqualToString:@"album"]) {//从相册选择
        [self selectImageFromAlbum];
    } else if ([self.selectType isEqualToString:@"camera"]) {//从相机拍照
        [self selectImageFromCamera];
    } else {
        [self selectImageFromAlbum];
    }
}

- (void)openImagePickerViewController:(NSString *)openImageType {
    if ([openImageType isEqualToString:@"album"]) {//从相册选择
        NSLog(@"从相册选择");
        [self selectImageFromAlbum];
    } else if ([openImageType isEqualToString:@"camera"]) {//从相机拍照
        NSLog(@"从相机拍照");
        [self selectImageFromCamera];
    }
}


#pragma mark - UIActionSheet ViewDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self selectImageFromAlbum];
            break;
        case 1:
            [self selectImageFromCamera];
            break;
        case 2:
            break;
        default:
            break;
    }
}


#pragma mark -从摄像头获取图片或视频
- (void)selectImageFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //相机类型（拍照、录像...）字符串需要做相应的类型转换
        _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        _imagePickerController.allowsEditing = YES;
        //设置摄像头模式（拍照，录制视频）为录像模式
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

#pragma mark -从相册获取图片或视频
- (void)selectImageFromAlbum {
    //NSLog(@"相册");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
    }
}

#pragma mark -UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    imagePathURL = info[@"UIImagePickerControllerReferenceURL"];
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //压缩图片
        image = [image scaleToSize:CGSizeMake(100, 100)];
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        _randomString = [NSStringTools getRandomString];
        NSString *imageStr = [NSString stringWithFormat:@"/Documents/%@.png",_randomString];
        NSString *imagePath = [path_sandox stringByAppendingString:imageStr];
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        //        }
        //上传图片
        [self uploadAvatarImage:image];
    } else {//视频
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}



#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    
}

#pragma mark - UpdateUserAvatar request

/*
 *上传选中头像到服务器
 */
- (void)uploadAvatarImage:(UIImage *)avatarImage{
    NSString *user_id = @"";
    if (USERID) {
        user_id = USERID;
    }
    NSArray *array = @[@"user",user_id,@"avatar"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *qiqiuTokenDic = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:nil];
        NSString *upload_token =  [qiqiuTokenDic objectForKey:@"upload_token"];
        NSString *file_key     =  [qiqiuTokenDic objectForKey:@"file_key"];
        [YLYKUploadImageTool uploadImage:avatarImage withKey:file_key andToken:upload_token success:^(NSString *url) {
            NSLog(@"上传图片地址: %@",url);
            [self uploadAvatarKeyToService:file_key];
        } failure:^{
            NSLog(@"failure");
        }];
    } failure:^(NSError *error) {
        
     }];
}

/*
 *上传头像内容到服务器
 *@prama file_key 上传图片标识
 */
- (void)uploadAvatarKeyToService:(NSString *)file_key{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: file_key,@"file_key",nil];
    NSString *user_id = @"";
    if (USERID) {
        user_id = USERID;
    }
    NSArray *array = @[@"user",user_id,@"avatar"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",parameters,@"body", nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    __block AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *qiqiuTokenDic = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:nil];
        if ([[qiqiuTokenDic objectForKey:@"result"] integerValue] == 1) {
            NSLog(@"上传服务器成功!");
            NSString *path_sandox = NSHomeDirectory();
            //设置一个图片的存储路径
             NSString *imageStr = [NSString stringWithFormat:@"/Documents/%@.png",_randomString];
             NSString *imagePath = [path_sandox stringByAppendingString:imageStr];
            appDelegate.imagePickerResolve(imagePath);
        } else {
            appDelegate.imagePickerResolve(@false);
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
