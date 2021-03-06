//
//  HomeWillAppearEvent.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/13.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "HomeWillAppearEvent.h"
static NSInteger count = 0;
@implementation HomeWillAppearEvent
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[@"HomeWillAppearEvent"];
}
- (void)startObserving
{
    for (NSString *event in [self supportedEvents]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleNotification:)
                                                         name:event
                                                       object:nil];
    }
}

+ (BOOL)application:(UIApplication *)application withHomeAppearLoad:(NSDictionary *)playing
{
    [self postNotificationName:@"HomeWillAppearEvent" withHomeAppearLoad:playing];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withHomeAppearLoad:(NSDictionary *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

- (void)handleNotification:(NSNotification *)notification {
    [self sendEventWithName:@"HomeWillAppearEvent" body:notification.userInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



