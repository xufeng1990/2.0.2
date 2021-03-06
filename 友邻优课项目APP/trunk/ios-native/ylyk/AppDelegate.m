//
//  AppDelegate.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "YLYKTabBarController.h"
#import "WXApi.h"
#import "QYSDK.h"
#import "JPUSHService.h"
#import "Growing.h"
#import "Bugout/Bugout.h"
#import "TYDownloadSessionManager.h"
#import "YLYKPlayerManager.h"
#import "YLYKNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCellularData.h>
#import "YLYKIntroduceViewController.h"
#import "YLYKServiceModule.h"
#import "YLYKUserServiceModule.h"
#import "NSStringTools.h"
#import "CBLProgressHUD.h"
#import "PhoneLoginViewController.h"
#import "PayEvent.h"
#import "SplashScreen.h"

#import "YLYKIpadPlayerViewController.h"
#import "YLYKImagePickerViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <WXApiDelegate,NSURLSessionDelegate,JPUSHRegisterDelegate,BugoutDelegate>
@property (nonatomic, strong) YLYKPlayerManager *player;
@property (nonatomic, assign) BOOL pausedForAudioSessionInterruption;
@property (nonatomic, strong) Reachability *hostReachability;
@end

@implementation AppDelegate

- (void)receivedCrashNotification:(NSString*)stackTrace
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    YLYKIpadPlayerViewController *ipadVC = [YLYKIpadPlayerViewController new];
//    UINavigationController *ipadNav =  [[UINavigationController alloc]initWithRootViewController:ipadVC];
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:ipadVC];
    //self.window.rootViewController = ipadVC;
    //return YES;
    
//    YLYKImagePickerViewController *imagePicker = [YLYKImagePickerViewController new];
//    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:imagePicker];
//    return YES;
    
    
    self.allowRotation = NO;
    [self updateVersion];
    [WXApi registerApp:@"wxf56d7d93bc226f2e"];
    [self setQYSessionController];
    
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert  |  JPAuthorizationOptionSound;
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(JPUSHService)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    [JPUSHService setBadge:0];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"b9318d6e3b95b298f653470f"
                          channel:@"App Store"
                 apsForProduction:nil
            advertisingIdentifier:nil];

    [Growing startWithAccountId:@"bcd24b3b296a602f"];
    [Growing setEnableLog:NO];
    [Growing setRnNavigatorPageEnabled:YES];

    BugoutConfig *config = [BugoutConfig defaultConfig];
    NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:@"bugoutFeedBackState"];
    if (state) {
        if ([state isEqualToString:@"bugoutstate1"]) {
            config.enabledShakeFeedback = YES;
        } else if ([state isEqualToString:@"bugoutstate0"]) {
            config.enabledShakeFeedback = NO;
        }
    } else {
        config.enabledShakeFeedback = YES;
    }
    if (USERID) {
        [Bugout setUserData:USERID forKey:@"user_id"];
    }
    config.alertBtnCloseShakeFeedback = YES;
    [Bugout init:@"8f62460aa4a70ff2bb7f67b0b1a68707" channel:@"AppStore" config:config];

    [[NSUserDefaults standardUserDefaults] setObject:@"398374a3b6bb1d1238a1e3dd1af6bcf2" forKey:@"app_key"];
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 使用 NSUserDefaults 读取用户数据
    if (![useDef boolForKey:@"notFirst"]) {
        [self removeLastVersionDownloadCache];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"introduceFirst"];
        _window.rootViewController = [[YLYKIntroduceViewController alloc] init];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"introduceFirst"];
        YLYKTabBarController * tabbar = [[YLYKTabBarController alloc] init];
        YLYKNavigationController * nav = [[YLYKNavigationController alloc] initWithRootViewController:tabbar];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
        [SplashScreen show];
    }
    
    
    [[TYDownloadSessionManager manager] setBackgroundSessionDownloadCompleteBlock:^NSString *(NSString *downloadUrl) {
        TYDownloadModel *model = [[TYDownloadModel alloc]initWithURLString:downloadUrl];
        return model.filePath;
    }];
    [[TYDownloadSessionManager manager] configureBackroundSession];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionMediaServicesWereLostNotification object:[AVAudioSession sharedInstance]];
    self.player = [YLYKPlayerManager sharedPlayer];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self checkNetWorkState];
    
    return YES;
}

- (void)JPUSHService {
    if (USERID) {
        NSString *user_id = [NSString stringWithFormat:@"%@",USERID];
        NSSet * set = [[NSSet alloc] initWithObjects:user_id, nil];
        [JPUSHService setTags:set alias:user_id fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            XXZQLog(@"%@",iAlias);
        }];
    }
}

- (void)removeLastVersionDownloadCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *musicCache =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *musicCachePath = [musicCache stringByAppendingPathComponent:@"Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0"];
    NSArray *subMusicPath = [fileManager subpathsAtPath:musicCachePath];
    for (NSString *musicName in subMusicPath) {
        NSString *filePath = [musicCachePath stringByAppendingPathComponent:musicName];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

- (void)checkNetWorkState
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)no
{
    Reachability* curReach = [no object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            break;
        case ReachableViaWiFi:
            [self uploadOffLineListenTime];
            break;
        case ReachableViaWWAN:
            [self uploadOffLineListenTime];
            break;
        default:
            break;
    }
}

- (void)uploadOffLineListenTime
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"offLineCourseDict"];
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    NSArray *keysArray = [mutableDict allKeys];
    if (keysArray.count > 0) {
        NSString *courseIdKeys = keysArray[0];
        NSDictionary *parameters = [dict objectForKey:courseIdKeys];
        NSArray *parametersArray = [parameters allKeys];
        for (NSString *courseId in parametersArray) {
            NSDictionary *uploadTime = [parameters objectForKey:courseId];
            NSArray *array = @[@"course",courseId,@"stat"];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",uploadTime,@"body", nil];
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
                // 上传成功，移除当前key
                [mutableDict removeObjectForKey:courseIdKeys];
                NSDictionary * offLineDict = [NSDictionary dictionaryWithDictionary:mutableDict];
                [[NSUserDefaults standardUserDefaults] setObject:offLineDict forKey:@"offLineCourseDict"];
                // 移除之前存储的一节课断网时的收听时长
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"listen"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"learn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 再次上传
                NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"offLineCourseDict"];
                NSMutableDictionary *mutableDic = [dic mutableCopy];
                NSArray *keys = [mutableDic allKeys];
                if (keys < keysArray) {
                    [self uploadOffLineListenTime];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)updateVersion
{
    [YLYKServiceModule getSystemVersionsuccess:^(id responseObject) {
        NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:responseObject];
        NSDictionary *client = [dict objectForKey:@"client"];
        NSDictionary *resource = [dict objectForKey:@"resource"];
        NSDictionary *iosClient = [client objectForKey:@"ios"];
        NSDictionary *latest = [iosClient objectForKey:@"latest"];
        NSString *version = [latest objectForKey:@"version_code"];
        NSString *supportVersionCode = [[iosClient objectForKey:@"support"] objectForKey:@"version_code"];
        NSString *reviewVersionCode = [[iosClient objectForKey:@"review"] objectForKey:@"version_code"];
        NSString *download_url = [latest objectForKey:@"download_url"];
        NSString *description = [latest objectForKey:@"description"];
        NSDictionary *styleCSS = [resource objectForKey:@"style.css"];
        NSString *styleCSSURL = [styleCSS objectForKey:@"url"];
        NSString *styleCSSVersion = [styleCSS objectForKey:@"version"];
        [[NSUserDefaults standardUserDefaults] setObject:reviewVersionCode forKey:@"review_version_code"];
        [[NSUserDefaults standardUserDefaults] setObject:styleCSSURL forKey:@"styleCSSURL"];
        NSString *lastCSSVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"styleCSSVersion"];
        if (lastCSSVersion) {
            if ([styleCSSVersion integerValue]> [lastCSSVersion integerValue]) {
                [[NSUserDefaults standardUserDefaults] setObject:styleCSSVersion forKey:@"styleCSSVersion"];
            }
        } else {
            lastCSSVersion = @"20161231";
            [[NSUserDefaults standardUserDefaults] setObject:lastCSSVersion forKey:@"styleCSSVersion"];

        }
        NSString *currentLocalVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if([currentLocalVersionCode integerValue] < [supportVersionCode integerValue]) {
//            NSArray *arr = [NSArray array];
//            NSString *str = arr[7];
        } else if ([version integerValue]> [currentLocalVersionCode integerValue]) {
            NSDictionary *dic = [NSDictionary dictionary];
            [dic setValue:@"dsa" forKey:@"dsad"];
            [self alertViewWithURLString:download_url andDescription:description];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)alertViewWithURLString:(NSString *)URLString andDescription:(NSString *)description
{
    NSString *regexPattern = @"<br/>";
    NSMutableString *str = [NSMutableString stringWithString:description];
    NSString *pstr = @"\r\n";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:nil];
    [regex replaceMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:pstr];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                     message:str
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URLString]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:action1];
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
    [nav presentViewController:alertVC animated:YES completion:nil];
}

- (void)setQYSessionController
{
    [[QYSDK sharedSDK] registerAppId:@"d2638f57cf2a61b584537fbfa91b8f03" appName:@"友邻优课学员"];
    //注册 APNS
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types =UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

-(void)handleInterreption:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"otherHandleInterreption" object:self userInfo:notification.userInfo];
//        NSDictionary *info = notification.userInfo;
//        AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
//        NSInteger seccondReason = [[info objectForKey:@"AVAudioSessionInterruptionOptionKey"] integerValue];
//        XXZQLog(@"qqqqqqqqqq%@",notification.userInfo);
//        [self.player pause];
//        if (type == AVAudioSessionInterruptionTypeBegan) {
//            [self.player pause];
//    
//        } else if(type == AVAudioSessionInterruptionTypeEnded) {
////            if (seccondReason == AVAudioSessionInterruptionOptionShouldResume) {
//    
//                [self.player play];
////            }
//    
//        }
}

- (void)handleRouteChange:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {  //旧音频设备断开
        //获取上一线路描述信息
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        //获取上一线路的输出设备类型
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [self handleInterreptionNotificationPlayOrPause];
        }
    }
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) { //判断是否为授权请求，否则与微信支付等功能发生冲突
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSDictionary * wechatInfo;
        if (aresp.code == nil) {
            wechatInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",resp.errCode],@"errCode", nil];
        } else {
            wechatInfo = [NSDictionary dictionaryWithObjectsAndKeys:aresp.code,@"code", nil];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLoginNotification" object:self userInfo:wechatInfo];
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                [CBLProgressHUD showTextHUDInWindowWithText:@"支付成功"];
                self.paymentStateBlock(@{@"is_succeed":@true});
                [self sendPaySuccess:true];
                break;
            case WXErrCodeCommon:
                [CBLProgressHUD showTextHUDInWindowWithText:@"支付失败"];
                self.paymentStateBlock(@{@"is_succeed":@false});
                [self sendPaySuccess:false];
                break;
            case WXErrCodeUserCancel:
                [CBLProgressHUD showTextHUDInWindowWithText:@"已取消"];
                self.paymentStateBlock(@{@"is_succeed":@false});
                [self sendPaySuccess:false];
                break;
            case WXErrCodeSentFail:
                [CBLProgressHUD showTextHUDInWindowWithText:@"发送失败"];
                self.paymentStateBlock(@{@"is_succeed":@false});
                [self sendPaySuccess:false];
                break;
            case WXErrCodeAuthDeny:
                [CBLProgressHUD showTextHUDInWindowWithText:@"授权失败"];
                self.paymentStateBlock(@{@"is_succeed":@false});
                [self sendPaySuccess:false];
                break;
            case WXErrCodeUnsupport:
                [CBLProgressHUD showTextHUDInWindowWithText:@"微信不支持"];
                self.paymentStateBlock(@{@"is_succeed":@false});
                [self sendPaySuccess:false];
                break;
        }
    }
}

- (void)sendPaySuccess:(BOOL)trueOrFalse
{
    PayEvent *event = [[PayEvent alloc] init];
    if (trueOrFalse) {
        [PayEvent application:[UIApplication sharedApplication] withPayload:@{@"PaySuccess":@true}];
        [self getUserInfo];
    } else {
        [PayEvent application:[UIApplication sharedApplication] withPayload:@{@"PaySuccess":@false}];
    }
    [event startObserving];
}

- (void)getUserInfo
{
    [YLYKUserServiceModule getUserById:USERID success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userInfo"];
        NSString * xdyId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"xdy_id"]]  ;
        [[NSUserDefaults standardUserDefaults] setObject:xdyId forKey:@"xdy_id"];
        if ([dict objectForKey:@"vip"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isVip"];
        } else {
            [self getUserInfo];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([Growing handleUrl:url]) {
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [Growing handleUrl:url];
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    [TYDownloadSessionManager manager].backgroundSessionCompletionHandler = completionHandler;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype)    {
        case UIEventSubtypeRemoteControlPlay:
            [self remoteControllerNotificationWithStatus:@"play"];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self remoteControllerNotificationWithStatus:@"pause"];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self remoteControllerNotificationWithStatus:@"previous"];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self remoteControllerNotificationWithStatus:@"next"];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self sendNotificationPlayOrPause];
            break;
        default:
            break;
    }
}

- (void)remoteControllerNotificationWithStatus:(NSString *)str
{
    NSNotification * noti11 = [NSNotification notificationWithName:@"remoteControllerNotification" object:nil userInfo:@{@"playStatus":str}];
    [[NSNotificationCenter defaultCenter] postNotification:noti11];
}


- (void)sendNotificationPlayOrPause
{
    NSNotification * noti11 = [NSNotification notificationWithName:@"playerStatusChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti11];
}

- (void)handleInterreptionNotificationPlayOrPause
{
    NSNotification * noti11 = [NSNotification notificationWithName:@"handleInterreption" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti11];
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    [[QYSDK sharedSDK] registerPushMessageNotification:^(QYPushMessage *message) {
        XXZQLog(@"%@",message);
    }];
}
@end
