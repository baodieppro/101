//
//  DownLoadManager.h
//  GSDlna
//
//  Created by ios on 2019/12/24.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNM3u8Cache.h"
#import "DownloadDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadManager : NSObject
//初始化
+(void)initConfig:(NSString *)fileName;
//开始下载
+ (void)start:(NSString *)url
         Name:(NSString *)name
        progressBlock:(void (^)(CGFloat progress))progressBlock;
//单个取消
+ (void)cannel:(NSString *)url;
//取消全部
+ (void)cannelAll;
//删除下载
+ (void)clearRootPath:(NSString *)fileName;
//删除下载视频
+(void)removeDownLoadVideo:(Download_FMDBDataModel *)model;
@end

NS_ASSUME_NONNULL_END
