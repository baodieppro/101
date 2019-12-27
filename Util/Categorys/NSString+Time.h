//
//  NSString+Time.h
//  Demo
//
//  Created by YGLEE on 2018/3/6.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;
//转换时间格式的方法
+ (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal;
@end
