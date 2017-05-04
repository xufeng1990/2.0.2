//
//  UINavigationController+CBLVCBasedStatusBar.h
//  Bplan_iOS
//
//  Created by TragedyStar on 2016/10/23.
//  Copyright © 2016年 北京拜克洛克科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CBLInteractivePopGesture)

- (void)setupPopGesture;

@end

@interface UIViewController (CBLNavigationControllerInteractivePopGesture)

@property (nonatomic, assign) BOOL interactivePopGestureDisable;

@end
