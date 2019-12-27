//
//  NSDictionary+Additions.m
//  CCQMEnglish
//
//  Created by Kean on 2019/10/29.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)
- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue boolValue];
    } else {
        @try {
            return [tmpValue boolValue];
        }
        @catch (NSException *exception) {
            return defaultValue;
        }
    }
}

- (NSInteger)integerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]])
    {
        return [tmpValue integerValue];
    }
    else
    {
        @try
        {
            return [tmpValue integerValue];
        }
        @catch (NSException *exception)
        {
            return defaultValue;
        }
    }
}

- (CGFloat)floatValueForKey:(NSString *)key defaultValue:(CGFloat)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue floatValue];
    } else {
        @try {
            return [tmpValue floatValue];
        }
        @catch (NSException *exception) {
            return defaultValue;
        }
    }
}

- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
    NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}

- (long long)longLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null]) {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSNumber class]]) {
        return [tmpValue longLongValue];
    } else {
        @try {
            return [tmpValue longLongValue];
        }
        @catch (NSException *exception) {
            return defaultValue;
        }
    }
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSString class]])
    {
        return [NSString stringWithString:tmpValue];
    }
    else
    {
        @try
        {
            return [NSString stringWithFormat:@"%@",tmpValue];
        }
        @catch (NSException *exception)
        {
            return defaultValue;
        }
    }
}

- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSArray class]])
    {
        return tmpValue;
    }
    else
    {
        return defaultValue;
    }
}

- (NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSDictionary class]])
    {
        return tmpValue;
    }
    else
    {
        return defaultValue;
    }
}

- (NSString *)welfareCenterStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id tmpValue = [self objectForKey:key];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        return defaultValue;
    }
    
    if ([tmpValue isKindOfClass:[NSString class]])
    {
        if ([tmpValue isEqualToString:@""]) {
            return @"-";
        }else {
            return [NSString stringWithString:tmpValue];
        }

    }
    else
    {
        @try
        {
            NSString *welfareCenterString = [NSString stringWithFormat:@"%@",tmpValue];
            if ([welfareCenterString isEqualToString:@""]) {
                return @"-";
            }else {
                return welfareCenterString;
            }

        }
        @catch (NSException *exception)
        {
            return defaultValue;
        }
    }
}
@end
