//
//  LogoutEvent.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/4.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface LogoutEvent : RCTEventEmitter <RCTBridgeModule>
+ (BOOL)application:(UIApplication *)application withLogout:(NSDictionary *)playing;
@end
