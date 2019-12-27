//
//  CheckNetwork.m
//  DSBrowser
//
//  Created by 巩小鹏 on 2016/10/13.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import "CheckNetwork.h"
#import "WLNetworking.h"
//#import "PopStr.h"

@implementation CheckNetwork

-(instancetype)initCheckNetwork{
    if (self = [super init]) {
        self = [[CheckNetwork alloc]init];
    }
    return self;
}
//检查网络
+(void)checkNetwork:(BOOL)isPop{
    static NSString * popStr;
    [WLNetworking monitoringReachabilityStatus:^(WLNetworkReachabilityStatus statusBlock) {
        switch (statusBlock) {
            case WLNetworkReachabilityStatusUnknown:
            {
                popStr = [NSString stringWithFormat:@"未知网络"];
            }
                break;
            case WLNetworkReachabilityStatusNotReachable:
            {
                popStr = [NSString stringWithFormat:@"无网络"];
            }
                break;
            case WLNetworkReachabilityStatusReachableViaWWAN:
            {
                popStr = [NSString stringWithFormat:@"当前正在使用非WIFI网络，可能会产生流量费用"];
            }
                break;
            case WLNetworkReachabilityStatusReachableViaWiFi:
            {
                popStr = [NSString stringWithFormat:@"当前使用的网络是WI—FI"];
            }
                break;
            case WLNetworkReachabilityStatusReachableViaWWAN2G:
            {
                popStr = [NSString stringWithFormat:@"当前正在使用非WIFI网络(2G)，可能会产生流量费用"];
            }
                break;
            case WLNetworkReachabilityStatusReachableViaWWAN3G:
            {
                popStr = [NSString stringWithFormat:@"当前正在使用非WIFI网络(3G)，可能会产生流量费用"];
            }
                break;
            case WLNetworkReachabilityStatusReachableViaWWAN4G:
            {

                popStr = [NSString stringWithFormat:@"当前正在使用非WIFI网络(4G)，可能会产生流量费用"];

            }
                break;
                
            default:
                break;
        }
      
        if(statusBlock != WLNetworkReachabilityStatusNotReachable){
            GSLog(@"有网玩了");
            [self setNSNotificationCenter_postNotificationName:@"NEED_STATUS_NETWORK_NOTIFICATION"];

        }else{
            GSLog(@"没有网");
            [self setNSNotificationCenter_postNotificationName:@"NEED_NO_NETWORK_NOTIFICATION"];
        }
        
        if (isPop == YES) {
       
            }
    }];
}
+(void)setNSNotificationCenter_postNotificationName:(NSString *)name{
//    NSLog(@"Thread:%@",[NSThread currentThread]);
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
//    }];
    [WLNetworking stopMonitoring];
}

+ (void)isFirstApp{
    //判断是否为第一次启动，若为第一次启动则执行引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        NSLog(@"first launch第一次程序启动");
//        [[NSNotificationCenter defaultCenter] postNotificationName:NEED_REQUESTDATA_FIRSTAPP_NOTIFICATION object:nil];

        //这里进入引导画面
    }else {
//        NSLog(@"second launch再次程序启动");
        ////直接进入主界面
    }
}

@end


