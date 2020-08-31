//
//  AppDelegate+Action.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/14.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "AppDelegate+Action.h"
#import "PlayViewController.h"
#import "HybridNSURLProtocol.h"
#import "WebViewController.h"
#import "BaseNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate (Action)
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *root = self.window.rootViewController;
    root.definesPresentationContext = YES;
    //设置模态视图弹出样式
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([root isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navRoot = (UINavigationController *)root;
        
        [navRoot.topViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabRoot = (UITabBarController *)root;
        UIViewController *tabSelect = tabRoot.selectedViewController;
        if ([tabSelect isKindOfClass:[UINavigationController class]]) {
            UINavigationController *tabSelectNav = (UINavigationController *)tabSelect;
            
            [tabSelectNav.topViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
        }else {
            [tabSelect presentViewController:viewControllerToPresent animated:flag completion:completion];
        }
    }else {
        [root presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)flag {
    UIViewController *root = self.window.rootViewController;
    if ([root isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navRoot = (UINavigationController *)root;
        
        [navRoot pushViewController:vc animated:flag];
    }else if ([root isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabRoot = (UITabBarController *)root;
        UIViewController *tabSelect = tabRoot.selectedViewController;
        if ([tabSelect isKindOfClass:[UINavigationController class]]) {
            UINavigationController *tabSelectNav = (UINavigationController *)tabSelect;
            
            [tabSelectNav pushViewController:vc animated:flag];
        }else if ([tabSelect isKindOfClass:UIViewController.class]){
            UINavigationController * nav = nil;
            for (UIViewController  * viewController in tabSelect.childViewControllers) {
                if ([viewController isKindOfClass:UINavigationController.class]) {
                    nav = (UINavigationController *)viewController;
                    break;
                }
            }
            if (nav) {
                [nav pushViewController:vc animated:YES];
            }
        }
    }
}
-(void)initAppdelegate:(NSDictionary *)launchOptions newSelf:(id)newSelf{
    [self newAllNotification];
    [GSUMShare newGSUMShare];
    [LBManager newLBManager];
    [DownLoadManager initConfig:@"GSDownLoad"];
    [[ToolscreenShot screenShot] addScreenShotNotification];
    [NSURLProtocol registerClass:[HybridNSURLProtocol class]];
    [self createUMNotification:launchOptions];
    [[SetConfigManager sharedManager] initManager];
}
#pragma mark - 根制器
- (void)setUpRootVC
{
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:[[WebViewController alloc] init]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
}

#pragma mark - 通知

-(void)newAllNotification{
    //通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginNotification:) name:NEED_PUSH_LOGIN_NOTIFICATION object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushOpenShopNotification:) name:NEED_OPEN_SHOP_NOTIFICATION object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSelectIndustryNotification:) name:NEED_SELECT_IndustryId_NOTIFICATION object:nil];
}

-(void)pushLoginNotification:(NSNotification *)notification{
    GSLog(@"接收到登录通知了");
//    [self presentLogin];
    
}
//注册推送
-(void)createUMNotification:(NSDictionary*)launchOptions{
    
//    //设置 AppKey 及 LaunchOptions
//    [UMessage startWithAppkey:@"57e372ff67e58e4f810002e0" launchOptions:launchOptions];
//    //注册通知
//    [UMessage registerForRemoteNotifications];
//    [UMessage setBadgeClear:NO];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
            GSLog(@"点击允许");
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            GSLog(@"点击不允许");
            
        }
    }];
        
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
        [GSNotificationManager registerForRemoteNotifications];

    }else
    {
        //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
         UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
         action1.identifier = @"action1_identifier";
         action1.title=@"打开应用";
         action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
         
         UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
         action2.identifier = @"action2_identifier";
         action2.title=@"忽略";
         action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
         action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
         action2.destructive = YES;
         UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
         actionCategory1.identifier = @"category1";//这组动作的唯一标示
         [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
         NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        [GSNotificationManager registerForRemoteNotifications];
    }
    //打开日志，方便调试
//    [UMessage setLogEnabled:NO];
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    NSString * psuh_deviceToken = [self stringDevicetoken:deviceToken];
    GSLog(@"deviceToken:%@",psuh_deviceToken);
    [DEFAULTS setValue:psuh_deviceToken forKey:@"push_deviceToken"];
    [DEFAULTS synchronize];
//    [[GSIMManager defaultManager] setDeviceToken:deviceToken];
//    // 更新界面
//        [UMessage registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error); // 没有回调
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];


}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    //    UNNotificationRequest *request = notification.request; // 收到推送的请求
    //    UNNotificationContent *content = request.content; // 收到推送的消息内容
    //    NSNumber *badge = content.badge;  // 推送消息的角标
    //    NSString *body = content.body;    // 推送消息体
    //    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    //    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    //    NSString *title = content.title;  // 推送消息的标题

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
//        //关闭友盟自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        [self pushUserNotification:userInfo applicationState:[UIApplication sharedApplication].applicationState];

    }else{
        //应用处于前台时的本地推送接受

        [self pushUserNotification:userInfo applicationState:[UIApplication sharedApplication].applicationState];

    }

    //    [AdvertisingPushTool countDownAddNotificationRequestIsStop:YES];
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        [self pushUserNotification:userInfo applicationState:[UIApplication sharedApplication].applicationState];
    }else{
        //应用处于后台时的本地推送接受
        [self pushUserNotification:userInfo applicationState:[UIApplication sharedApplication].applicationState];
    }
//    NSInteger badge = [response.notification.request.content.badge integerValue];
//    badge--;
//    badge = badge >= 0 ? badge : 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

//iOS10以前接收的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
//    [UMessage sendClickReportForRemoteNotification:userInfo];
    //下面写identifier对各个交互式的按钮进行业务处理
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    GSLog(@"通知成功");
    NSDictionary *dic = notification.userInfo;
    GSLog(@"通知——userInfo:%@",dic);

    // 这里真实需要处理交互的地方
    // 获取通知所带的数据

    [self pushUserNotification:dic applicationState:application.applicationState];

    //    __kWeakSelf__;

    // 更新显示的徽章个数

}
#pragma mark - 私有方法
-(NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSMutableString *deviceTokenString = [NSMutableString string];
    if (@available(iOS 13.0, *)) {
        const char *bytes = deviceToken.bytes;
        NSInteger count = deviceToken.length;
        for (int i = 0; i < count; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
    } else {

        deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""]stringByReplacingOccurrencesOfString: @" " withString: @""];
    }


    return deviceTokenString;
}

#pragma mark - 推送跳转目标页

-(void)pushUserNotification:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState {
    __kWeakSelf__;
   // jumpType 0；不跳 1:账号列表 2:商品详情 3:订单详情

    if (userInfo != nil) {
        NSString *pushType = [userInfo objectForKey:@"pushType"];
//        NSString *notificationKey = [userInfo objectForKey:@"NotificationKey"];
        NSString *cancancelKey = [userInfo objectForKey:@"cancancelKey"];

        if ([pushType integerValue] == 1) {
            if(applicationState == UIApplicationStateActive)
               {
                   GSLog(@"前台");
                   [__kAppDelegate__.window gs_showTextHud:@"下载完成"];
               }

               if (applicationState == UIApplicationStateInactive) {
                   GSLog(@"后台");
                   [__kAppDelegate__.window gs_showTextHud:@"下载完成"];
//                   [weakSelf pushFlashSaleVC];
//                   PlayViewController * playVC = [[PlayViewController alloc]init];
//                   __kAppDelegate__.allowRotation = YES;//关闭横屏仅允许竖屏
//                   playVC.playUrl = cancancelKey;
//                   [self presentViewController:playVC animated:NO completion:nil];
               }
        }
            [GSNotificationManager cancancelLocalPushKey:cancancelKey];
            [self removeBadge];
        }

}
-(void)removeBadge{
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}
@end
