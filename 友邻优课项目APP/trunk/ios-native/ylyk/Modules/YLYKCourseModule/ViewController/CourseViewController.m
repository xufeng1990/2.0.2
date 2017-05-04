//
//  CourseViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "CourseViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "YLYKPlayerViewController.h"
#import "YLYKIpadPlayerViewController.h"
#import "YLYKServiceModule.h"
#import "AppDelegate.h"
#import "CBLProgressHUD.h"
#import "LoginViewController.h"
#import "QYSDK.h"
#import "YLYKNavigationController.h"
#import "UINavigationController+CBLInteractivePopGestureRecognizer.h"

@interface CourseViewController ()

@end

@implementation CourseViewController

@synthesize bridge = _bridge;

- (void)viewDidLoad {
    [super viewDidLoad];
    //        NSURL* jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
    //    NSURL *jsCodeLocation = [NSURL URLWithString:RNURL];
    NSURL *jsCodeLocation = JS_CODE_LOCATION;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"course",@"tab_type", nil];
    RCTRootView* rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"ylyk_rn" initialProperties:dict launchOptions:nil];
    
    rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    self.view = rootView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
}

RCT_EXPORT_MODULE();

#pragma mark - 打开音频播放页
/*
*打开音频播放页
*@prama courseId  音频Id
*/
- (void)openPlayerController:(NSString *)courseId fromHomeOrDownload:(BOOL)state courseListString:(NSString *)listArrString resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [self isLoginAndVip:@"" resolver:^(id result) {
        if ([result isEqualToString:@"isVip"]) {
            [self openPlayerController:courseId fromHomeOrDownload:state courseListArrayString:listArrString resolver:^(id result) {
                resolve(result);
            } rejecter:nil];
        }
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        
    }];
}

YLYKPlayerViewController *ylykPlayer = nil;
YLYKIpadPlayerViewController *ylykIpadPlayer = nil;

RCT_EXPORT_METHOD(openPlayerController:(NSString *)courseId fromHomeOrDownload:(BOOL)state courseListArrayString:(NSString *)listArrString resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if ([courseId isEqualToString:@"0"]) {
        courseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPlayCourseId"];
    }
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        // 判断到底从哪里来的播放
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
        NSInteger playerCourseID = 0;
        if (IsIpad) {
            playerCourseID = ylykIpadPlayer.courseID;
        } else {
            playerCourseID = ylykPlayer.courseID;
        }
        if (playerCourseID != [courseId integerValue] && ![courseId isEqualToString:@"0"]) {
            if (IsIpad) {
                ylykIpadPlayer = [[YLYKIpadPlayerViewController alloc] init];
                ylykIpadPlayer.courseID = [courseId integerValue];
            } else {
                ylykPlayer = [[YLYKPlayerViewController alloc] init];
                ylykPlayer.courseID = [courseId integerValue];
            }
//            ylykPlayer = [[YLYKPlayerViewController alloc] init];
//            ylykPlayer.courseID = [courseId integerValue];

        }else {
//            for(YLYKPlayerViewController *playerVC in nav.viewControllers){
//                if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
//                    if(playerVC.courseID == ylykPlayer.courseID){
//                        [nav popToViewController:playerVC animated:YES];
//                    }
//                    return;
//                }
//            }
            if (IsIpad) {
                for(YLYKIpadPlayerViewController *playerVC in nav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKIpadPlayerViewController class]]){
                        if(playerVC.courseID == ylykIpadPlayer.courseID){
                            [nav popToViewController:playerVC animated:YES];
                        }
                        return;
                    }
                }
            } else {
                for(YLYKPlayerViewController *playerVC in nav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
                        if(playerVC.courseID == ylykPlayer.courseID){
                            [nav popToViewController:playerVC animated:YES];
                        }
                        return;
                    }
                }
            }
        }
        if (state) {
            NSArray *downlistArray = [self arrayWithJSONString:listArrString];
//            ylykPlayer.isFromDownload = YES;
//            ylykPlayer.downloadedArray = [NSMutableArray arrayWithArray:downlistArray];
            if (IsIpad) {
                ylykIpadPlayer.isFromDownload = YES;
                ylykIpadPlayer.downloadedArray = [NSMutableArray arrayWithArray:downlistArray];
            } else {
                ylykPlayer.isFromDownload = YES;
                ylykPlayer.downloadedArray = [NSMutableArray arrayWithArray:downlistArray];
            }
        }  else {
            //ylykPlayer.isFromDownload = NO;
            if (IsIpad) {
                ylykIpadPlayer.isFromDownload = NO;
            } else {
                ylykPlayer.isFromDownload = NO;
            }
        }
//        ylykPlayer.useID = [USERID integerValue];
//        ylykPlayer.authorization = AUTHORIZATION;
        
        if (IsIpad) {
            ylykIpadPlayer.useID = [USERID integerValue];
            ylykIpadPlayer.authorization = AUTHORIZATION;
        } else {
            ylykPlayer.useID = [USERID integerValue];
            ylykPlayer.authorization = AUTHORIZATION;
        }
        
        UINavigationController *searchNav = (UINavigationController *)nav.presentedViewController;
        if (nav.presentedViewController) {
//            for(YLYKPlayerViewController *playerVC in searchNav.viewControllers){
//                if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
//                    [searchNav popViewControllerAnimated:NO];
//                    [searchNav popViewControllerAnimated:NO];
//                }
//            }
//            if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
//                [(UINavigationController *)nav.presentedViewController pushViewController:ylykPlayer animated:NO];
//            }
            if (IsIpad) {
                for(YLYKIpadPlayerViewController *playerVC in searchNav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKIpadPlayerViewController class]]){
                        [searchNav popViewControllerAnimated:NO];
                        [searchNav popViewControllerAnimated:NO];
                    }
                }
                if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    [(UINavigationController *)nav.presentedViewController pushViewController:ylykIpadPlayer animated:NO];
                }
            } else {
                for(YLYKPlayerViewController *playerVC in searchNav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
                        [searchNav popViewControllerAnimated:NO];
                        [searchNav popViewControllerAnimated:NO];
                    }
                }
                if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    [(UINavigationController *)nav.presentedViewController pushViewController:ylykPlayer animated:NO];
                }
            }
        } else {
//            for(YLYKPlayerViewController *playerVC in nav.viewControllers){
//                if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
//                    [playerVC removeFromParentViewController];
//                }
//            }
//            [nav pushViewController:ylykPlayer animated:YES];
            if (IsIpad) {
                for(YLYKIpadPlayerViewController *playerVC in nav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKIpadPlayerViewController class]]){
                        [playerVC removeFromParentViewController];
                    }
                }
                [nav pushViewController:ylykIpadPlayer animated:YES];

            } else {
                for(YLYKPlayerViewController *playerVC in nav.viewControllers){
                    if([playerVC isKindOfClass:[YLYKPlayerViewController class]]){
                        [playerVC removeFromParentViewController];
                    }
                }
                [nav pushViewController:ylykPlayer animated:YES];

            }
        }
    });
}

#pragma mark - 获取当前视图控制器
- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

#pragma mark - JSON 转化数组
- (NSArray *)arrayWithJSONString:(NSString *)aJSONString {
    //NSAssert([aJSONString isKindOfClass:[NSString class]], @"aJSONString is illegal");
    NSData *aJSONData = [aJSONString dataUsingEncoding:NSUTF8StringEncoding];
    id aJSONObject = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    return [aJSONObject isKindOfClass:[NSArray class]] ? aJSONObject : nil;
}

#pragma mark - 登陆回调
RCT_EXPORT_METHOD(isLoginAndVip:(NSString *)str resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if (USER_INFO) {
        if ([USER_INFO objectForKey:@"vip"]) {
            NSString * endTime = [[USER_INFO objectForKey:@"vip"] objectForKey:@"end_time"];
            NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
            // 判断是否过期
            if ([endTime integerValue] > nowTime) {
                resolve(@"isVip");
            } else {
                resolve(@"expireVip");
                [self actionAndAlertViewTitle:@"" withMessage:@"成为友邻优课学员即可收听此课程" action2Title:@"咨询阿树老师" secondAction:^(id cancel) {
                    //NSLog(@"zixun");
                    [self sentUserInfoToQY];
                }];
            }
        } else{
            resolve(@"notVip");
            [self actionAndAlertViewTitle:@"" withMessage:@"成为友邻优课学员即可收听此课程" action2Title:@"咨询阿树老师" secondAction:^(id cancel) {
                //                NSLog(@"zixun");
                [self sentUserInfoToQY];
            }];
        }
    } else{
        [CBLProgressHUD showTextHUDInWindowWithText:@"未登录"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
            LoginViewController *login = [[LoginViewController alloc] init];
            if (nav.presentedViewController) {
                if ([nav.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    [(UINavigationController *)nav.presentedViewController presentViewController:login animated:YES completion:nil];
                }
            }
        });
    }
}

#pragma - mark actionAlert
- (void)actionAndAlertViewTitle:(NSString *)title withMessage:(NSString *)message action2Title:(NSString *)action2Title secondAction:(void (^)(id cancel))secondAction {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:action2Title style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        secondAction(action);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:action2];
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
    if (nav.presentedViewController) {
        //[nav dismissViewControllerAnimated:NO completion:nil];
        [nav.presentedViewController presentViewController:alertVC animated:YES completion:nil];
    } else {
        [nav presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - 发送用户信息到七鱼
- (void)sentUserInfoToQY{
    XXZQLog(@"%@",USER_INFO);
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = USERID;
    NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dictRealName = [NSMutableDictionary new];
    [dictRealName setObject:@"real_name" forKey:@"key"];
    NSString *realName = [[USER_INFO objectForKey:@"info"] objectForKey:@"realname"];
    [dictRealName setObject:realName forKey:@"value"];
    [array addObject:dictRealName];
    NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
    [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
    NSString *mobilephone = [USER_INFO objectForKey:@"mobilephone"];
    [dictMobilePhone setObject:mobilephone forKey:@"value"];
    [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
    [array addObject:dictMobilePhone];
    NSMutableDictionary *dictEmail = [NSMutableDictionary new];
    [dictEmail setObject:@"email" forKey:@"key"];
    [dictEmail setObject:@"true" forKey:@"hidden"];
    [dictEmail setObject:@"" forKey:@"value"];
    [array addObject:dictEmail];
    
    NSMutableDictionary *dictUserId = [NSMutableDictionary new];
    [dictUserId setObject:@"account" forKey:@"key"];
    [dictUserId setObject:USERID forKey:@"value"];
    [dictUserId setObject:@"0" forKey:@"index"];
    [dictUserId setObject:@"用户ID" forKey:@"label"];
    [array addObject:dictUserId];
    
    NSMutableDictionary *dictAvatar = [NSMutableDictionary new];
    [dictAvatar setObject:@"avatar" forKey:@"key"];
    NSString *avatarURL = [NSString stringWithFormat:@"%@user/%@/avatar",BASEURL_STRING,USERID];
    [dictAvatar setObject:avatarURL forKey:@"value"];
    [array addObject:dictAvatar];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:0
                                                     error:nil];
    if (data) {
        userInfo.data = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    }
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    [self openQYServies];
}

#pragma mark - 打开七鱼服务
- (void)openQYServies {
    //由于React 改变了系统时区 这里重新设置一下默认时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [NSTimeZone setDefaultTimeZone:zone];
    [[QYSDK sharedSDK] customUIConfig].customerHeadImageUrl = [NSString stringWithFormat:@"%@user/%@/avatar",BASEURL_STRING,USERID];
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImageUrl = [NSString stringWithFormat:@"%@xdy/%@/avatar",BASEURL_STRING,XDY_ID];
    
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"友邻优课";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"阿树老师";
    sessionViewController.source = source;
    sessionViewController.staffId = [self getStaffIdWithUserId];
    UIImage *img = [UIImage imageNamed:@"nav_back"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    YLYKNavigationController *nav =
    [[YLYKNavigationController alloc] initWithRootViewController:sessionViewController];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    YLYKNavigationController *nav1 = (YLYKNavigationController *)window.rootViewController;
    if (nav1.presentedViewController) {
        if ([nav1.presentedViewController isKindOfClass:[UINavigationController class]]) {
            sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:nav action:@selector(back)];
            UINavigationController *presentNav = (UINavigationController *)nav1.presentedViewController;
            [presentNav pushViewController:sessionViewController animated:YES];
        }
    } else {
        sessionViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:nav1 action:@selector(back)];
        [(UINavigationController *)nav1 presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 返回
- (void)back {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UINavigationController *nav1 = (UINavigationController *)window.rootViewController;
    if (nav1.presentedViewController) {
        [nav1 dismissViewControllerAnimated:NO completion:nil];
    } else {
        [nav1 popViewControllerAnimated:YES];
    }
}

- (int64_t)getStaffIdWithUserId {
    if ([USERID integerValue] % 2 == 0) {
        return 100578;
    } else {
        return 99738;
    }
}

#pragma mark - 获取网络请求状态
- (NSString *)getNetWorkState {
    return [YLYKServiceModule getSystemNetworkState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
