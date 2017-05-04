//
//  PayEvent.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/10.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "PayEvent.h"
@implementation PayEvent
{
    BOOL hasListeners;
}
//@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();



- (NSArray<NSString *> *)supportedEvents {
    return @[@"PayEvent"];
}
- (void)startObserving {
    hasListeners = YES;
    for (NSString *event in [self supportedEvents]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleNotification:)
                                                         name:event
                                                       object:nil];
    }
}

+ (BOOL)application:(UIApplication *)application withPayload:(NSDictionary *)playing {
    [self postNotificationName:@"PayEvent" withPayload:playing];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withPayload:(NSDictionary *)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

-(void)stopObserving {
    hasListeners = NO;
}

- (void)handleNotification:(NSNotification *)notification {
    [self sendEventWithName:@"PayEvent" body:notification.userInfo];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
