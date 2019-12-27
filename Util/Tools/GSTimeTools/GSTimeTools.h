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
//当前的时间 年月日
+(NSString *)getPresentTime;
//获取宝宝当前年龄
+(NSString *)setBaby_old:(NSString *)time;
//获取时间差
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+(NSString *)nowDateDifferWithStartTime:(NSString *)startTime endTime:(NSString *)endTime TimeDifference:(TimeDifference)timeDifference;
//获取当前时间详情 精确到 上下午 星期 以及昨天
+(NSString *)getDateDisplayString:(long long)miliSeconds;

//字符串转date时间
+(NSDate *)setDateFormatter:(NSString *)time;
+(NSInteger )year:(NSDate *)date;
+(NSInteger )month:(NSDate *)date;
+(NSInteger )day:(NSDate *)date;


@end
