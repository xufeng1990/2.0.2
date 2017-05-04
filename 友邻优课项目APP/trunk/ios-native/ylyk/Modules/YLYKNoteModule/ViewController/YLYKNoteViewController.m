//
//  NoteViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/2/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "YLYKNoteViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "NSStringTools.h"
#import "AppDelegate.h"
#import <React/RCTBridge.h>
#import "UINavigationController+CBLInteractivePopGestureRecognizer.h"


@interface YLYKNoteViewController ()

@end

@implementation YLYKNoteViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        //NSURL *jsCodeLocation = [NSURL URLWithString:RNURL];
        NSURL *jsCodeLocation = JS_CODE_LOCATION;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"note",@"tab_type", nil];
        RCTRootView* rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                            moduleName:@"ylyk_rn"
                                                     initialProperties:dict
                                                         launchOptions:nil];
        rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        self.view = rootView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
      ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
