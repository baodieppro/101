//
//  BNTool.h
//  m3u8Demo
//
//  Created by zengbailiang on 2019/8/17.
//  Copyright © 2019 Bennie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNTool : NSObject
#pragma mark - dir/fileName
+ (NSString *)uuidWithUrl:(NSString *)Url;
//验证Url
+(NSString *)m3u8Url:(NSString *)urlStr;
//m3u8下载地址解析——下载地址：
+ (NSString *)setParsingWithM3u8Url:(NSString *)urlStr m3u8Str:(NSString *)m3u8Str;
//m3u8域名匹配
+(NSString *)newisHttpOrHttps:(NSString *)url orUrl:(NSString *)orUrl;

@end

NS_ASSUME_NONNULL_END
