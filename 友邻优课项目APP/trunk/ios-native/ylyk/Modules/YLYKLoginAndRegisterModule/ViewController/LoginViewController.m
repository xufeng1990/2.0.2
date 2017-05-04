//
//  LoginViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/6.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "LoginViewController.h"
#import "YLYKServiceModule.h"
#import "YLYKTokenServiceModule.h"
#import "YLYKUserServiceModule.h"
#import "NSStringTools.h"
#import "WXApi.h"
#import "PhoneLoginViewController.h"
#import "CBLProgressHUD.h"
#import "JPUSHService.h"
#import <React/RCTEventDispatcher.h>
#import "LoginEvent.h"
#import "YLYKTabBarController.h"
#import "YLYKUserLicenseViewController.h"
#import "YLYKRegisterViewController.h"


@interface LoginViewController ()

/*
 *登陆 logo
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

/*
 *微信登陆按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

/*
 *手机号码登陆 视图
 */
@property (weak, nonatomic) IBOutlet UIView *mobilephoneLoginView;

/*
 *微信登陆 label
 */
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;

/*
 *注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

/*
 *用户协议 label
 */
@property (weak, nonatomic) IBOutlet UILabel *userProtocol;

/*
 *删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;

@end

@implementation LoginViewController

@synthesize bridge = _bridge;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
    if (![WXApi isWXAppInstalled]) {
        [self.wechatBtn removeFromSuperview];
        [self.wechatLabel removeFromSuperview];
    }

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mpbilephoneLogin:)];
    [self.mobilephoneLoginView addGestureRecognizer:tap];
    
    //NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], range:};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"登录即同意《友邻优课用户许可协议》"];
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(6, 10)];
    //赋值
    //[attribtStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(loc, len)];
    self.userProtocol.attributedText = attribtStr;
    self.userProtocol.userInteractionEnabled = YES;
    UITapGestureRecognizer * protocolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolWebview:)];
    [self.userProtocol addGestureRecognizer:protocolTap];
    
    NSString *currentLocalVersionCode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *reviewVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"review_version_code"];
    if ([reviewVersion integerValue] <= [currentLocalVersionCode integerValue]) {
        self.registerBtn.hidden = NO;
    } else {
        self.registerBtn.hidden = YES;
    }
    if (!reviewVersion) {
        self.registerBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatLoginNotification" object:nil];
    [super viewWillAppear:animated];
}


- (void)protocolWebview:(UITapGestureRecognizer *)tap {
    YLYKUserLicenseViewController *userLicense = [[YLYKUserLicenseViewController alloc] init];
    YLYKNavigationController *nav = [[YLYKNavigationController alloc] initWithRootViewController:userLicense];
    //[self.navigationController pushViewController:protocol animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 手机号码和微信登陆
- (void)mpbilephoneLogin:(UITapGestureRecognizer *)gesture {
    PhoneLoginViewController * phoneLogin = [[PhoneLoginViewController alloc] init];
    [self presentViewController:phoneLogin animated:YES completion:nil];
}

- (IBAction)weChatLogin:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        [WXApi sendReq:req];
    }
}

#pragma mark - 微信登陆 回调通知
- (void)wechatDidLoginNotification:(NSNotification *)sender {
    NSString * code = sender.userInfo[@"code"];
    NSString * errCode = sender.userInfo[@"errCode"];
    if (code) {
        [CBLProgressHUD showLoadingHUDInView:self.view];
        [YLYKTokenServiceModule getTokenFromWechat:code success:^(id responseObject) {
            NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSString * openid = [dict objectForKey:@"openid"];
            NSString * unionid = [dict objectForKey:@"unionid"];
            NSString * access_token = [dict objectForKey:@"access_token"];
            [self openid:openid accessToken:access_token unionId:unionid];
        } failure:^(NSError *error) {
            [CBLProgressHUD showTextHUDWithText:@"获取授权信息失败" inView:self.view];
        }];
    } else if ([errCode isEqualToString:@"-2"]) {
        [CBLProgressHUD showTextHUDWithText:@"已取消授权" inView:self.view];
    } else if ([errCode isEqualToString:@"-4"]) {
        [CBLProgressHUD showTextHUDWithText:@"已拒绝授权" inView:self.view];
    }
}

- (void)openid:(NSString *)openid accessToken:(NSString *)accessToken unionId:(NSString *)unionId {
    [YLYKUserServiceModule getuseInfo:openid accessToken:accessToken unionId:unionId success:^(id responseObject) {
        NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:responseObject];
        NSString * userId = [dict objectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
        [self getUserInfo];
        // 上传设备信息
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            [self putDeviceInfomationToJPushWithRegistrationID:registrationID];
        }];
        if (USERID) {
            NSSet * set = [[NSSet alloc] initWithObjects:USERID, nil];
            //[JPUSHService setTags:set alias:USERID callbackSelector:nil object:nil];
            [JPUSHService setTags:set alias:USERID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                XXZQLog(@"%@",iAlias);
            }];
            //[JPUSHService setTags:nil alias:USERID callbackSelector:@selector(regiseterJPUSH) object:nil];
        }
    } failure:^(NSError *error) {
        [CBLProgressHUD showTextHUDWithText:@"登录失败" inView:self.view];
    }];
}

#pragma mark - 上次设备信息
- (void)putDeviceInfomationToJPushWithRegistrationID:(NSString *)registrationID {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:registrationID,@"client_id",@"",@"token",@"ios",@"device" ,nil];
    NSArray *array = @[@"push"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",parameters,@"body", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[YLYKServiceModule sharedInstance] put:str success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)text:(loginSuccess)block {
    self.loginSuccess = block;
}

#pragma mark - 获取用户信息
- (void)getUserInfo {
    [YLYKUserServiceModule getUserById:USERID success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userInfo"];
        NSString * xdyId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"xdy_id"]]  ;
        [[NSUserDefaults standardUserDefaults] setObject:xdyId forKey:@"xdy_id"];
        if ([dict objectForKey:@"vip"]) {
            // 将是否是会员存储到本地
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isVip"];
            if ([[dict objectForKey:@"mobilephone"] isEqualToString:@""] || ![dict objectForKey:@"mobilephone"]) {
                [CBLProgressHUD hideLoadingHUDInView:self.view];
                [CBLProgressHUD showTextHUDInWindowWithText:@"请先绑定手机"];
                PhoneLoginViewController *bandPhone = [[PhoneLoginViewController alloc] init];
                bandPhone.title = @"绑定手机号";
                UINavigationController *nav =
                [[UINavigationController alloc] initWithRootViewController:bandPhone];
                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentViewController:nav animated:YES completion:nil];
                //});
            } else {
                [CBLProgressHUD hideLoadingHUDInView:self.view];
                [CBLProgressHUD showTextHUDWithText:@"登录成功" inView:self.view];
                [self dismissViewControllerAnimated:YES completion:nil];
                LoginEvent *events = [[LoginEvent alloc] init];
                [LoginEvent application:[UIApplication sharedApplication] withLogin:@{@"LoginSuccess":@true}];
                [events startObserving];
                // 发送登录成功的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:@"success" userInfo:nil];
            }
        } else {
            [CBLProgressHUD hideLoadingHUDInView:self.view];
            [CBLProgressHUD showTextHUDWithText:@"登录成功" inView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
            LoginEvent *events = [[LoginEvent alloc] init];
            [LoginEvent application:[UIApplication sharedApplication] withLogin:@{@"LoginSuccess":@true}];
            [events startObserving];
            // 发送登录成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:@"success" userInfo:nil];
        }
    } failure:^(NSError *error) {
        [CBLProgressHUD showTextHUDWithText:@"获取用户信息失败，请重新登录" inView:self.view];
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }];
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatLoginNotification" object:nil];
}

- (IBAction)dismissLoginViewController:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isLoginSuccess" object:@"failed" userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginVCDismiss" object:@"true" userInfo:nil];
}


- (IBAction)openRegisterViewController:(id)sender {
    YLYKRegisterViewController *registerVC = [[YLYKRegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
