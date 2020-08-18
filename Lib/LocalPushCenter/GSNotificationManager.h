//
//  GSNotificationManager.h
//  OnlyFreshFamily
//
//  Created by 巩少鹏 on 2020/7/29.
//  Copyright © 2020 巩少鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSNotificationManager : NSObject
//注册通知
+(void)registerForRemoteNotifications;
//只提醒一次
+(void)starPushType:(NSString *)time
              title:(NSString *)title body:(NSString *)body
             forKey:(NSString *)key
           Complete:(nonnull void (^)(void))complete
             failed:(nonnull void (^)(void))failed;
//每天都提醒
+(void)starPushTime:(NSString *)time;
//取消所有通知
+(void)cancancelAllLocalPush;
+(void)cancancelLocalPushKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
