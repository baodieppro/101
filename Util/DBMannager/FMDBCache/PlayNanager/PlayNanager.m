//
//  PlayNanager.m
//  GSDlna
//
//  Created by ios on 2019/12/30.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "PlayNanager.h"

@implementation PlayNanager
+(void)addHistoryData:(NSDictionary *)dict{
    
    PlayCacheModel *appModel = [[PlayCacheModel alloc] init];
    appModel.title = [dict objectForKey:@"title"];
    appModel.url = [dict objectForKey:@"url"];
    appModel.time = [dict objectForKey:@"time"]?:[GSTimeTools getCurrentTimes];
    Download_FMDBDataModel  * downModel = [[DownloadCacheManager downManager] itmefromeKeyURL:appModel.url];
    appModel.pathUrl = downModel.pathUrl?:@"0";
    appModel.isDown = downModel.isDown?:@"0";
    if ([self isExistAppForUrl:appModel.url] == NO) {
        
        [[PlayCacheFmdb videoFMDB] insertModel:appModel];
        GSLog(@"====================添加新的视频记录");
        
    }else{
        [[PlayCacheFmdb videoFMDB] updataExistNewModel:appModel complete:^{
            GSLog(@"====================修改视频记录成功");
        } failed:^{
            GSLog(@"====================修改视频记录失败");
        }];
    }
}
#pragma mark - 查询
+(BOOL)isExistAppForTitle:(NSString *)title{
    return [[PlayCacheFmdb videoFMDB] isExistAppForName:title];
}
+ (BOOL)isExistAppForUrl:(NSString *)url
{
    return [[PlayCacheFmdb videoFMDB] isExistAppForUrl:url];
}
#pragma mark - 读取所有缓存数据
+(NSArray *)readDataList{
    return [[PlayCacheFmdb videoFMDB] allArray];
}
+(NSString *)readDefUrl{
    return [[PlayCacheFmdb videoFMDB] isDeffromeKey:@"1"];
}
#pragma mark - 清除数据

+(void)deleteModelForUrl:(NSString *)url{
    [[PlayCacheFmdb videoFMDB] deleteModelForUrl:url];
}
+(void)deleteAllData{
    NSArray * arr = [self readDataList];
    if (arr.count != 0) {
        [[PlayCacheFmdb videoFMDB] deleteAllManage];
    }
}
@end
@implementation PlayCacheModel

@end
//数据库
static  FMDatabase * database;
static PlayCacheFmdb *manager=nil;
@implementation PlayCacheFmdb
+(PlayCacheFmdb *)videoFMDB
{
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[PlayCacheFmdb alloc]init];
                      }
                  });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        //        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/PLAYVIDEOFMDBBrowser.db"];
        
        NSString *filePath = [self getFileFullPathWithFileName:@"PLAYVIDEOFMDB"];
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
    NSString *sql = @"create table if not exists PLAYVIDEOFMDB(title TEXT NOT NULL,url TEXT NOT NULL,pathUrl TEXT NOT NULL,isDown TEXT NOT NULL,time TEXT NOT NULL)";
    
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
    PlayCacheModel *appModel = (PlayCacheModel *)model;
    
    if ([self isExistAppForName:appModel.title]==YES) {
        
        //        NSLog(@"this app has recorded");
        return;
    }
    NSString *sql = @"insert into PLAYVIDEOFMDB(title,url,pathUrl,isDown,time) values (?,?,?,?,?)";
    
    BOOL isSuccess = [database executeUpdate:sql,appModel.title,appModel.url,appModel.pathUrl,appModel.isDown,appModel.time];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)downLoadUrl {
    NSString *sql = @"delete from PLAYVIDEOFMDB where downLoadUrl = ? ";
    BOOL isSuccess = [database executeUpdate:sql,downLoadUrl];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
- (void)deleteModelForpathUrl:(NSString *)pathUrl {
    NSString *sql = @"delete from PLAYVIDEOFMDB where pathUrl = ? ";
    BOOL isSuccess = [database executeUpdate:sql,pathUrl];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
////删除指定的应用数据 根据指定的类型
//- (void)deleteAllManage {
//    NSString *sql = @"delete from PLAYVIDEOFMDB where downLoadUrl = ? ";
//    BOOL isSuccess = [database executeUpdate:sql,downLoadUrl];
//    if (!isSuccess) {
//        NSLog(@"delete error:%@",database.lastErrorMessage);
//    }
//}


//修改
- (void)updataExistNewModel:(id)model complete:(void (^)())complete failed:(void (^)(void))failed
{
    PlayCacheModel *appModel = (PlayCacheModel *)model;
    
    //    [database open];
    NSString * str = [NSString stringWithFormat:@"UPDATE PLAYVIDEOFMDB SET title ='%@',time ='%@',pathUrl ='%@',isDown ='%@' WHERE url ='%@' ",appModel.title,appModel.time,appModel.pathUrl,appModel.isDown,appModel.url];
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
    
    NSString *sql = @"select * from PLAYVIDEOFMDB";
    FMResultSet * set = [database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        PlayCacheModel *appModel = [[PlayCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title{
    
    NSString *sql = @"select * from PLAYVIDEOFMDB where title = ?";
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
    NSString *sql = @"select * from PLAYVIDEOFMDB where url = ?";
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
    NSString *sql = @"select * from PLAYVIDEOFMDB where pathUrl = ?";
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
    NSString *sql = @"select count(*) from PLAYVIDEOFMDB where name = ?";
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
    
    NSString *deleteSql=@"delete from PLAYVIDEOFMDB ";
    
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
    NSString *selSQL=@"select * from PLAYVIDEOFMDB";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        PlayCacheModel *appModel = [[PlayCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        
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
    NSString *selSQL=@"select * from PLAYVIDEOFMDB";
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
    NSString *selSQL=@"select * from PLAYVIDEOFMDB";
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
    NSString *selSQL=@"select * from PLAYVIDEOFMDB where time = ? order by times desc";
    FMResultSet *set=[database executeQuery:selSQL,time];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        PlayCacheModel *appModel = [[PlayCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
        
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
- (PlayCacheModel *)itmefromeKeyURL:(NSString *)url
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from PLAYVIDEOFMDB where url = ?";
    FMResultSet *set=[database executeQuery:selSQL,url];
    PlayCacheModel *appModel = [[PlayCacheModel alloc] init];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.pathUrl = [set stringForColumn:@"pathUrl"];
        appModel.isDown = [set stringForColumn:@"isDown"];
        appModel.time = [set stringForColumn:@"time"];
    }
    
    return appModel;
}
@end
