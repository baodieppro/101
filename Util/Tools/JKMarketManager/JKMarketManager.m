//
//  MarketManager.m
//  MT
//
//  Created by jianjie on 16/6/24.
//  Copyright © 2016年 jianjie. All rights reserved.
//

#import "JKMarketManager.h"
#import "sys/utsname.h"
#import <objc/runtime.h>

static NSString      *_deviceName;

@interface JKMarketManager ()

@property (nonatomic, assign) CGFloat nowDefuleWidth;

@end

@implementation JKMarketManager

static id _showJKMarketManagerInstance;
+ (instancetype)showJKMarketManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showJKMarketManagerInstance = [[[self class] alloc] init];
    });
    return _showJKMarketManagerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _deviceName = [self getIphoeXH:[self getCurrentDevice]];
        _nowDefuleWidth = DefuleWidth;
    }
    return self;
}

- (CGFloat)translationSize:(CGFloat)pxSize marketSizeType:(JKMarketSizeType)marketSizeType {
    CGFloat newPxSize = pxSize/2;
    CGFloat translationSize = 0;
    CGFloat marketSize = [self getSizeWithMarketSizeType:marketSizeType];
    
    //bool 是否竖屏
    //竖屏?[[UIScreen mainScreen] bounds].size.width == JKDefule35InchScreenWidth:[[UIScreen mainScreen] bounds].size.height == JKDefule35InchScreenWidth
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule35InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone 4"])
        {
            translationSize = JKDefule35InchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefule35InchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule40InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone 5"])
        {
            translationSize = JKDefule40InchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefule40InchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule47InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone 6"])
        {
            translationSize = JKDefule47InchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefule47InchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule55InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone 6 Plus"])
        {
            translationSize = JKDefule55InchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefule55InchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule58InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone X"])
        {
            translationSize = JKDefule58InchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefule58InchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule58InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone XR"])
        {
            translationSize = JKDefuleXRInchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefuleXRInchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    if ([[UIScreen mainScreen] bounds].size.width == JKDefule58InchScreenWidth)
    {
        if ([_deviceName isEqualToString:@"iPhone XS Max"])
        {
            translationSize = JKDefuleXMsInchScreenWidth/marketSize*newPxSize;
        }
        else
        {
            //放大模式(暂未考虑)
            translationSize = JKDefuleXMsInchScreenWidth/marketSize*newPxSize*EnlargingScale;
        }
    }
    
    return translationSize;
}

- (CGFloat)translationSize:(CGFloat)pxSize
{
//    if (ISIPAD) {
//        return pxSize;
//    }else if (iPhoneX_New == NO){
//        return pxSize/2;
//    }
    
    return [self translationSize:pxSize marketSizeType:DefuleWidth];
}

//获得设备型号
- (NSString *)getCurrentDevice
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"] ||
        [platform isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"] ||
        [platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"] ||
        [platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"] ||
        [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad pro
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPadPro";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPadPro";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPadPro";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPadPro";
    if ([platform isEqualToString:@"iPad6,11"] ||
        [platform isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"] ||
        [platform isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([platform isEqualToString:@"iPad7,3"] ||
        [platform isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    return @"Unknown";
}

- (NSString *)getIphoeXH:(NSString *)platform
{
    if ([platform hasPrefix:@"iPhone 4"] ||[platform hasPrefix:@"iPhone 4s"]){
        return @"iPhone 4";
    }else if([platform hasPrefix:@"iPhone 5"] || [platform hasPrefix:@"iPhone SE"] || [platform hasPrefix:@"iPhone 5c"] || [platform hasPrefix:@"iPhone 5s"]){
        return @"iPhone 5";
    }else if([platform hasPrefix:@"iPhone 6 Plus"] || [platform hasPrefix:@"iPhone6sPlus"] || [platform hasPrefix:@"iPhone 7 Plus"] || [platform hasPrefix:@"iPhone 8 Plus"]){
        return @"iPhone 6 Plus";
    }else if([platform hasPrefix:@"iPhone X"] || [platform hasPrefix:@"iPhone XS"]){
        return @"iPhone X";
    }else if([platform hasPrefix:@"iPhone XS Max"])
    {
        return @"iPhone XS Max";
    }else if([platform hasPrefix:@"iPhone XR"])
    {
        return @"iPhone XR";
    }else{
        return @"iPhone X";

    }
}

- (CGFloat)getSizeWithMarketSizeType:(JKMarketSizeType)marketSizeType {
    CGFloat size = 0;
    switch (marketSizeType) {
        case JKMarketSizeTypeFour:
        {
            size = JKDefule35InchScreenWidth;
        }
            break;
        case JKMarketSizeTypeSix:
        {
            size = JKDefule47InchScreenWidth;
        }
            break;
        case JKMarketSizeTypePlus:
        {
            size = JKDefule55InchScreenWidth;
        }
            break;
        case JKMarketSizeTypeX:
        {
            size = JKDefule58InchScreenWidth;
        }
            break;
        case JKMarketSizeTypeXR:
        {
            size = JKDefuleXRInchScreenWidth;
        }
        break;
        case JKMarketSizeTypeXMS:
        {
            size = JKDefuleXMsInchScreenWidth;
        }
        break;
        default:
            break;
    }
    return size;
}

@end
