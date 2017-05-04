//
//  LoginEvent.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/31.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "LoginEvent.h"
@implementation LoginEvent
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[@"LoginSuccess"];
}

- (void)startObserving {
    for (NSString *event in [self supportedEvents]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleNotification:)
                                                         name:event
                                                       object:nil];
    }
}

+ (BOOL)application:(UIApplication *)application withLogin:(NSDictionary *)login {
    [self postNotificationName:@"LoginSuccess" withLogin:login];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withLogin:(NSDictionary *)object {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

- (void)handleNotification:(NSNotification *)notification {
    [self sendEventWithName:@"LoginSuccess" body:notification.userInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
