//
//  NSString+Time.m
//  Demo
//
//  Created by YGLEE on 2018/3/6.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}
//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
//    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
    NSString *format_time = [NSString stringWithFormat:@"%@分钟",str_minute];

    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}
//转换时间格式的方法
+ (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    if (hour == 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}
@end
