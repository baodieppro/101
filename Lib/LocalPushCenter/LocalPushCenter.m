//
//  LocalPushCenter.m
//  LocalPush
//
//  Created by zhuochenming on 3/11/16.
//  Copyright (c) 2016 zhuochenming. All rights reserved.
//

#import "LocalPushCenter.h"
#import <UserNotifications/UserNotifications.h>

@implementation LocalPushCenter

+ (NSDate *)fireDateWithWeek:(NSInteger)week
                        hour:(NSInteger)hour
                      minute:(NSInteger)minute
                      second:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    
    unsigned currentFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *component = [calendar components:currentFlag fromDate:[NSDate date]];
    
    if (week != 0) {
        component.weekday = week;
    }else{
        component.weekday = [self getWeekDayFordate];
    }
    if (hour) {
        component.hour = hour;
    }
    
    if (minute) {
        component.minute = minute;
    }
    if (second) {
        component.second = second;
    } else {
        component.second = 0;
    }
    
     return [[calendar dateFromComponents:component] dateByAddingTimeInterval:0];
}
+ (NSInteger)getWeekDayFordate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday] - 1;

}

+(void)creactUNUserNotificationCenter:(id)mySelf
{
    // 使用 UNUserNotificationCenter 来管理通知
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    //监听回调事件
//    center.delegate = mySelf;
//
//    //iOS 10 使用以下方法注册，才能得到授权
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
//                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                              // Enable or disable features based on authorization.
//                          }];
//
//    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//
//        GSLog(@"");
//    }];
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册通知成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//                    [self registerNotification:5];
                }];
            } else {
                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        //注册推送（同iOS8）
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

}
/** * 描述 使用 UNNotification 本地通知(iOS 10) * @param alerTime 多长时间后进行推送 **/
+(void)registerNotification:(NSInteger)alerTime
{
    // 1、创建通知内容，注：这里得用可变类型的UNMutableNotificationContent，否则内容的属性是只读的
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    // 标题
    content.title = @"这是通知";
    // 次标题
    content.subtitle = @"这是通知subtitle";
    // 内容
    content.body = @"这是通知body这是通知body这是通知body这是通知body这是通知body这是通知body";
    
    // app显示通知数量的角标
    content.badge = [NSNumber numberWithInteger:4];
    
    // 通知的提示声音，这里用的默认的声音
    content.sound = [UNNotificationSound defaultSound];
//    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"log_img" withExtension:@"png"];
//    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
//    // 附件 可以是音频、图片、视频 这里是一张图片
//    content.attachments = @[attachment];
    // 标识符
    content.categoryIdentifier = @"categoryIndentifier";
    // 2、创建通知触发
    /* 触发器分三种： UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60 UNCalendarNotificationTrigger : 在某天某时触发，可重复 UNLocationNotificationTrigger : 进入或离开某个地理区域时触发 */
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    //    NSDateComponents *components = [NSDateComponents new];
    //    components.second = 2.0f;
    //    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    // 3、创建通知请求
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
    // 4、将请求加入通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"已成功加推送%@",notificationRequest.identifier);
        }
    }];
}


#pragma mark - 本地推送
+ (void)localPushForDate:(NSInteger)alertTime
                  forKey:(NSString *)key
                   title:(NSString *)title
               alertBody:(NSString *)alertBody
             alertAction:(NSString *)alertAction
               soundName:(NSString *)soundName
             launchImage:(NSString *)launchImage
                userInfo:(NSDictionary *)userInfo
              badgeCount:(NSUInteger)badgeCount
          repeatInterval:(NSCalendarUnit)repeatInterval
                complete:(void (^)(void))complete{
    [self localPushForDate:nil alertTime:alertTime forKey:key title:title alertBody:alertBody alertAction:alertAction soundName:soundName launchImage:launchImage userInfo:userInfo badgeCount:badgeCount repeatInterval:repeatInterval complete:complete];
}
+ (void)localPushForDate:(NSDate *)date
               alertTime:(NSInteger)alertTime
                  forKey:(NSString *)key
                   title:(NSString *)title
               alertBody:(NSString *)alertBody
             alertAction:(NSString *)alertAction
               soundName:(NSString *)soundName
             launchImage:(NSString *)launchImage
                userInfo:(NSDictionary *)userInfo
              badgeCount:(NSUInteger)badgeCount
          repeatInterval:(NSCalendarUnit)repeatInterval
                complete:(void (^)(void))complete{
    

    if ([[IphoneType phoneVersion] floatValue] >= 10.0) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        if (title) {
            content.title = title;
        }else{
            content.title = @"壹家生鲜";
        }
        content.body = alertBody;
        if (soundName) {
            content.sound = [UNNotificationSound soundNamed:soundName];
        }else{
            content.sound = [UNNotificationSound defaultSound];
        }
        content.userInfo = userInfo;
        
        if (badgeCount) {
            content.badge = @(badgeCount);
        }else{
            
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (badge > 0) {
                badgeCount = badge + 1;
            }

            content.badge = @(badgeCount);
        }
        content.categoryIdentifier = key;
        UNNotificationRequest* request ;
        if (date) {
            NSDateComponents * components = [[NSCalendar currentCalendar]
                                             components:NSCalendarUnitHour |
                                             NSCalendarUnitMinute |
                                             NSCalendarUnitSecond
                                             fromDate:date];
            //repeats: 设置是否重复
            UNCalendarNotificationTrigger * trigger = [UNCalendarNotificationTrigger
                                                        triggerWithDateMatchingComponents:components
                                                        repeats:YES];
            request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:trigger];

        }else{
            // 在 alertTime 后推送本地推送
            UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                          triggerWithTimeInterval:alertTime repeats:NO];
            
            request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:trigger];
        }
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                //推送失败
            }else{
                complete();
            }
        }];
        
    }else{
    
    
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];

        if (!localNotification) {
            return;
        }
        
//        [self cancleLocalPushWithKey:key];
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        // 设置推送 显示的内容
        localNotification.alertBody        = alertBody;
        localNotification.alertAction      = alertAction;
        localNotification.alertLaunchImage = launchImage;
        // 不设置此属性，则默认不重复
        localNotification.repeatInterval   = repeatInterval;
    } else {
        localNotification.alertBody        = alertBody;
        localNotification.alertAction      = alertAction;
        localNotification.alertLaunchImage = launchImage;
        // 不设置此属性，则默认不重复
        localNotification.repeatInterval   = repeatInterval;
    }
        //Sound// 通知被触发时播放的声音
        if (soundName) {
            localNotification.soundName = soundName;
        } else {
            localNotification.soundName = UILocalNotificationDefaultSoundName;
        }
        
        localNotification.applicationIconBadgeNumber = badgeCount;
        localNotification.userInfo = userInfo;
        
        if (!fireDate) {
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        } else {
            localNotification.fireDate = fireDate;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        complete();
}
 
    
}

#pragma mark - 退出

+(void)cancelLocalPhshKey:(NSString *)key
{
    __kWeakSelf__;
    [LocalPushCenter setNotificationTypeNoneComplete:^{
        [weakSelf cancleLocalPushWithKey:key];
    } failed:^{
        
    }];
}

+ (void)cancelAllLocalPhsh {
    if ([[IphoneType phoneVersion] floatValue] >= 10.0) {
        // 移除已展示过的通知
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
        // 取消还未发送的通知
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

+ (void)cancleLocalPushWithKey:(NSString *)key {
    if ([[IphoneType phoneVersion] floatValue] >= 10.0) {
        [self cancelAllLocalPhsh];
    }else{
        NSArray *notiArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        if (notiArray) {
            for (UILocalNotification *notification in notiArray) {
                NSDictionary *dic = notification.userInfo;
                if (dic) {
                    for (NSString *key in dic) {
                        if ([key isEqualToString:key]) {
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                }
            }
        }

    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

+(void)setNotificationTypeNoneComplete:(void (^)())complete failed:(void (^)())failed
{
    if ([[IphoneType phoneVersion] floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            GSLog(@"推送关闭");
            failed();
        }else{
            GSLog(@"推送打开");
            complete();
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            GSLog(@"推送关闭");
            failed();
        }else{
            GSLog(@"推送打开");
            complete();
        }
    }
}

+(void)applicationIconBadgeNumber:(NSInteger)number
{
    
    if (number > 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = number;
    }else{
        if ([self isBadge] == YES) {
            NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
            badge--;
            badge = badge >= 0 ? badge : 0;
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
        }else{
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
    }
}

+(BOOL)isBadge
{
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge <=0) {
        return NO;
    }
    return YES;
}


@end
