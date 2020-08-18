//
//  AppDelegate.m
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Action.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initAppdelegate:launchOptions newSelf:self];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setUpRootVC]; //跟控制器判断
//    [EntireManageMent removeCacheWithName:WEB_History_Cache];
//    [[TimeManager timeManager] deleteDayAllManage];
//    [[HistoryManager historyManager] deleteHISAllManage];
    return YES;
}



@end
