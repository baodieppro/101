//
//  DownLoadManager.m
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//
#define _localhost_ @"http://127.0.0.1:8080/"
#define _fileName_ @"GSDownLoad"


#import "DownLoadManager.h"
#import "NSString+m3u8.h"
#import "BNTool.h"

@implementation DownLoadManager

+(void)initConfig:(NSString *)fileName{
    NSString *rootPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:fileName?:_fileName_];
    
    NSLog(@"rootPath:%@",rootPath);
    BNM3U8ManagerConfig *config = BNM3U8ManagerConfig.new;
    /*媒体下载并发数控制*/
    config.videoMaxConcurrenceCount = 5;
    config.downloadDstRootPath = rootPath;
//        config.netOption = BNM3U8DownloadSupportNetOptionWifi;
    [[BNM3U8Manager shareInstance] fillConfig:config];
    
    BNHttpLocalServer.shareInstance.documentRoot = rootPath;
    BNHttpLocalServer.shareInstance.port = 8080;
}
//开始下载
+ (void)start:(NSString *)url Name:(NSString *)name progressBlock:(void (^)(CGFloat progress))progressBlock
{
    NSString * m3u8DownUrl = [BNTool m3u8Url:url];
    NSString * m3u8DownTitle = [name stringByReplacingOccurrencesOfString:@" " withString:@""];

    //创建下载数据
    [self addDownLoadCacheUrl:m3u8DownUrl name:m3u8DownTitle pathUrl:@"0" progress:@"0" isDown:@"0"];
    BNM3U8DownloadConfig *dlConfig = BNM3U8DownloadConfig.new;
    dlConfig.url = m3u8DownUrl;
    dlConfig.fileName = m3u8DownTitle;
    /*单个媒体下载的文件并发数控制*/
    dlConfig.maxConcurrenceCount = 5;
    dlConfig.localhost = _localhost_;
    [BNM3U8Manager.shareInstance downloadVideoWithConfig:dlConfig progressBlock:^(CGFloat progress) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(progress);
            });
        });
       
    }resultBlock:^(NSError * _Nullable error, NSString * _Nullable localPlayUrl) {
        if(localPlayUrl)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新数据
                [self addDownLoadCacheUrl:m3u8DownUrl name:m3u8DownTitle pathUrl:localPlayUrl progress:@"100%"isDown:@"1"];
                
            });
        }
    }];
}
//添加下载记录
+(void)addDownLoadCacheUrl:(NSString *)url
               name:(NSString *)name
            pathUrl:(NSString *)pathUrl
            progress:(NSString *)progress
            isDown:(NSString *)isDown
{
  
    [DownloadDataManager addHistoryData:@{
                                          @"fileName":_fileName_,
                                          @"title":name,
                                          @"url":url,
                                          @"pathUrl":pathUrl,
                                          @"progress":progress,
                                          @"isDown":isDown,
                                          }];
}
+ (void)cannel:(NSString *)url
{
    [BNM3U8Manager.shareInstance  cannel:url];
}
+ (void)cannelAll
{
    [BNM3U8Manager.shareInstance cancelAll];
}

+ (void)clearRootPath:(NSString *)fileName
{
    NSString *rootPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [BNFileManager.shareInstance removeFileWithPath:rootPath];
}
//删除下载视频
+(void)removeDownLoadVideo:(Download_FMDBDataModel *)model{
    //删除文件
    NSString *pathVideo = [NSString stringWithFormat:@"%@/%@",model.fileName,[BNTool uuidWithUrl:model.downLoadUrl]];
    [self clearRootPath:pathVideo];
   //删除记录
    [DownloadDataManager deleteItmeData:model.downLoadUrl];
}

@end
