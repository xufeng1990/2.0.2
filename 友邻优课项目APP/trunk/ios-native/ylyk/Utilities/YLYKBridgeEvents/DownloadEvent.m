//
//  DownloadEvent.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/6.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "DownloadEvent.h"
@implementation DownloadEvent
{
    BOOL hasListeners;
}

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents {
    return @[@"DownloadCourse"];
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

+ (BOOL)application:(UIApplication *)application withDownload:(NSDictionary *)downloadDict
{
    [self postNotificationName:@"DownloadCourse" withDownload:downloadDict];
    return YES;
}

+ (void)postNotificationName:(NSString *)name withDownload:(NSDictionary *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:self
                                                      userInfo:object];
}

- (void)stopObserving {
    hasListeners = NO;
}

- (void)handleNotification:(NSNotification *)notification {
    if (hasListeners && self.bridge != nil ) { // Only send events if anyone is listening
        [self sendEventWithName:@"DownloadCourse" body:notification.userInfo];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
