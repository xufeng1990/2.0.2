//
//  YLYKProfileViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "YLYKProfileViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "Storage.h"
#import "NSStringTools.h"
#import "UINavigationController+CBLInteractivePopGestureRecognizer.h"

@interface YLYKProfileViewController ()

@end

@implementation YLYKProfileViewController


#pragma mark - Lifecycle

- (void)loadView
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSURL *jsCodeLocation = [NSURL URLWithString:RNURL];
    NSURL *jsCodeLocation = JS_CODE_LOCATION;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"profile",@"tab_type", nil];
    RCTRootView* rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"ylyk_rn"
                                                 initialProperties:dict
                                                     launchOptions:nil];
    
    self.view = rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

@end
