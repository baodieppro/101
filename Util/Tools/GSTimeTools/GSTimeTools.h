//
//  GSTimeTools.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TimeDifference) {
    YearDifference,   //计算年差
    MonthlDifference, //计算月差
    DaysDifference,   //计算日差
    HourDifference,   //计算小时差
    MinuteDifference, //计算分差
    SecondsDifference //计算秒差
};

@interface GSTimeTools : NSObject
//当前的时间 年月日时分秒
+(NSString*)getCurrentTimes;
//当前的时间 年-月-日
+(NSString *)getPresentTime;
//当前的时间 年-月
+(NSString *)getYearMonth;
//当前的时间 年月
+(NSString *)newYearMonth;
//判断一个日期是否是在本周
+ (BOOL)isDateInWeekend:(NSString *)string;
//判断一个日期是否是明天
+ (BOOL)isDateInTomorrow:(NSString *)string;
//判断一个日期是否是昨天
+ (BOOL)isDateInYesterday:(NSString *)string;
//判断是否是今天
+ (BOOL)checkTheDate:(NSString *)string;
//判断两个日期是否是同一天
+(BOOL)isDateStartTime:(NSString *)startTime inSameDayAsDate:(NSString *)endTime;
//获取宝宝当前年龄
+(NSString *)setBaby_old:(NSString *)time;
//获取时间差
+ (NSInteger)timeIntervalStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
/*
 * 计算时间差 几年？几月？几天？几时？几分钟？几秒？
 * startTime 开始时间
 * endTime 结束时间
 * timeDifference 时间差枚举
 */
+ (NSString *)nowDateDifferWithStartTime:(NSString *)startTime endTime:(NSString *)endTime TimeDifference:(TimeDifference)timeDifference;

//字符串转date时间
+(NSDate *)setDateFormatter:(NSString *)time;
+(NSDate *)setDateYYMMDDHHSSMM:(NSString *)time;
+(NSInteger )year:(NSDate *)date;
+(NSInteger )month:(NSDate *)date;
+(NSInteger )day:(NSDate *)date;
//传入 秒  得到  xx时xx分钟xx秒
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;
//传人时间 返回当前状态 前天 昨天 今天
+(NSString *)compareDate:(NSString *)date;

@end
