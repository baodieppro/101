//
//  BookMarkManager.h
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BookMarkFMDB;
@class BookMarkCacheModel;

NS_ASSUME_NONNULL_BEGIN

@interface BookMarkManager : NSObject
#pragma mark - 查询
+ (BOOL)isExistAppForTitle:(NSString *)title;
+ (BOOL)isExistAppForUrl:(NSString *)url;

//添加更新数据
+(void)addHistoryData:(NSDictionary *)dict;
//读取所有数据
+(NSArray *)readDataList;
//读取默认主页地址
+(NSString *)readDefUrl;
//删除指定数据
+(void)deleteModelForUrl:(NSString *)url;
//删除所有数据
+(void)deleteAllData;

@end
@interface BookMarkCacheModel : NSObject

@property (nonatomic,copy) NSString * title;//!<名
@property (nonatomic,copy) NSString * url;//!<地址
@property (nonatomic,copy) NSString * isDef;//!<默认主页：1 非主页：0
@property (nonatomic,copy) NSString * time;//!<

@end
@interface BookMarkFMDB : NSObject
//非标准单例
+ (BookMarkFMDB *)bookFmdb;
//增加 数据 收藏/浏览/下载记录
//存储类型 favorites s browses
- (void)insertModel:(id)model;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForUrl:(NSString *)url;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title ;
- (BOOL)isExistAppForUrl:(NSString *)url;

//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type;
- (NSInteger)timeModelArrayfromeKey:(NSString *)time classificationId:(NSString *)classificationId;

//删除数据里的所有数据
-(void)deleteAllManage;

//修改
- (void)updataExistNewModel:(id)model complete:(void (^)())complete failed:(void (^)())failed;

/**
 *  所有的历史
 *
 *  @return 全部数据
 */
- (NSArray *)allArray;
/**
 *  所有的历史Time
 *
 *  @return Time数组
 */
- (NSArray *)allTimeArray;
/**
 *  某个时间段的数组
 *
 *  @return 当前时间段的所有数据
 */
- (NSArray *)timeModelArrayfromeKey:(NSString *)time;
//获取默认数据
- (NSString *)isDeffromeKey:(NSString *)isDef;


@end
NS_ASSUME_NONNULL_END
