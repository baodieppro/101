//
//  ToolscreenShot.h
//  ToolscreenShot
//
//  Created by 巩小鹏 on 2018/9/4.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//



#import <Foundation/Foundation.h>


@interface ToolscreenShot : NSObject
@property (nonatomic,strong) NSString * qrCodeStr;
/**
 *  初始化
 *
 *  @instancetype 单利方式使用工具
 *
 */
+(instancetype)screenShot;
/**
 *  初始化
 *
 *  @void addScreenShotNotification       添加截屏监听
 *
 */
- (void)addScreenShotNotification;
/**
 *  初始化
 *
 *  @void removeScreenShotNotification     移除截屏监听
 *
 */
- (void)removeScreenShotNotification;

@end
