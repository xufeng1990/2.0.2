//
//  YLYKNavigationController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "YLYKNavigationController.h"
#import "UINavigationController+CBLInteractivePopGestureRecognizer.h"
#import "AppDelegate.h"

@interface YLYKNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation YLYKNavigationController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak YLYKNavigationController *weakSelf = self;
    self.interactivePopGestureRecognizer.delegate = weakSelf;
    self.delegate = weakSelf;
}

#pragma mark - push pop
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationBar.barTintColor = [UIColor greenColor];
    [super pushViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = NO;
    return [super popToRootViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -横屏操作
//- (BOOL)shouldAutorotate {
////    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
////        return ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation;
////    }
////    return NO;
//    return [self.visibleViewController shouldAutorotate];
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.visibleViewController supportedInterfaceOrientations];
//}

#pragma mark - 返回上一级
- (void)back {
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self popViewControllerAnimated:YES];
    }
}

@end
