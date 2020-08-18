//
//  LocalPushCenter.h
//  LocalPush
//
//  Created by zhuochenming on 3/11/16.
//  Copyright (c) 2016 zhuochenming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPushCenter : NSObject

//是否打开推送
+(void)setNotificationTypeNoneComplete:(void (^)())complete failed:(void (^)())failed;

/*
 *  设置时间 week 星期几 1为周末2为周一
 *  hour 时
 *  minute 分
 *  second 秒
 */
+ (NSDate *)fireDateWithWeek:(NSInteger)week
                        hour:(NSInteger)hour
                      minute:(NSInteger)minute
                      second:(NSInteger)second;
//ios 10 推送注册方法
+(void)creactUNUserNotificationCenter:(id)mySelf;

//本地发送推送（先取消上一个 再push现在的）
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
                complete:(void (^)(void))complete;

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
                complete:(void (^)(void))complete;

#pragma mark - 退出
+(void)cancelLocalPhshKey:(NSString *)key;

+ (void)cancelAllLocalPhsh;

+ (void)cancleLocalPushWithKey:(NSString *)key;

+(void)applicationIconBadgeNumber:(NSInteger)number;

+(BOOL)isBadge;



@end
