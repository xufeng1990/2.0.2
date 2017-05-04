//
//  UINavigationController+CBLVCBasedStatusBar.m
//  Bplan_iOS
//
//  Created by TragedyStar on 2016/10/23.
//  Copyright © 2016年 北京拜克洛克科技有限公司. All rights reserved.
//

#import "UINavigationController+CBLInteractivePopGestureRecognizer.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - CBLInteractivePopGestureRecognizerDelegate

@interface _CBLInteractivePopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@end

@implementation _CBLInteractivePopGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UINavigationController *navigationController = [self valueForKey:@"__parent"];
    if (navigationController.viewControllers.count < 2) {
        return NO;
    }
    if (navigationController.topViewController.interactivePopGestureDisable) {
        return NO;
    }
    // fix: push时响应手势导致的崩溃
    if ([[navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (navigationController.topViewController.navigationItem.leftBarButtonItem) {
        return YES;
    }
    if (navigationController.isNavigationBarHidden) {
        return YES;
    }
    
    // 获取系统原本的方法（该方法imp已经交换到本类的此方法了）。此处不能拿本类的实例直接调用，否则调用系统方法传进去的receiver是本类的实例，而不是系统的对象
    Method method = class_getInstanceMethod([_CBLInteractivePopGestureRecognizerDelegate class], _cmd);
    // 此时的self为系统的代理对象 _UINavigationInteractiveTransition
    return ((BOOL (*)(void *, Method, void *, void *))method_invoke)((__bridge void *)self, method, (__bridge void *)gestureRecognizer, (__bridge void *)touch);
}

@end

#pragma mark - UINavigationController (CBLNavigationControllerPopGesture)

@implementation UINavigationController (CBLInteractivePopGesture)

- (void)setupPopGesture {
    [self swizzleMethodForSelector:@selector(gestureRecognizer:shouldReceiveTouch:)];
}

- (void)swizzleMethodForSelector:(SEL)selector {
    Class _UINavigationInteractiveTransition = [self.interactivePopGestureRecognizer.delegate class];
    Method originMethod = class_getInstanceMethod(_UINavigationInteractiveTransition, selector);
    Method swizzledMethod = class_getInstanceMethod([_CBLInteractivePopGestureRecognizerDelegate class], selector);
    method_exchangeImplementations(originMethod, swizzledMethod);
}

@end

#pragma mark - UIViewController (CBLNavigationControllerPopGesture)

@implementation UIViewController (CBLNavigationControllerInteractivePopGesture)

- (void)setInteractivePopGestureDisable:(BOOL)interactivePopGestureDisable {
    objc_setAssociatedObject(self, @selector(interactivePopGestureDisable), @(interactivePopGestureDisable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)interactivePopGestureDisable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
