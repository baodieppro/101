//
//  PlayNanager.h
//  GSDlna
//
//  Created by ios on 2019/12/30.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PlayCacheFmdbl;
@class PlayCacheModel;
NS_ASSUME_NONNULL_BEGIN

@interface PlayManager : NSObject
#pragma mark - 查询
+ (BOOL)isExistAppForTitle:(NSString *)title;
+ (BOOL)isExistAppForUrl:(NSString *)url;
//添加更新数据
+(void)updata_PlayTimeWithUrl:(NSString *)url currentTime:(NSString *)currentTime;

+(void)addPlayData:(NSDictionary *)dict;
//查找指定数据
+ (PlayCacheModel *)itmefromeKeyURL:(NSString *)url;
//读取所有数据
+(NSArray *)readDataList;
//删除指定数据
+(void)deleteModelForUrl:(NSString *)url;
//删除所有数据
+(void)deleteAllData;

@end
@interface PlayCacheModel : NSObject

@property (nonatomic,copy) NSString * title;//!<名
@property (nonatomic,copy) NSString * url;//!<播放地址
@property (nonatomic,copy) NSString * currentTime;//!<当前播放时长
@property (nonatomic,copy) NSString * time;//!<下载时间
@property (nonatomic,assign) BOOL isSeleted;//!<选择 默认NO

@end
@interface PlayCacheFmdb : NSObject
//非标准单例
+ (PlayCacheFmdb *)videoFMDB;
//增加 数据 收藏/浏览/下载记录
//存储类型 favorites s browses
- (void)insertModel:(id)model;

//删除指定的应用数据 根据指定的类型
- (void)deleteModelForUrl:(NSString *)url;

//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title ;
- (BOOL)isExistAppForUrl:(NSString *)url;

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
 *  某个时间段的数组
 *
 *  @return 当前时间段的所有数据
 */
- (NSArray *)timeModelArrayfromeKey:(NSString *)time;
/**
 *  通过url获取指定数据
 *
 *  @return PlayCacheModel 数据
 */
- (PlayCacheModel *)itmefromeKeyURL:(NSString *)url;
/**
 *  通过url获取指定数据
 *
 *  @return 当前播放进度
 */
- (NSString *)currentTimefromeKeyURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
