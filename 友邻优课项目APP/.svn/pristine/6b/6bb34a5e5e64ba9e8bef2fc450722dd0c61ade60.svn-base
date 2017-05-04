//
//  BridgeEvents.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/29.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "BridgeEvents.h"
@implementation BridgeEvents
{
    BOOL hasListeners;
}
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[@"playOrPauseToRN"];
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

+ (BOOL)application:(UIApplication *)application withPlaying:(NSDictionary *)playing {
    [self postNotificationName:@"playOrPauseToRN" withPlayload:playing];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withPlayload:(NSDictionary *)object {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

- (void)handleNotification:(NSNotification *)notification {
    if (hasListeners) { // Only send events if anyone is listening
        [self sendEventWithName:@"playOrPauseToRN" body:notification.userInfo];
    }
   
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopObserving {
     hasListeners = NO;
}

@end
