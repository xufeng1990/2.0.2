//
//  NoteListViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/3.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "TeacherDetailViewController.h"
#import "YLYKPlayerViewController.h"
#import "CourseViewController.h"
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import "YLYKHomepageViewController.h"
#import "YLYKTabBarController.h"
@interface TeacherDetailViewController ()

@end

@implementation TeacherDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSURL* jsCodeLocation = JS_CODE_LOCATION;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"TeacherView",@"tab_type", self.teacherInfo,@"teacherInfo", nil];
    RCTRootView* rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:@"ylyk_rn" initialProperties:dict launchOptions:nil];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"老师详情";
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
