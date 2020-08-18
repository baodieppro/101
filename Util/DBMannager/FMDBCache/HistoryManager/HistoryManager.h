//
//  HistoryManager.h
//  GSDlna
//
//  Created by ios on 2020/1/20.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class History_FMDBDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface HistoryManager : NSObject

//非标准单例
+ (HistoryManager *)historyManager;
//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)url;
- (void)deleteModelForTime:(NSString *)times;

//根据指定类型  查找所有的记录
- (NSArray *)readModelsWithRecord;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)url ;
- (BOOL)isExistAppForTime:(NSString *)times;

//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type;
- (NSInteger)timeModelArrayfromeKey:(NSString *)time classificationId:(NSString *)classificationId;

//删除数据里的所有数据
-(void)deleteHISAllManage;
//删除指定数据
-(void)deleteHISWithDetailedTime:(NSString *)detailedTime;
//修改
- (void)updataExistNewModel:(id)model complete:(void (^)(void))complete failed:(void (^)(void))failed;
//修改指定数据
- (void)updataIndexExistNewModel:(id)model complete:(void (^)(void))complete failed:(void (^)(void))failed;
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
//模型
@interface History_FMDBDataModel : NSObject

@property (nonatomic,copy) NSString * historyId;//!<Id
@property (nonatomic,copy) NSString * detailedTime;//!<详细时间
@property (nonatomic,copy) NSString * title;//!<视频名
@property (nonatomic,copy) NSString * url;//!<历史地址
@property (nonatomic,copy) NSString * time;//!<记录时间
@property (nonatomic,copy) NSString * isSeleted;//!<选择

+ (instancetype)friendWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


NS_ASSUME_NONNULL_END
