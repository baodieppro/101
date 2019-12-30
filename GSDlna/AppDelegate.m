//
//  AppDelegate.m
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "HybridNSURLProtocol.h"
#import "WebViewController.h"
#import "BaseNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LBManager newLBManager];
    [DownLoadManager initConfig:@"GSDownLoad"];
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[WebViewController alloc] init]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[WebViewController alloc] init];
//    [self.window makeKeyAndVisible];
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
        
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {

    GSLog(@"applicationWillResignActive_程序取消激活状态");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    GSLog(@"applicationDidEnterBackground_程序进入后台");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    GSLog(@"applicationWillEnterForeground_程序进入前台")
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(pasteboard.URL != nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:NEED_PUSH_Pasteboard_NOTIFICATION object:@{@"url":[pasteboard.URL absoluteString]}];
    }
    GSLog(@"剪切板url：%@",pasteboard.URL);
//    GSLog(@"剪切板string：%@",pasteboard.string);
    GSLog(@"applicationDidBecomeActive_程序被激活");
}


- (void)applicationWillTerminate:(UIApplication *)application {

    GSLog(@"applicationWillTerminate_程序终止");
}


@end
