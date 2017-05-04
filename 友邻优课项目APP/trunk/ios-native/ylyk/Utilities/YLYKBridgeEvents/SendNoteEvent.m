//
//  SendNoteEvent.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "SendNoteEvent.h"

@implementation SendNoteEvent
{
    BOOL hasListeners;
}
//@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();



- (NSArray<NSString *> *)supportedEvents {
    return @[@"sendNoteEvent"];
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

+ (BOOL)application:(UIApplication *)application withSendNoteload:(NSDictionary *)sendNote
{
    [self postNotificationName:@"sendNoteEvent" withSendNoteload:sendNote];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withSendNoteload:(NSDictionary *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

-(void)stopObserving {
    hasListeners = NO;
}

- (void)handleNotification:(NSNotification *)notification {
    [self sendEventWithName:@"sendNoteEvent" body:notification.userInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
