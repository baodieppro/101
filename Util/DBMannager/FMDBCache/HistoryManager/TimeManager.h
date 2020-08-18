//
//  TimeManager.h
//  WebTest
//
//  Created by 巩小鹏 on 16/9/29.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "HistoryModel.h"

@interface TimeManager : NSObject

//非标准单例
+ (TimeManager *)timeManager;
//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)day;

//根据指定类型  查找所有的记录
- (NSArray *)readDayModelsWithRecord;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)day ;
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type;

//删除数据里的所有数据
-(void)deleteDayAllManage;

/**
 *  所有的历史day
 *
 *  @return day数组
 */
- (NSArray *)allDayArray;
- (NSArray *)allTimeArray;
@end
@interface TimeModel : NSObject

@property (nonatomic,copy) NSString * time;
@property (nonatomic,copy) NSString * day;

@end
