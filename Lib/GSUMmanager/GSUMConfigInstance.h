//
//  UMConfigInstance.h
//  DSBrowser
//
//  Created by 巩小鹏 on 2016/11/24.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMAnalytics/MobClick.h>

@interface GSUMConfigInstance : NSObject
//注册UM统计
+(void)newGSUMConfigInstance;
//指定事件统计
+(void)newGSmobClickEcentID:(NSString *)clickEventId typeName:(NSString *)name quantityTitle:(NSString *)title;
//详细事件统计
+(void)newGSmobClickEcentID:(NSString *)clickEventId dict:(NSDictionary *)dict;
//第三方账号统计
+(void)newGSprofileSignInWithPUID:(NSString *)puid name:(NSString *)name;
//事件统计
+(void)newGSevent:(NSString *)eventId;
//页面统计开始
+(void)newBeginLogPageView:(NSString *)viewName;
//页面统计结束
+(void)newEndLogPageView:(NSString *)viewName;
@end
