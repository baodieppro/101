//
//  DownloadDataManager.m
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "DownloadDataManager.h"
#import "FMDatabaseAdditions.h"
@implementation DownloadDataManager
#pragma mark - 储存历史缓存数据
+(void)updata_PlayTimeWithUrl:(NSString *)url currentTime:(NSString *)currentTime
{
    Download_FMDBDataModel * appModel = [[DownloadCacheManager downManager] itmefromeKeyURL:url];
    appModel.currentTime = currentTime?:@"0";
    [self addModel:appModel];
}
+(void)addHistoryData:(NSDictionary *)dict{
    
    Download_FMDBDataModel *appModel = [[Download_FMDBDataModel alloc] init];
    appModel.fileName = [dict objectForKey:@"fileName"];
    appModel.title = [dict objectForKey:@"title"];
    appModel.downLoadUrl = [dict objectForKey:@"url"];
    appModel.pathUrl = [dict objectForKey:@"pathUrl"];
    appModel.progress = [dict objectForKey:@"progress"];
    appModel.isDown = [dict objectForKey:@"isDown"];
    appModel.time = [dict objectForKey:@"time"]?:[GSTimeTools getCurrentTimes];
    appModel.currentTime = [dict objectForKey:@"currentTime"]?:@"0";
    
    [self addModel:appModel];
}
+(void)addModel:(Download_FMDBDataModel *)appModel{
    if ([self isExistAppForTitle:appModel.title] == NO) {
        
        [[DownloadCacheManager downManager] insertModel:appModel];
        GSLog(@"====================添加新的下载记录");
        
    }else{
        [[DownloadCacheManager downManager] updataExistNewModel:appModel complete:^{
            GSLog(@"====================修改下载记录成功");
        } failed:^{
            GSLog(@"====================修改下载记录失败");
        }];
    }
}
#pragma mark - 查询
+(BOOL)isExistAppForTitle:(NSString *)title{
    return [[DownloadCacheManager downManager] isExistAppForName:title];
}
+ (BOOL)isExistAppForPathUrl:(NSString *)pathUrl
{
    return [[DownloadCacheManager downManager] isExistAppForPathUrl:pathUrl];
}
+ (BOOL)isExistAppForUrl:(NSString *)url
{
    return [[DownloadCacheManager downManager] isExistAppForUrl:url];
}
#pragma mark - 读取所有缓存数据
+(NSArray *)readDownLoadDataList{
    return [[DownloadCacheManager downManager] allArray];
}
+(NSString *)readDownLoadCachePathUrl:(NSString *)url{
    Download_FMDBDataModel * model = [[DownloadCacheManager downManager] itmefromeKeyURL:url];
    if (model.downLoadUrl) {
        return model.pathUrl?:model.downLoadUrl;
    }
    return url;
}
#pragma mark - 清除数据

+(void)deleteItmeData:(NSString *)downLoadUrl{
    [[DownloadCacheManager downManager] deleteModelForName:downLoadUrl];
}
+(void)deleteAllData{
    NSArray * arr = [self readDownLoadDataList];
    if (arr.count != 0) {
        [[DownloadCacheManager downManager] deleteAllManage];
    }
}
@end

@implementation Download_FMDBDataModel

@end

//数据库
static  FMDatabase * database;
static DownloadCacheManager *manager=nil;

@implementation DownloadCacheManager

+(DownloadCacheManager *)downManager
{
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[DownloadCacheManager alloc]init];
                      }
                  });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        //        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/DOWNLOADVIDEOBrowser.db"];
        
        NSString *filePath = [self getFileFullPathWithFileName:@"DOWNLOADVIDEO"];
        //2.创建database
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        //        database = [[FMDatabase alloc] initWithPath:filePath];
        [queue inDatabase:^(FMDatabase *db) {
            database = db;
        }];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([database open]) {
            //            NSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            //            NSLog(@"database open failed:%@",database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 名字 图片 音乐地址
    NSString *sql = @"create table if not exists DOWNLOADVIDEO(fileName TEXT NOT NULL,title TEXT NOT NULL,downLoadUrl TEXT NOT NULL,pathUrl TEXT NOT NULL,progress TEXT NOT NULL,isDown TEXT NOT NULL,time TEXT NOT NULL,currentTime TEXT NOT NULL)";
    
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [database executeUpdate:sql];
    if (!isSuccees) {
        NSLog(@"creatTable error:%@",database.lastErrorMessage);
    }
}
#pragma mark - 获取文件的全路径

//获取文件在沙盒中的 Documents中的路径
- (NSString *)getFileFullPathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        //文件的全路径
        return [docPath stringByAppendingFormat:@"/%@",fileName];
    }else {
        //如果不存在可以创建一个新的
        //        NSLog(@"Documents不存在");
        return nil;
    }
}


//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model  {
    Download_FMDBDataModel *appModel = (Download_FMDBDataModel *)model;
    
    if ([self isExistAppForName:appModel.title]==YES) {
        
        //        NSLog(@"this app has recorded");
        return;
    }
    NSString *sql = @"insert into DOWNLOADVIDEO(fileName,title,downLoadUrl,pathUrl,progress,isDown,time,currentTime) values (?,?,?,?,?,?,?,?)";
    
    BOOL isSuccess = [database executeUpdate:sql,appModel.fileName,appModel.title,appModel.downLoadUrl,appModel.pathUrl,appModel.progress,appModel.isDown,appModel.time,appModel.currentTime];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)downLoadUrl {
    NSString *sql = @"delete from DOWNLOADVIDEO where downLoadUrl = ? ";
    BOOL isSuccess = [database executeUpdate:sql,downLoadUrl];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
- (void)deleteModelForpathUrl:(NSString *)pathUrl {
    NSString *sql = @"delete from DOWNLOADVIDEO where pathUrl = ? ";
    BOOL isSuccess = [database executeUpdate:sql,pathUrl];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
////删除指定的应用数据 根据指定的类型
//- (void)deleteAllManage {
//    NSString *sql = @"delete from DOWNLOADVIDEO where downLoadUrl = ? ";
//    BOOL isSuccess = [database executeUpdate:sql,downLoadUrl];
//    if (!isSuccess) {
//        NSLog(@"delete error:%@",database.lastErrorMessage);
//    }
//}


//修改
- (void)updataExistNewModel:(id)model complete:(void (^)(void))complete failed:(void (^)(void))failed
{
    Download_FMDBDataModel *appModel = (Download_FMDBDataModel *)model;
    
//    [database open];
    NSString * str = [NSString stringWithFormat:@"UPDATE DOWNLOADVIDEO SET fileName ='%@',title ='%@',time ='%@',pathUrl ='%@',progress ='%@',isDown ='%@',currentTime ='%@' WHERE downLoadUrl ='%@' ",appModel.fileName,appModel.title,appModel.time,appModel.pathUrl,appModel.progress,appModel.isDown,appModel.currentTime,appModel.downLoadUrl];
//     NSString * str = [NSString stringWithFormat:@"UPDATE DOWNLOADVIDEO SET fileName ='%@',title ='%@',time ='%@',pathUrl ='%@',progress ='%@',isDown ='%@' WHERE downLoadUrl ='%@' ",appModel.fileName,appModel.title,appModel.time,appModel.pathUrl,appModel.progress,appModel.isDown,appModel.downLoadUrl];
    //    NSString *sql = @"updata COLLECTION set  where title = ?";
    BOOL isSuccess = [database executeUpdate:str];
    // NSLog(@"%@-----------MusModel--------",rs);
    if (isSuccess) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        NSLog(@"修改成功");
        complete();
    }else{
        NSLog(@"UPDATE error:%@",database.lastErrorMessage);
        failed();
    }
//    [database close];
}
//根据指定类型  查找所有的记录


//根据记录类型 查找 指定的记录
- (NSArray *)readModelsWithRecord{
    
    NSString *sql = @"select * from DOWNLOADVIDEO";
    FMResultSet * set = [database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        Download_FMDBDataModel *appModel = [[Download_FMDBDataModel alloc] init];
        appModel.fileName = [set stringForColumn:@"fileName"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.downLoadUrl = [set stringForColumn:@"downLoadUrl"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.progress = [set stringForColumn:@"progress"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.currentTime = [set stringForColumn:@"currentTime"];
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title{
    
    NSString *sql = @"select * from DOWNLOADVIDEO where title = ?";
    FMResultSet *rs = [database executeQuery:sql,title];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isExistAppForUrl:(NSString *)url
{
    NSString *sql = @"select * from DOWNLOADVIDEO where downLoadUrl = ?";
    FMResultSet *rs = [database executeQuery:sql,url];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)isExistAppForPathUrl:(NSString *)PathUrl
{
    NSString *sql = @"select * from DOWNLOADVIDEO where pathUrl = ?";
    FMResultSet *rs = [database executeQuery:sql,PathUrl];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type {
    NSString *sql = @"select count(*) from DOWNLOADVIDEO where name = ?";
    FMResultSet *rs = [database executeQuery:sql,type];
    //        NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
        //            count = [[rs stringForColumnIndex:0] integerValue];
    }
    return 0;
}

//删除数据里的所有数据
-(void)deleteAllManage
{
    //[_lock lock];
    
    NSString *deleteSql=@"delete from DOWNLOADVIDEO ";
    
    BOOL secuess=[database executeUpdate:deleteSql];
    if (!secuess)
    {
        //            GSLog(@"%@",database.lastError);
    }
    
    
    //[_lock unlock];
}
/**
 *  所有的历史
 *
 *  @return 全部数据
 */
- (NSArray *)allArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DOWNLOADVIDEO";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        Download_FMDBDataModel *appModel = [[Download_FMDBDataModel alloc] init];
        appModel.fileName = [set stringForColumn:@"fileName"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.downLoadUrl = [set stringForColumn:@"downLoadUrl"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.progress = [set stringForColumn:@"progress"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.currentTime = [set stringForColumn:@"currentTime"];
        //放入数组
        [array addObject:appModel];
        
    }
    //[_lock unlock];
    return [array copy];
}
/**
 *  所有的历史downLoadUrl
 *
 *  @return downLoadUrl数组
 */
- (NSArray *)alldownLoadUrlArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DOWNLOADVIDEO";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"downLoadUrl"]];
    }
    //[_lock unlock];
    return [array copy];
}
/**
 *  所有的历史Time
 *
 *  @return Time数组
 */
- (NSArray *)allTimeArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DOWNLOADVIDEO";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"time"]];
    }
    //[_lock unlock];
    return [array copy];
}

/**
 *  某个时间段的数组
 *
 *  @return 当前时间段的所有数据
 */
- (NSArray *)timeModelArrayfromeKey:(NSString *)time
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DOWNLOADVIDEO where time = ? order by times desc";
    FMResultSet *set=[database executeQuery:selSQL,time];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        Download_FMDBDataModel *appModel = [[Download_FMDBDataModel alloc] init];
        appModel.fileName = [set stringForColumn:@"fileName"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.downLoadUrl = [set stringForColumn:@"downLoadUrl"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.progress = [set stringForColumn:@"progress"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.currentTime = [set stringForColumn:@"currentTime"];
        //放入数组
        [array addObject:appModel];
    }
    
    return [array copy];
}
/**
 *  通过url获取指定数据
 *
 *  @return 当前指定数据
 */
- (Download_FMDBDataModel *)itmefromeKeyURL:(NSString *)url
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DOWNLOADVIDEO where downLoadUrl = ?";
    FMResultSet *set=[database executeQuery:selSQL,url];
    //遍历集合
    Download_FMDBDataModel *appModel;
    while ([set next]) {
        //把查询之后结果 放在model
        appModel = [[Download_FMDBDataModel alloc] init];
        appModel.fileName = [set stringForColumn:@"fileName"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.downLoadUrl = [set stringForColumn:@"downLoadUrl"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.progress = [set stringForColumn:@"progress"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.currentTime = [set stringForColumn:@"currentTime"];
    }
    
    return appModel;
}
- (NSInteger)timeModelArrayfromeKey:(NSString *)time classificationId:(NSString *)classificationId
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select count(*) from DOWNLOADVIDEO where time = ? and name = ? ";
    //    FMResultSet *set=[database executeQuery:selSQL,time,classificationId];
    //    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSInteger count = [database intForQuery:selSQL,time,classificationId];
    
    return count;
}
@end



