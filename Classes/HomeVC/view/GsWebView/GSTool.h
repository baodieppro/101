//
//  WEBTool.h
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTool : NSObject
+(BOOL)newIsHttp:(NSString *)schemeUrl;
+(BOOL)newisHttpOrHttps:(NSString *)url;
+(NSString *)urlWithIsUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
