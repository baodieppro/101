//
//  GSNotificationManager.m
//  OnlyFreshFamily
//
//  Created by 巩少鹏 on 2020/7/29.
//  Copyright © 2020 巩少鹏. All rights reserved.
//

#import "GSNotificationManager.h"
#import "LocalPushCenter.h"

@implementation GSNotificationManager

+(void)registerForRemoteNotifications{
    [LocalPushCenter creactUNUserNotificationCenter:self];
}
+(void)starPushType:(NSString *)time
              title:(NSString *)title body:(NSString *)body
             forKey:(NSString *)key
           Complete:(nonnull void (^)(void))complete
             failed:(nonnull void (^)(void))failed
{
//    NSInteger pushTime = [self dateWithTimeInterval:@"2020-07-31 14:40:58"];
    NSInteger pushTime = [self dateWithTimeInterval:time];
    NSString *notificationKey = [NSString stringWithFormat:@"DownLoad_%@",key];
    [LocalPushCenter setNotificationTypeNoneComplete:^{
        
            [LocalPushCenter localPushForDate:pushTime forKey:notificationKey title:title alertBody:body alertAction:@"" soundName:@"" launchImage:@"log_img" userInfo:@{@"pushType":@"1",@"NotificationKey":notificationKey,@"cancancelKey":key} badgeCount:1 repeatInterval:0 complete:^{
                GSLog(@"推送成功了");
                complete();
            }];
 
        
    } failed:^{
        [CCGSAlertView initWithTitle:@"提示" subTitle:@"通知功能还未开启，如果要打开提醒功能，请前往设置中心" sureBtn:@"确定" cancleBtn:@"取消" Complete:^(NSInteger index) {
            if (index == 1) {
                [self switchButtonClicked];
            }
        }];
    }];

}
+(void)starPushTime:(NSString *)time{
    NSInteger pushTime = [self dateWithTimeInterval:time];
    NSString *notificationKey = [NSString stringWithFormat:@"XSQG_%@",time];
    [LocalPushCenter setNotificationTypeNoneComplete:^{
        [LocalPushCenter localPushForDate:[GSTimeTools setDateYYMMDDHHSSMM:time] alertTime:pushTime forKey:notificationKey title:@"限时抢购即将开始" alertBody:@"你关注的限时抢购即将开始,快来抢购吧！" alertAction:@"" soundName:@"" launchImage:@"log_img" userInfo:@{@"pushType":@"1",@"NotificationKey":notificationKey} badgeCount:1 repeatInterval:0 complete:^{
                GSLog(@"推送成功了");
            }];
  
        
    } failed:^{
        [CCGSAlertView initWithTitle:@"提示" subTitle:@"通知功能还未开启，如果要打开提醒功能，请前往设置中心" sureBtn:@"确定" cancleBtn:@"取消" Complete:^(NSInteger index) {
            if (index == 1) {
                [self switchButtonClicked];
            }
        }];
    }];
}
//获取时间差 ：当前时间 与 结束时间
+(NSInteger)dateWithTimeInterval:(NSString *)time{
    return [GSTimeTools timeIntervalStartTime:[GSTimeTools getCurrentTimes] endTime:time];
}
+ (void)switchButtonClicked {
    // 跳转到系统设置
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:settingURL options:[NSDictionary dictionary] completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}
+(void)cancancelAllLocalPush{
    [LocalPushCenter cancelAllLocalPhsh];
}
+(void)cancancelLocalPushKey:(NSString *)key{
    [LocalPushCenter cancelLocalPhshKey:[NSString stringWithFormat:@"XSQG_%@",key]];
}
@end
