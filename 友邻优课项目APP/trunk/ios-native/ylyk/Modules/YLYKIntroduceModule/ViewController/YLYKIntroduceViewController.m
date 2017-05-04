//
//  YLYKIntroduceViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/22.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKIntroduceViewController.h"
#import "YLYKNavigationController.h"
#import "YLYKTabBarController.h"
#import "YLYKPageControl.h"
#import "SplashScreen.h"
#import "YLYKHomepageViewController.h"
#import "LoginViewController.h"

@interface YLYKIntroduceViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    // 判断是否是第一次进入应用
    BOOL flag;
}

@property (nonatomic, strong) YLYKNavigationController * nav;

@property (nonatomic, strong) YLYKPageControl *pageControl;

@end

@implementation YLYKIntroduceViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    for (int i = 0; i < 4; i++) {
        UIImage *image;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"iPad_launch_%d",i+1]];
        } else {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"launch_%d",i+1]];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 在最后一页创建按钮
        if (i == 3) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 100, SCREEN_HEIGHT * 13 / 16, 200, SCREEN_HEIGHT / 16);
            [button setImage:[UIImage imageNamed:@"start_button"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(goTabBar:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    _pageControl = [[YLYKPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 15 / 16, SCREEN_WIDTH , SCREEN_HEIGHT / 16)
                                         indicatorMargin:5
                                          indicatorWidth:8
                                   currentIndicatorWidth:20
                                         indicatorHeight:8];
    _pageControl.numberOfPages = 4;
    _pageControl.scrollView = myScrollView;
    [self.view addSubview:_pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
}

#pragma mark - 进入根视图控制器
// 点击按钮保存数据并切换根视图控制器
- (void) goTabBar:(UIButton *)sender {
    flag = YES;
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    [useDef setBool:flag forKey:@"notFirst"];
    [useDef synchronize];
    // 切换根视图控制器
    YLYKTabBarController * tabbar = [[YLYKTabBarController alloc] init];
    YLYKNavigationController * nav = [[YLYKNavigationController alloc] initWithRootViewController:tabbar];
    self.view.window.rootViewController = nav;
}

#pragma mark - 登陆消失通知
- (void)loginVCDismiss:(NSNotificationCenter *)noti {
    YLYKTabBarController * tabbar = [[YLYKTabBarController alloc] init];
    YLYKNavigationController * nav = [[YLYKNavigationController alloc] initWithRootViewController:tabbar];
    self.view.window.rootViewController = nav;
}

@end
