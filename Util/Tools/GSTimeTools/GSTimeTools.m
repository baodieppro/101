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
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

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

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
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

+(NSString *)getDateDisplayString:(long long)miliSeconds{
    
     NSLog(@"-时间戳---%lld_----",miliSeconds);
    
     NSTimeInterval tempMilli = miliSeconds;
    
     NSTimeInterval seconds = tempMilli/1000.0;
    
     NSDate *myDate =[NSDate dateWithTimeIntervalSince1970:seconds];
    
     NSCalendar *calendar =[NSCalendar currentCalendar];
    
     int unit = NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear;
    
     NSDateComponents *nowCmps =[calendar components:unit fromDate:[NSDate date]];
    
     NSDateComponents *myCmps =[calendar components:unit fromDate:myDate];
    
     NSDateFormatter *dateFmt =[[NSDateFormatter alloc]init];
    
     //2.指定日历对象,要去取日期对象的那些部分.
    
     NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if(nowCmps.year != myCmps.year){

        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";

    } else {

        if(nowCmps.day==myCmps.day){

                dateFmt.AMSymbol = @"上午";

                dateFmt.PMSymbol = @"下午";

                dateFmt.dateFormat = @"aaa hh:mm";



        } else if((nowCmps.day-myCmps.day)==1){

                dateFmt.dateFormat = @"昨天";

        } else {

                if((nowCmps.day-myCmps.day)<=7){

                    switch(comp.weekday){

                        case 1:

                         dateFmt.dateFormat = @"星期日";

                         break;

                        case 2:

                        dateFmt.dateFormat = @"星期一";

                        break;

                        case 3:

                        dateFmt.dateFormat = @"星期二";

                        break;

                        case 4:

                        dateFmt.dateFormat = @"星期三";

                        break;

                        case 5:

                        dateFmt.dateFormat = @"星期四";

                        break;

                        case 6:

                        dateFmt.dateFormat = @"星期五";

                        break;

                        case 7:

                        dateFmt.dateFormat = @"星期六";

                        break;

                        default:

                    break;

                    }

                }else {

                dateFmt.dateFormat = @"MM-dd hh:mm";

                }

            }

    }

 return[dateFmt stringFromDate:myDate];

}

@end
