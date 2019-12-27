//
//  WLNetworking.m
//
//
//  Created by ikuaishou on 15/11/25.
//  Copyright © 2015年 wanglei. All rights reserved.
//

#import "WLNetworking.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation WLNetworking

+ (WLNetworkReachabilityStatus)networkStatus
{
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            
            return WLNetworkReachabilityStatusReachableViaWWAN4G;
            
        } else if ([typeStrings3G containsObject:accessString]) {
            
            return WLNetworkReachabilityStatusReachableViaWWAN3G;
            
        } else if ([typeStrings2G containsObject:accessString]) {
            
            return WLNetworkReachabilityStatusReachableViaWWAN2G;
            
        } else {
            return WLNetworkReachabilityStatusUnknown;
        }
    } else {
        return WLNetworkReachabilityStatusUnknown;
    }
}


+ (void)monitoringReachabilityStatus:(void (^)(WLNetworkReachabilityStatus))statusBlock {
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //当前网络改变了就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
//        if (status){

            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
//                    NSLog(@"未知网络");
                   statusBlock(WLNetworkReachabilityStatusUnknown);
                    break;
                case AFNetworkReachabilityStatusNotReachable:
//                    NSLog(@"网络不可达");
                    statusBlock(WLNetworkReachabilityStatusNotReachable);
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
//                    NSLog(@"GPRS网络");
                    statusBlock([self networkStatus]);
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
//                    NSLog(@"wifi网络");
                    statusBlock(WLNetworkReachabilityStatusReachableViaWiFi);
                    break;
                default:
                    break;
            }
//        }
    }];
    //开始监控
    [mgr startMonitoring];
}

+ (void)stopMonitoring{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr stopMonitoring];
}


@end
