//
//  HistoryManager.m
//  GSDlna
//
//  Created by ios on 2020/1/20.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "HistoryManager.h"
#import "FMDatabaseAdditions.h"

@implementation HistoryManager
{
    FMDatabase *_database;
}

+(HistoryManager *)historyManager
{
    static HistoryManager *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[HistoryManager alloc]init];
                      }
                  });
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
//        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/HistoryBrowser.db"];

        NSString *filePath = [self getFileFullPathWithFileName:@"Manager_History"];
        //2.创建database
//        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
                _database = [[FMDatabase alloc] initWithPath:filePath];
//        [queue inDatabase:^(FMDatabase *db) {
//            _database = db;
//        }];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
//            NSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
//            NSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 名字 图片 音乐地址
    NSString *sql = @"create table if not exists HISTORY(serial integer  Primary Key Autoincrement,historyId Varchar(1024),time Varchar(1024),times Varchar(1024),title Varchar(1024),url Varchar(1024),isSel Varchar(1024))";
    
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [_database executeUpdate:sql];
    if (!isSuccees) {
//        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
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
    History_FMDBDataModel *appModel = (History_FMDBDataModel *)model;
    
    if ([self isExistAppForTime:appModel.detailedTime]==YES) {
        
//        NSLog(@"this app has recorded");
        return;
    }
    NSString *sql = @"insert into HISTORY(historyId,time,times,title,url,isSel) values (?,?,?,?,?,?)";
    
    BOOL isSuccess = [_database executeUpdate:sql,appModel.historyId,appModel.time,appModel.detailedTime,appModel.title,appModel.url,appModel.isSeleted];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)url {
    NSString *sql = @"delete from HISTORY where url = ? ";
    BOOL isSuccess = [_database executeUpdate:sql,url];
    if (!isSuccess) {
//        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}
- (void)deleteModelForTime:(NSString *)times {
    NSString *sql = @"delete from HISTORY where times = ? ";
    BOOL isSuccess = [_database executeUpdate:sql,times];
    if (!isSuccess) {
//        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}
////删除指定的应用数据 根据指定的类型
//- (void)deleteAllManage {
//    NSString *sql = @"delete from HISTORY where url = ? ";
//    BOOL isSuccess = [_database executeUpdate:sql,url];
//    if (!isSuccess) {
//        NSLog(@"delete error:%@",_database.lastErrorMessage);
//    }
//}


//修改
- (void)updataExistNewModel:(id)model complete:(void (^)(void))complete failed:(void (^)(void))failed
{
    History_FMDBDataModel *appModel = (History_FMDBDataModel *)model;

//    [_database open];
    NSString * str = [NSString stringWithFormat:@"UPDATE HISTORY set historyId ='%@', time ='%@', times ='%@', title ='%@', isSel ='%@' where url ='%@'",appModel.historyId,appModel.time,appModel.detailedTime,appModel.title,appModel.isSeleted,appModel.url];
    //    NSString *sql = @"updata COLLECTION set  where title = ?";
    BOOL isSuccess = [_database executeUpdate:str];
    // NSLog(@"%@-----------MusModel--------",rs);
    if (isSuccess) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                NSLog(@"修改成功");
        complete();
    }else{
                NSLog(@"修改失败");
        failed();
    }
//    [_database close];
}
//修改指定数据
- (void)updataIndexExistNewModel:(id)model complete:(void (^)(void))complete failed:(void (^)(void))failed
{
    History_FMDBDataModel *appModel = (History_FMDBDataModel *)model;

//    [_database open];
    NSString * str = [NSString stringWithFormat:@"UPDATE HISTORY set historyId ='%@', time ='%@', url ='%@', title ='%@', isSel ='%@' where times ='%@'",appModel.historyId,appModel.time,appModel.url,appModel.title,appModel.isSeleted,appModel.detailedTime];
    //    NSString *sql = @"updata COLLECTION set  where title = ?";
    BOOL isSuccess = [_database executeUpdate:str];
    // NSLog(@"%@-----------MusModel--------",rs);
    if (isSuccess) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
                NSLog(@"修改成功");
        complete();
    }else{
                NSLog(@"修改失败");
        failed();
    }
//    [_database close];
}
//根据指定类型  查找所有的记录


//根据记录类型 查找 指定的记录
- (NSArray *)readModelsWithRecord{
    
    NSString *sql = @"select * from HISTORY";
    FMResultSet * set = [_database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        History_FMDBDataModel *appModel = [[History_FMDBDataModel alloc] init];
        appModel.historyId = [set stringForColumn:@"historyId"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.detailedTime = [set stringForColumn:@"times"];
        appModel.isSeleted = [set stringForColumn:@"isSel"];
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)url{
    
    NSString *sql = @"select * from HISTORY where times = ?";
    FMResultSet *rs = [_database executeQuery:sql,url];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForTime:(NSString *)times
{
    
    NSString *sql = @"select * from HISTORY where times = ?";
    FMResultSet *rs = [_database executeQuery:sql,times];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithHistoryId:(NSString *)historyId {
        NSString *sql = @"select count(*) from HISTORY where historyId = ?";
        FMResultSet *rs = [_database executeQuery:sql,historyId];
//        NSInteger count = 0;
        while ([rs next]) {
            //查找 指定类型的记录条数
//            count = [[rs stringForColumnIndex:0] integerValue];
        }
    return 0;
}

//删除数据里的所有数据
-(void)deleteHISAllManage
{
    //[_lock lock];
    
    NSString *deleteSql=@"delete from HISTORY ";
    
        BOOL secuess=[_database executeUpdate:deleteSql];
        if (!secuess)
        {
//            GSLog(@"%@",_database.lastError);
        }
    
    
    //[_lock unlock];
}
//删除指定数据
-(void)deleteHISWithDetailedTime:(NSString *)detailedTime
{
    //[_lock lock];
    
    NSString *deleteSql=@"delete from HISTORY where times = ?";
     
        BOOL secuess=[_database executeUpdate:deleteSql,detailedTime];
        if (!secuess)
        {
//            GSLog(@"%@",_database.lastError);
        }
    
    
    //[_lock unlock];
}
/**
 *  所有的历史Url
 *
 *  @return Url数组
 */
- (NSArray *)allUrlArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from HISTORY";
    FMResultSet *set=[_database executeQuery:selSQL];
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
    NSString *selSQL=@"select * from HISTORY";
    FMResultSet *set=[_database executeQuery:selSQL];
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
    NSString *selSQL=@"select * from HISTORY where time = ? order by times desc";
    FMResultSet *set=[_database executeQuery:selSQL,time];
    NSMutableArray *array=[[NSMutableArray alloc]init];
       //遍历集合
    while ([set next]) {
        //把查询之后结果 放在model
        History_FMDBDataModel *appModel = [[History_FMDBDataModel alloc] init];
        appModel.historyId = [set stringForColumn:@"historyId"];
        appModel.time = [set stringForColumn:@"time"];
        appModel.title = [set stringForColumn:@"title"];
        appModel.url = [set stringForColumn:@"url"];
        appModel.detailedTime = [set stringForColumn:@"times"];
        appModel.isSeleted = [set stringForColumn:@"isSel"];

        //放入数组
        [array addObject:appModel];
    }

    return [array copy];
}
- (NSInteger)timeModelArrayfromeKey:(NSString *)time classificationId:(NSString *)classificationId
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select count(*) from HISTORY where time = ? and historyId = ? ";
//    FMResultSet *set=[_database executeQuery:selSQL,time,classificationId];
//    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSInteger count = [_database intForQuery:selSQL,time,classificationId];

    return count;
}

@end
@implementation History_FMDBDataModel
+ (instancetype)friendWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end

