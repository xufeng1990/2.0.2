//
//  NSDictionary+Additions.m
//  Fantasy
//
//  Created by Fantasy Zhou on 12-9-14.
//  Copyright (c) 2012年 Walking Studio. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (BOOL)boolValueForKey:(NSString *)key {
    return [self boolValueForKey:key defaultValue:NO];
}

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (int)intValueForKey:(NSString *)key {
    return [self intValueForKey:key defaultValue:0];
}
- (float)floatValueForKey:(NSString *)key {
    return [self floatValueForKey:key defaultValue:0.0];
}
- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}
- (float)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] floatValue];
}
- (NSDictionary *)dictionaryValueForKey:(NSString *)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    NSObject *obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil;
}

- (NSDate *)dateValueForKey:(NSString *)key {
    id timeObject = [self objectForKey:key];
    
    if ([timeObject isKindOfClass:[NSNull class]] || timeObject == nil) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    
    NSDate *destDate = [dateFormatter dateFromString:timeObject];
    
    if (destDate == nil) {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        destDate = [dateFormatter dateFromString:timeObject];
    }
    
    return destDate;
}

- (time_t)timeValueForKey:(NSString *)key {
    return [self timeValueForKey:key defaultValue:0];
}

- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	id timeObject = [self objectForKey:key];
    if ([timeObject isKindOfClass:[NSNumber class]]) {
        NSNumber *n = (NSNumber *)timeObject;
        CFNumberType numberType = CFNumberGetType((CFNumberRef)n);
        NSTimeInterval t;
        if (numberType == kCFNumberLongLongType) {
            t = [n longLongValue] / 1000;
        }
        else {
            t = [n longValue];
        }
        return t;
    }
    else if ([timeObject isKindOfClass:[NSString class]]) {
        NSString *stringTime = timeObject;
        if (stringTime.length == 13) {
            long long llt = [stringTime longLongValue];
            NSTimeInterval t = llt / 1000;
            return t;
        }
        else if (stringTime.length == 10) {
            long long lt = [stringTime longLongValue];
            NSTimeInterval t = lt;
            return t;
        }
        else {
            if (!stringTime || (id)stringTime == [NSNull null]) {
                stringTime = @"";
            }
            struct tm created;
            time_t now;
            time(&now);
            
            if (stringTime) {
                if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
                    if (strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created) == NULL) {
                        strptime([stringTime UTF8String], "%Y-%m-%d %H:%M:%s", &created);
                    }
                }
                return mktime(&created);
            }
        }
    }
	return defaultValue;
}

- (long long)longLongValueValueForKey:(NSString *)key {
    return [self longLongValueValueForKey:key defaultValue:0];
}

- (long long)longLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (double)doubleValueValueForKey:(NSString *)key {
    return [self doubleValueValueForKey:key defaultValue:0];
}

- (double)doubleValueValueForKey:(NSString *)key defaultValue:(double)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] doubleValue];
}

- (NSString *)stringValueForKey:(NSString *)key {
    return [self stringValueForKey:key defaultValue:nil];
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    if ([self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]) {
        return defaultValue;
    }
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    }
    return result;
}

- (NSArray *)arrayObjectForKey:(NSString *)key
                  defaultValue:(NSArray *)defaultValue {
    id obj = [self objectForKey:key];
	return obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSArray class]]
    ? defaultValue : obj;
}

- (NSArray *)arrayObjectForKey:(NSString *)key  {
    return [self arrayObjectForKey:key defaultValue:nil];
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key
                            defaultValue:(NSDictionary *)defaultValue {
    id obj = [self objectForKey:key];
	return obj == nil || obj == [NSNull null] || ![obj isKindOfClass:[NSDictionary class]]
    ? defaultValue : obj;
}

- (NSDictionary *)dictionaryObjectForKey:(NSString *)key {
    return [self dictionaryObjectForKey:key defaultValue:nil];
}

@end
