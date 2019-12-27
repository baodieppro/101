//
//  DownloadDataManager.h
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Download_FMDBDataModel;
@class DownloadCacheManager;

NS_ASSUME_NONNULL_BEGIN
@interface DownloadDataManager : NSObject
#pragma mark - 查询
+ (BOOL)isExistAppForTitle:(NSString *)title;
+ (BOOL)isExistAppForPathUrl:(NSString *)pathUrl;

//添加更新数据
+(void)addHistoryData:(NSDictionary *)dict;
//读取所有数据
+(NSArray *)readDownLoadDataList;
//删除指定数据
+(void)deleteItmeData:(NSString *)url;
//删除所有数据
+(void)deleteAllData;

@end

//模型
@interface Download_FMDBDataModel : NSObject

@property (nonatomic,copy) NSString * fileName;//!<下载文件名
@property (nonatomic,copy) NSString * title;//!<视频名
@property (nonatomic,copy) NSString * downLoadUrl;//!<下载地址
@property (nonatomic,copy) NSString * pathUrl;//!<本地播放地址
@property (nonatomic,copy) NSString * progress;//!<下载进度
@property (nonatomic,copy) NSString * isDown;//!<下载完成：1 未完成：0
@property (nonatomic,copy) NSString * time;//!<下载时间

@end

//数据库
@interface DownloadCacheManager : NSObject
//非标准单例
+ (DownloadCacheManager *)downManager;
//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)title;
- (void)deleteModelForpathUrl:(NSString *)pathUrl;

//根据指定类型  查找所有的记录
- (NSArray *)readModelsWithRecord;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title ;
- (BOOL)isExistAppForPathUrl:(NSString *)pathUrl;

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


@end





NS_ASSUME_NONNULL_END
