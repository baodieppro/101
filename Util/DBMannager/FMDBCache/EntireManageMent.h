//
//  EntireManageMent.h
//  SuperSearch
//
//  Created by 巩小鹏 on 2018/4/16.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
//模型
#import "GS_CacheModel.h"
#import "ConfigModel.h"

//SQL
#import "GS_CacheManager.h"
#import "GS_ConfigManager.h"

@interface EntireManageMent : NSObject
/**
 * 数据缓存操作
 */
//是否有缓存
+(BOOL)isExisedManager:(NSString *)type;
//增加
+(void)addCacheName:(NSString *)type jsonString:(NSString *)json updataTime:(NSString *)time;
//读取
+(NSString *)readCacheDataWithName:(NSString *)name;
//修改
+(void)updataCacheName:(NSString *)type jsonString:(NSString *)json updataTime:(NSString *)time;
//删除
+(void)removeCacheWithName:(NSString *)name;

/**
 * 配置缓存操作
 */
+(BOOL)isExisedConfigManager:(NSString *)key;
+(void)addConfigKey:(NSString *)configKey configvalue:(NSString *)configvalue updataTime:(NSString *)time;
+(void)removeConfigWithKey:(NSString *)key;
+(void)updataConfigKey:(NSString *)configKey configvalue:(NSString *)configvalue updataTime:(NSString *)time;
+(NSString *)readConfigDataWithConfigKey:(NSString *)configKey;
/**
 * HistoryLoans 数据
 */
+(void)addHistoryId:(NSString *)Id jsonString:(NSString *)json updataTime:(NSString *)time;

+(void)removeHistoryId:(NSString *)Id;

+(void)updataHistoryId:(NSString *)Id jsonString:(NSString *)json updataTime:(NSString *)time;

+(NSArray *)readLoansDataWithName:(NSString *)name;

+(NSArray *)readHistoryLoansData;

//==========================================================================================================

//生成json文件
+ (NSString *)onjson:(NSDictionary *)dict;
//增加了去空格和特殊符号操作
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict;
//数组转Json
+(NSString *)arrTransformString:(NSArray *)arr;
//Json转数组
+(NSArray *)strTransformArr:(NSString *)str;
//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//json数组字符串转字典
+(NSDictionary *)dictionaryWithformJsonArr:(NSString *)str;
//二进制串转字典
+(NSDictionary *)dictionaryWithData:(id)responseObject;
//model转字典
+(NSDictionary *)dicFromObject:(NSObject *)object;

@end
