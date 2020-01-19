//
//  BookMarkManager.m
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BookMarkManager.h"

@implementation BookMarkManager
+(void)addHistoryData:(NSDictionary *)dict{
    
    BookMarkCacheModel *appModel = [[BookMarkCacheModel alloc] init];
    appModel.title = [dict objectForKey:@"title"];
    appModel.url = [dict objectForKey:@"url"];
    appModel.isDef = [dict objectForKey:@"isDef"];
    appModel.time = [dict objectForKey:@"time"]?:[GSTimeTools getCurrentTimes];
    
    if ([self isExistAppForUrl:appModel.url] == NO) {
        
        [[BookMarkFMDB bookFmdb] insertModel:appModel];
        GSLog(@"====================添加新的书签记录");
        
    }else{
        [[BookMarkFMDB bookFmdb] updataExistNewModel:appModel complete:^{
            GSLog(@"====================修改书签记录成功");
        } failed:^{
            GSLog(@"====================修改书签记录失败");
        }];
    }
}
#pragma mark - 查询
+(BOOL)isExistAppForTitle:(NSString *)title{
    return [[BookMarkFMDB bookFmdb] isExistAppForName:title];
}
+ (BOOL)isExistAppForUrl:(NSString *)url
{
    return [[BookMarkFMDB bookFmdb] isExistAppForUrl:url];
}
#pragma mark - 读取所有缓存数据
+(NSArray *)readDataList{
    return [[BookMarkFMDB bookFmdb] allArray];
}
+(NSString *)readDefUrl{
    return [[BookMarkFMDB bookFmdb] isDeffromeKey:@"1"];
}
#pragma mark - 清除数据

+(void)deleteModelForUrl:(NSString *)url{
    [[BookMarkFMDB bookFmdb] deleteModelForUrl:url];
}
+(void)deleteAllData{
    NSArray * arr = [self readDataList];
    if (arr.count != 0) {
        [[BookMarkFMDB bookFmdb] deleteAllManage];
    }
}
@end
@implementation BookMarkCacheModel

@end
//数据库
static  FMDatabase * database;
static BookMarkFMDB *manager=nil;
@implementation BookMarkFMDB

+(BookMarkFMDB *)bookFmdb
{
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[BookMarkFMDB alloc]init];
                      }
                  });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        //        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/BOOKMARKFMDBBrowser.db"];
        
        NSString *filePath = [self getFileFullPathWithFileName:@"BOOKMARKFMDB"];
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
    NSString *sql = @"create table if not exists BOOKMARKFMDB(title TEXT NOT NULL,url TEXT NOT NULL,isDef TEXT NOT NULL,time TEXT NOT NULL)";
    
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
    BookMarkCacheModel *appModel = (BookMarkCacheModel *)model;
    
    if ([self isExistAppForName:appModel.title]==YES) {
        
        //        NSLog(@"this app has recorded");
        return;
    }
    NSString *sql = @"insert into BOOKMARKFMDB(title,url,isDef,time) values (?,?,?,?)";
    
    BOOL isSuccess = [database executeUpdate:sql,appModel.title,appModel.url,appModel.isDef,appModel.time];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForUrl:(NSString *)url {
    NSString *sql = @"delete from BOOKMARKFMDB where url = ? ";
    BOOL isSuccess = [database executeUpdate:sql,url];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
- (void)deleteModelForpathUrl:(NSString *)pathUrl {
    NSString *sql = @"delete from BOOKMARKFMDB where pathUrl = ? ";
    BOOL isSuccess = [database executeUpdate:sql,pathUrl];
    if (!isSuccess) {
        //        NSLog(@"delete error:%@",database.lastErrorMessage);
    }
}
////删除指定的应用数据 根据指定的类型
//- (void)deleteAllManage {
//    NSString *sql = @"delete from BOOKMARKFMDB where url = ? ";
//    BOOL isSuccess = [database executeUpdate:sql,url];
//    if (!isSuccess) {
//        NSLog(@"delete error:%@",database.lastErrorMessage);
//    }
//}


//修改
- (void)updataExistNewModel:(id)model complete:(void (^)())complete failed:(void (^)(void))failed
{
    BookMarkCacheModel *appModel = (BookMarkCacheModel *)model;
    
    //    [database open];
    NSString * str = [NSString stringWithFormat:@"UPDATE BOOKMARKFMDB SET title ='%@',time ='%@',isDef ='%@' WHERE url ='%@' ",appModel.title,appModel.time,appModel.isDef,appModel.url];
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
    
    NSString *sql = @"select * from BOOKMARKFMDB";
    FMResultSet * set = [database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        BookMarkCacheModel *appModel = [[BookMarkCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.isDef = [set stringForColumn:@"isDef"];
        appModel.time = [set stringForColumn:@"time"];
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)title{
    
    NSString *sql = @"select * from BOOKMARKFMDB where title = ?";
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
    NSString *sql = @"select * from BOOKMARKFMDB where url = ?";
    FMResultSet *rs = [database executeQuery:sql,url];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type {
    NSString *sql = @"select count(*) from BOOKMARKFMDB where name = ?";
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
    
    NSString *deleteSql=@"delete from BOOKMARKFMDB ";
    
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
    NSString *selSQL=@"select * from BOOKMARKFMDB";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        BookMarkCacheModel *appModel = [[BookMarkCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.isDef = [set stringForColumn:@"isDef"];
        appModel.time = [set stringForColumn:@"time"];
        
        //放入数组
        [array addObject:appModel];
        
    }
    //[_lock unlock];
    return [array copy];
}
/**
 *  所有的历史url
 *
 *  @return url数组
 */
- (NSArray *)allurlArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from BOOKMARKFMDB";
    FMResultSet *set=[database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"url"]];
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
    NSString *selSQL=@"select * from BOOKMARKFMDB";
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
    NSString *selSQL=@"select * from BOOKMARKFMDB where time = ? order by times desc";
    FMResultSet *set=[database executeQuery:selSQL,time];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        BookMarkCacheModel *appModel = [[BookMarkCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.isDef = [set stringForColumn:@"isDef"];
        appModel.time = [set stringForColumn:@"time"];
        
        //放入数组
        [array addObject:appModel];
    }
    
    return [array copy];
}
/**
 *  获取指定数据
 *
 *  @return 当前获取指定数据
 */
- (NSString *)isDeffromeKey:(NSString *)isDef
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from BOOKMARKFMDB where isDef = ?";
    FMResultSet *set=[database executeQuery:selSQL,isDef];
    NSString * defUrl;
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        BookMarkCacheModel *appModel = [[BookMarkCacheModel alloc] init];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.isDef = [set stringForColumn:@"isDef"];
        appModel.time = [set stringForColumn:@"time"];
        defUrl = appModel.url;
     
    }
    if(!defUrl){
         NSLog(@"insert error:%@",database.lastErrorMessage);
    }
    
    return [defUrl copy];
}

//- (NSInteger)timeModelArrayfromeKey:(NSString *)time classificationId:(NSString *)classificationId
//{
//    //[_lock lock];
//    //* 查找全部 select * from 表名
//    NSString *selSQL=@"select count(*) from BOOKMARKFMDB where time = ? and name = ? ";
//    //    FMResultSet *set=[database executeQuery:selSQL,time,classificationId];
//    //    NSMutableArray *array=[[NSMutableArray alloc]init];
//    NSInteger count = [database intForQuery:selSQL,time,classificationId];
//
//    return count;
//}
@end
