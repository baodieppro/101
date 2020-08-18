//
//  HistoryData.h
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/14.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
//sql表
#import "HistoryManager.h"
#import "TimeManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryData : NSObject
//web 浏览历史
+(void)addHistoryData:(NSDictionary *)dict;
//当天时间存档
+(void)addTimeDay;
//当天阅读条数
+(NSInteger)readDayCount;
//总条数
+(NSInteger)allCount;

@end

NS_ASSUME_NONNULL_END
