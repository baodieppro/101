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
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self app_init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[WebViewController alloc] init]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.rootViewController = [[WebViewController alloc] init];
//    [self.window makeKeyAndVisible];
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
    return YES;
}
-(void)app_init{
    [GSUMShare newGSUMShare];
    [LBManager newLBManager];
    [DownLoadManager initConfig:@"GSDownLoad"];
    [[ToolscreenShot screenShot] addScreenShotNotification];
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
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
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放，若需要持续播放，还需要申请后台任务id，具体做法是：
    //    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    GSLog(@"applicationDidEnterBackground_程序进入后台");
    UIApplication* app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
  
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
