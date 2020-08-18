//
//  TimeManager.m
//  WebTest
//
//  Created by 巩小鹏 on 16/9/29.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager
{
    FMDatabase *_database;
}

+(TimeManager *)timeManager
{
    static TimeManager *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once ,^
                  {
                      if (manager==nil)
                      {
                          manager=[[TimeManager alloc]init];
                      }
                  });
    return manager;
}


- (id)init {
    if (self = [super init]) {
        //1.获取数据库文件app.db的路径
        //        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/HistoryBrowser.db"];
        
        NSString *filePath = [self getFileFullPathWithFileName:@"Manager_Time"];
        //2.创建database
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        //        _database = [[FMDatabase alloc] initWithPath:filePath];
        [queue inDatabase:^(FMDatabase *db) {
            _database = db;
        }];
        //3.open
        //第一次 数据库文件如果不存在那么 会创建并且打开
        //如果存在 那么直接打开
        if ([_database open]) {
            GSLog(@"数据库打开成功");
            //创建表 不存在 则创建
            [self creatTable];
        }else {
            GSLog(@"database open failed:%@",_database.lastErrorMessage);
        }
    }
    return self;
}
#pragma mark - 创建表
- (void)creatTable {
    //字段: 名字 图片 音乐地址
    NSString *sql = @"create table if not exists DAY(serial integer  Primary Key Autoincrement,day Varchar(1024),time Varchar(1024))";
    
    //创建表 如果不存在则创建新的表
    BOOL isSuccees = [_database executeUpdate:sql];
    if (!isSuccees) {
        NSLog(@"creatTable error:%@",_database.lastErrorMessage);
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
        NSLog(@"Documents不存在");
        return nil;
    }
}


//增加 数据 收藏/浏览/下载记录
//存储类型 favorites downloads browses
- (void)insertModel:(id)model  {
    TimeModel *appModel = (TimeModel *)model;
    
    if ([self isExistAppForName:appModel.day]==YES) {
        
        NSLog(@"this app has recorded");
        return;
    }
    NSString *sql = @"insert into DAY(day,time) values (?,?)";
    
    BOOL isSuccess = [_database executeUpdate:sql,appModel.day,appModel.time];
    
    if (!isSuccess) {
        NSLog(@"insert error:%@",_database.lastErrorMessage);
    }
}
//删除指定的应用数据 根据指定的类型
- (void)deleteModelForName:(NSString *)day {
    NSString *sql = @"delete from DAY where day = ? ";
    BOOL isSuccess = [_database executeUpdate:sql,day];
    if (!isSuccess) {
        NSLog(@"delete error:%@",_database.lastErrorMessage);
    }
}

//根据指定类型  查找所有的记录
//根据记录类型 查找 指定的记录
- (NSArray *)readDayModelsWithRecord{
    
    NSString *sql = @"select * from DAY";
    FMResultSet * rs = [_database executeQuery:sql];
    
    NSMutableArray *arr = [NSMutableArray array];
    //遍历集合
    while ([rs next]) {
        //把查询之后结果 放在model
        TimeModel *appModel = [[TimeModel alloc] init];
        appModel.day = [rs stringForColumn:@"day"];
        appModel.time = [rs stringForColumn:@"time"];

        
        //放入数组
        [arr addObject:appModel];
    }
    return arr;
}
//根据指定的类型 返回 这条记录在数据库中是否存在
- (BOOL)isExistAppForName:(NSString *)day{
    
    NSString *sql = @"select * from DAY where day = ?";
    FMResultSet *rs = [_database executeQuery:sql,day];
    // NSLog(@"%@-----------MusModel--------",rs);
    if ([rs next]) {//查看是否存在 下条记录 如果存在 肯定 数据库中有记录
        return YES;
    }else{
        return NO;
    }
}
//根据 指定的记录类型  返回 记录的条数
- (NSInteger)getCountsFromAppWithRecordType:(NSString *)type {
    NSString *sql = @"select count(*) from DAY where recordType = ?";
    FMResultSet *rs = [_database executeQuery:sql,type];
//    NSInteger count = 0;
    while ([rs next]) {
        //查找 指定类型的记录条数
//        count = [[rs stringForColumnIndex:0] integerValue];
    }
    return 0;
}

//删除数据里的所有数据
-(void)deleteDayAllManage
{
    //[_lock lock];
    
    NSString *deleteSql=@"delete from DAY ";
   
        BOOL secuess=[_database executeUpdate:deleteSql];
        if (!secuess)
        {
//            GSLog(@"%@",_database.lastError);
        }
    
    
    //[_lock unlock];
}
/**
 *  所有的历史day
 *
 *  @return day数组
 */
- (NSArray *)allDayArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DAY order by day desc";
    FMResultSet *set=[_database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"day"]];
    }
    //[_lock unlock];
    return [array copy];
}
- (NSArray *)allTimeArray
{
    //[_lock lock];
    //* 查找全部 select * from 表名
    NSString *selSQL=@"select * from DAY order by time desc";
    FMResultSet *set=[_database executeQuery:selSQL];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"time"]];
    }
    //[_lock unlock];
    return [array copy];
}

@end
@implementation TimeModel

@end
