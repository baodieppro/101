//
//  GSTimeTools.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSTimeTools.h"

@implementation GSTimeTools
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
+(NSString *)getPresentTime
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //    [formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    [formatter setDateFormat:@"YYYY-MM-dd"];
    //    [formatter setDateFormat:@" hh:mm:ss -- SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    NSLog(@"%@", timeNow);
    return timeNow;
}
+(NSString *)getYearMonth
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //    [formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [formatter setDateFormat:@"YYYY-MM"];
    //    [formatter setDateFormat:@" hh:mm:ss -- SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    NSLog(@"%@", timeNow);
    return timeNow;
}
+(NSString *)newYearMonth
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //    [formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [formatter setDateFormat:@"YYYY年MM月"];
    //    [formatter setDateFormat:@" hh:mm:ss -- SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString * timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    //    NSLog(@"%@", timeNow);
    return timeNow;
}
//换算时差
+(NSDate *)dateStr:(NSDate *)timeDate{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: timeDate];
    NSDate *date = [timeDate  dateByAddingTimeInterval: interval];
    return date;
}

+(NSString *)setBaby_old:(NSString *)time{
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];

    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate*hDate = [inputFormatter dateFromString:time];
    
    return [self dateToDetailOld:hDate];
}
+(NSString *)dateToDetailOld:(NSDate *)bornDate{
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //创建日历(格里高利历)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置component的组成部分
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    //按照组成部分格式计算出生日期与现在时间的时间间隔
    NSDateComponents *date = [calendar components:unitFlags fromDate:bornDate toDate:currentDate options:0];
    
    //判断年龄大小,以确定返回格式
    if( [date year] > 0)
    {
        if ([date month] >0) {
            return [NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]];

        }else{
            return [NSString stringWithFormat:(@"%ld岁%ld天"),(long)[date year],(long)[date day]];
        }
        
    }
    else if([date month] >0)
    {
        return [NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]];
        
    }
    else if([date day]>0)
    {
        return [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
        
    }
    else {
        return @"0天";
    }
}
+(NSDate *)setDateYYMMDDHHSSMM:(NSString *)time{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate*date = [inputFormatter dateFromString:time];
    //补8小时时差
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
+(NSDate *)setDateFormatter:(NSString *)time{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*date = [inputFormatter dateFromString:time];
    return date;
}
+(NSInteger )year:(NSDate *)date{
    NSInteger year = [[self dateComponentNew:date] year];
    return year;
}
+(NSInteger )month:(NSDate *)date{
    NSInteger month = [[self dateComponentNew:date] month];
    return month;
}
+(NSInteger )day:(NSDate *)date{
    NSInteger day = [[self dateComponentNew:date] day];
    return day;
}
+(NSDateComponents *)dateComponentNew:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    //    NSInteger hour =  [dateComponent hour];
    //    NSInteger minute =  [dateComponent minute];
    //    NSInteger second = [dateComponent second];
    return dateComponent;
}

//获取时间差
+ (NSInteger)timeIntervalStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSTimeZone *zone=[NSTimeZone systemTimeZone];//得到时区，根据手机系统时区设置（systemTimeZone）

    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    NSInteger nowInterval=[zone secondsFromGMTForDate:startD];
    //将偏移量加到当前日期
    NSDate *nowTime=[startD dateByAddingTimeInterval:nowInterval];
    
    NSDate *endD = [date dateFromString:endTime];
    NSInteger nowInterval1=[zone secondsFromGMTForDate:endD];
    //将偏移量加到当前日期
    NSDate *nowTime1=[endD dateByAddingTimeInterval:nowInterval1];
    
    NSTimeInterval time=[nowTime1 timeIntervalSinceDate:nowTime];
    if (time <=0) {
        //表示时间已经过去
        return 1;
    }
    return time;
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSTimeInterval time=[self timeIntervalStartTime:startTime endTime:endTime];
    time = round(time/1.0);//最后选择四舍五入
    
    NSString *str;
    
    if (time == 0) {
        str = [NSString stringWithFormat:@"%d",1];

    }else{
        str = [NSString stringWithFormat:@"%ld",(NSInteger)time];
    }

    return str;
    
}

+(NSString *)nowDateDifferWithStartTime:(NSString *)startTime endTime:(NSString *)endTime TimeDifference:(TimeDifference)timeDifference {
    //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSTimeZone *zone=[NSTimeZone systemTimeZone];//得到时区，根据手机系统时区设置（systemTimeZone）
    //=====================start=============================
    
    NSDate *startD =[dateFormatter dateFromString:startTime];
    /*GMT：格林威治标准时间*/
    //格林威治标准时间与系统时区之间的偏移量（秒）
    NSInteger nowInterval=[zone secondsFromGMTForDate:startD];
    //将偏移量加到当前日期
    NSDate *nowTime=[startD dateByAddingTimeInterval:nowInterval];
    
    //=====================end=============================
    NSDate *endD = [dateFormatter dateFromString:endTime];
    //格林威治标准时间与传入日期之间的偏移量
    NSInteger yourInterval = [zone secondsFromGMTForDate:endD];
    //将偏移量加到传入日期
    NSDate *yourTime = [endD dateByAddingTimeInterval:yourInterval];
    //    //传入日期设置日期格式
    //    NSString *stringDate = [dateFormatter stringFromDate:startD];
    //
    //    NSDate *yourDate = [dateFormatter dateFromString:stringDate];
    
    
    //time为两个日期的相差秒数
    NSTimeInterval time=[yourTime timeIntervalSinceDate:nowTime];
    
    //最后通过秒数time计算时间相差 几年？几月？几天？几时？几分钟？几秒？
    CGFloat div = 1.0;
    switch (timeDifference) {
        case SecondsDifference:
            div = 1.0;
            break;
        case MinuteDifference:
            div = 60.0;
            break;
        case HourDifference:
            div = 60.0 * 60.0;
            break;
        case DaysDifference:
            div = 60.0 * 60.0 * 24;
            break;
        case MonthlDifference:
            div = 60.0 * 60.0 * 24 * 30;
            break;
        case YearDifference:
            div = 60.0 * 60.0 * 24 * 30 * 365;
            break;
    }
    time = round(time/div);//最后选择四舍五入
    
    return [NSString stringWithFormat:@"%ld",(NSInteger)time];
}
//传入 秒  得到  xx时xx分钟xx秒
+(NSString *)getHHMMSSFromSS:(NSString *)totalTime
{
    
    NSInteger seconds = [totalTime integerValue];
    NSInteger minute = seconds/60;
    NSInteger second = seconds%60;
    NSString *str_minute;
    NSString *str_second;
    NSString *format_time;
    
    NSString *str_hour = [NSString stringWithFormat:@"%0ld",seconds/3600];
    if (second<10) {
        str_second = [NSString stringWithFormat:@"0%ld",seconds%60];
    }else{
        str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    }
    
    if ([str_hour integerValue]!= 0) {
        if (minute<10) {
            str_minute = [NSString stringWithFormat:@"0%ld",(seconds%3600)/60];
        }else{
            str_minute = [NSString stringWithFormat:@"%ld",(seconds%3600)/60];
        }
        
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        
    }else{
        if (minute<10) {
            str_minute = [NSString stringWithFormat:@"0%ld",seconds/60];
        }else{
            str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
        }
        
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
    }
    //    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

//判断两个日期是否是同一天
+(BOOL)isDateStartTime:(NSString *)startTime inSameDayAsDate:(NSString *)endTime{
    
    NSTimeZone *zone=[NSTimeZone systemTimeZone];//得到时区，根据手机系统时区设置（systemTimeZone）
      NSDateFormatter *date = [[NSDateFormatter alloc]init];
      [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
      NSDate *startD =[date dateFromString:startTime];
      NSInteger nowInterval=[zone secondsFromGMTForDate:startD];
      //将偏移量加到当前日期
      NSDate *nowTime=[startD dateByAddingTimeInterval:nowInterval];
      NSDate *endD = [date dateFromString:endTime];
      NSInteger nowInterval1=[zone secondsFromGMTForDate:endD];
      //将偏移量加到当前日期
      NSDate *nowTime1=[endD dateByAddingTimeInterval:nowInterval1];
        BOOL isToday = [[NSCalendar currentCalendar] isDate:nowTime inSameDayAsDate:nowTime1];
        if(isToday) {
           return YES;
        }
    return NO;
}

//判断是否是今天
+ (BOOL)checkTheDate:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [format dateFromString:string];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:localeDate];
    if(isToday) {
       return YES;
    }
return NO;
}

//判断一个日期是否是昨天
+ (BOOL)isDateInYesterday:(NSString *)string{
    NSDate * date = [self setDateYYMMDDHHSSMM:string];
        BOOL isToday = [[NSCalendar currentCalendar] isDateInYesterday:date];
        if(isToday) {
           return YES;
        }
    return NO;
}

//判断一个日期是否是明天
+ (BOOL)isDateInTomorrow:(NSString *)string{
    
    NSDate * date = [self setDateYYMMDDHHSSMM:string];
        BOOL isToday = [[NSCalendar currentCalendar] isDateInTomorrow:date];
        if(isToday) {
           return YES;
        }
    return NO;
}
//判断一个日期是否是在本周
+ (BOOL)isDateInWeekend:(NSString *)string{
    NSDate * date = [self setDateYYMMDDHHSSMM:string];
        BOOL isToday = [[NSCalendar currentCalendar] isDateInWeekend:date];
        if(isToday) {
           return YES;
        }
    return NO;
}
+(NSString *)compareDate:(NSString *)date{
        
    if ([self checkTheDate:date] == YES) {
        return @"今天";
    }else if ([self isDateInYesterday:date])
    {
        return @"昨天";
    }
    return date;
}
@end
