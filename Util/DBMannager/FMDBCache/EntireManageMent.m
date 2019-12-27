//
//  EntireManageMent.m
//  SuperSearch
//
//  Created by 巩小鹏 on 2018/4/16.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import "EntireManageMent.h"

@implementation EntireManageMent
+(NSString *)getHistorySerctionTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //    [formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //    [formatter setDateFormat:@" hh:mm:ss -- SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    GSLog(@"%@", timeNow);
    return timeNow;
}
//============================================================================================================
//缓存

+(BOOL)isExisedManager:(NSString *)type
{
    return  [[GS_CacheManager cacheManager] isExistAppForType:type];
}


+(void)addCacheName:(NSString *)type jsonString:(NSString *)json updataTime:(NSString *)time{
    BOOL _isExised;
    GS_CacheModel * model = [[GS_CacheModel alloc]init];
    model.type = type?:@"";
    model.jsonStr = json?:@"";
    model.updateTime = time?:[self getHistorySerctionTimeNow];;
    _isExised = [[GS_CacheManager cacheManager] isExistAppForType:type];
    if (_isExised) {
        GSLog(@"更新Cache %@",type);
        [self updataCacheName:type jsonString:json updataTime:time];
    }else{
        GSLog(@"添加Cache %@",type);
        [[GS_CacheManager cacheManager] insertModel:model];
    }
}
+(void)removeCacheWithName:(NSString *)name{
  [[GS_CacheManager cacheManager] deleteModelForType:name];
}
+(void)updataCacheName:(NSString *)type jsonString:(NSString *)json updataTime:(NSString *)time{
    GS_CacheModel * model = [[GS_CacheModel alloc]init];
    model.type = type?:@"";
    model.jsonStr = json?:@"";
    model.updateTime = time?:@"";
    [[GS_CacheManager cacheManager] updataExistNewModel:model complete:^{
        GSLog(@"缓存更新成功");
    } failed:^{
        GSLog(@"缓存更新失败");
    }];
}
+(NSString *)readCacheDataWithName:(NSString *)name{
  return  [[GS_CacheManager cacheManager] readWithRecord:name];
}


//============================================================================================================
//配置
+(BOOL)isExisedConfigManager:(NSString *)key
{
    return  [[GS_ConfigManager configManager] isExistAppForconfigkey:key];
}

+(void)addConfigKey:(NSString *)configKey configvalue:(NSString *)configvalue updataTime:(NSString *)time{
    BOOL _isExised;
    ConfigModel * model = [[ConfigModel alloc]init];
    model.configkey = configKey?:@"";
    model.configvalue = configvalue?:@"";
    model.updateTime = time?:[self getHistorySerctionTimeNow];;
    _isExised = [[GS_ConfigManager configManager]  isExistAppForconfigkey:configKey];
    if (_isExised) {
        GSLog(@"更新");
        [self updataConfigModel:model];
    }else{
        GSLog(@"添加Cache");
        [[GS_ConfigManager configManager] insertConfigModel:model];
    }
}

+(void)removeConfigWithKey:(NSString *)key{
    [[GS_ConfigManager configManager]  deleteModelForconfigkey:key];
}

+(void)updataConfigKey:(NSString *)configKey configvalue:(NSString *)configvalue updataTime:(NSString *)time{
    ConfigModel * model = [[ConfigModel alloc]init];
    model.configkey = configKey?:@"";
    model.configvalue = configvalue?:@"";
    model.updateTime = time?:@"";
    [self updataConfigModel:model];
}
+(void)updataConfigModel:(id)model{
    ConfigModel *appModel = (ConfigModel *)model;

    [[GS_ConfigManager configManager]  updataExistConfigModel:appModel complete:^{
        GSLog(@"更新成功");
    } failed:^{
        GSLog(@"更新失败");
    }];
}
+(NSString *)readConfigDataWithConfigKey:(NSString *)configKey{
    return  [[GS_ConfigManager configManager]  readWithRecord:configKey];
}

//===========================================================================================
//生成json文件
+ (NSString *)onjson:(NSDictionary *)dict
{
    
    // 1.判断当前对象是否能够转换成JSON数据.
    
    // YES if obj can be converted to JSON data, otherwise NO
    
    BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
    
    if (isYes) {
        GSLog(@"可以转换");
        /*
         JSON data for obj, or nil if an internal error occurs. The resulting data is a encoded in UTF-8.
         */
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
        
        GSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return @"JSON数据生成失败，请检查数据格式";
    
}
+(NSString *)arrTransformString:(NSArray *)arr
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonStr=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    GSLog(@"jsonStr==%@",jsonStr);
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonStr];
    NSRange range = {0,jsonStr.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    NSRange range3 = {0,mutStr.length};
    NSMutableString *responseString = [NSMutableString stringWithString:mutStr];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }

    return mutStr;
    
}
+(NSArray *)strTransformArr:(NSString *)str
{
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    GSLog(@"字符串转字典/数组 %@",arr);
    return arr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        GSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        GSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
+(NSDictionary *)dictionaryWithformJsonArr:(NSString *)str
{
    NSDictionary * dict ;
    for ( dict in [self strTransformArr:str]) {
         return dict;
    }

    return dict?:@{@"error":@"解析失败"};
}
+(NSDictionary *)dictionaryWithData:(id)responseObject
{
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    return [self dictionaryWithJsonString:responseStr];
}
//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}
@end
