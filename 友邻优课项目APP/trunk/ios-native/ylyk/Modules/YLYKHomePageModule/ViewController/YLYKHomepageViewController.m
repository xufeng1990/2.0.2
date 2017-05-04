//
//  YLYKHomepageViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "YLYKHomepageViewController.h"
#import <React/RCTRootView.h>
#import "HomeWillAppearEvent.h"

@interface YLYKHomepageViewController ()

@end

@implementation YLYKHomepageViewController


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 使用 NSUserDefaults 读取用户数据
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"introduceFirst"]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginVCDismiss) name:@"loginVCDismiss" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginVCDismiss) name:@"isLoginSuccess" object:nil];
    } else {
        NSURL *jsCodeLocation = JS_CODE_LOCATION;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"homepage",@"tab_type", nil];
        RCTRootView* rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                            moduleName:@"ylyk_rn"
                                                     initialProperties:dict
                                                         launchOptions:nil];
        self.view = rootView;
    }
}

- (void)loginVCDismiss {
    NSURL *jsCodeLocation = JS_CODE_LOCATION;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"homepage",@"tab_type", nil];
    RCTRootView* rootView = [[RCTRootView alloc]
                             initWithBundleURL:jsCodeLocation
                             moduleName:@"ylyk_rn"
                             initialProperties:dict
                             launchOptions:nil];
    self.view = rootView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    HomeWillAppearEvent *event = [[HomeWillAppearEvent alloc] init];
    [HomeWillAppearEvent application:[UIApplication sharedApplication] withHomeAppearLoad:@{@"HomeWillAppear":@true}];
    [event startObserving];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 横竖屏切换
-(BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
