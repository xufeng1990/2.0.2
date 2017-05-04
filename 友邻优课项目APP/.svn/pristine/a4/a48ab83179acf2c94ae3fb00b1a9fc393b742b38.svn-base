//
//  BugoutConfig.h
//  
//
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BugoutDelegate.h"

@interface BugoutConfig : NSObject

// delegate.
@property(nonatomic, strong) id delegate;

// Exception monitor enabled, default YES.
@property(nonatomic, assign) BOOL enabledMonitorException;

// Enabled feedback, default YES.
@property(nonatomic, assign) BOOL enabledShakeFeedback;

// Show shake feedback off option, default NO. if enabledShakeFeedback is NO, this value invalid.
@property(nonatomic, assign) BOOL alertBtnCloseShakeFeedback;

// use user location info, default NO.
@property(nonatomic, assign) BOOL useLocationInfo;

// only wifi report data, default YES.
@property(nonatomic, assign) BOOL reportOnlyWIFI;

// print log in simulator for debug, default NO.
@property(nonatomic, assign) BOOL printLogForDebug;


+ (BugoutConfig*)defaultConfig;

@end
