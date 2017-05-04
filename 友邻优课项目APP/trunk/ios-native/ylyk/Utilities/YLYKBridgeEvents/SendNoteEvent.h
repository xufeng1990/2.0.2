//
//  SendNoteEvent.h
//  ylyk
//
//  Created by 友邻优课 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface SendNoteEvent : RCTEventEmitter <RCTBridgeModule>
+ (BOOL)application:(UIApplication *)application withSendNoteload:(NSDictionary *)sendNote;
@end
