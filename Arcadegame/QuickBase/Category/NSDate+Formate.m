//
//  NSDate+Formate.m
//
//  Created by on 15/3/18.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "NSDate+Formate.h"

@implementation NSDate (Formate)

/*
 * 2015/02/05 19:45:08
 */
+ (NSString *)stringDate_year_to_second:(NSTimeInterval )timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *string = [[NSDateFormatter year_to_secondFormatter] stringFromDate:date];
    return string;
}

/*
 * 2015/02/05
 */
+ (NSString *)stringDate_year_to_day:(NSTimeInterval)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *string = [self stringDate_year_to_dayWithDay:date];
    return string;
}

+ (NSString *)stringDate_year_to_dayWithDay:(NSDate *)date{
    NSString *string = [[NSDateFormatter YYYY_MM_dd_Formatter] stringFromDate:date];
    return string;
}


/** 小时:分钟
 *  10:00
 */
+ (NSString *)stringDate_hour_minute:(NSTimeInterval)timeInterval{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self stringDate_hour_minute_day:date];
}

+ (NSString *)stringDate_hour_minute_day:(NSDate *)date{
    NSString *string = [[NSDateFormatter HH_mm_Formatter] stringFromDate:date];
    return string;
}


/*
 * 预告列表时间显示
 */
+ (NSString *)timeLineDate:(NSTimeInterval)toCompare start:(NSTimeInterval)start end:(NSTimeInterval)end{
    if (toCompare > end) {
        return @"继续售卖";
    }
    //正在售卖
    else if (start < toCompare && end > toCompare)
    {
        return @"正在售卖";
    }
    //预告
    else if (start > toCompare){
        NSDateFormatter *formatter ;//[[NSDateFormatter alloc] init];

        NSInteger startDays = start / (24 * 60 * 60);
        NSInteger compareDays = toCompare / (24 * 60 * 60);
        if (compareDays - startDays == 0) {
            formatter = [NSDateFormatter HH_mm_Formatter];
        }else if (startDays - compareDays == 1){
            formatter = [NSDateFormatter tomorrow_HH_mm_Formatter];
        }else{
            formatter = [NSDateFormatter MM_dd_Formatter];
        }
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
        
        return [formatter stringFromDate:startDate];
    }
    return @"";
}



/*
 * 支付时间倒计时
 */
+ (NSString *)remainTime:(NSTimeInterval)remainTime{
    NSTimeInterval oneDay   = 24 * 60 * 60;
    NSTimeInterval oneHour  = 60 * 60;
    NSTimeInterval oneMinute= 60;
    NSInteger dayNumber = remainTime/oneDay;
    NSInteger hourNum   = fmod(remainTime, oneDay)/oneHour;
    NSInteger minuteNumber = fmod(remainTime, oneHour)/oneMinute;
    NSInteger secondNumber = fmod(remainTime, oneMinute);
    
    NSString *remainTime_str = @"";
    if (dayNumber) {
        remainTime_str = [remainTime_str stringByAppendingFormat:@"%d天",dayNumber];
    }
    if (hourNum) {
        remainTime_str = [remainTime_str stringByAppendingFormat:@"%d小时",hourNum];
    }
    if (minuteNumber) {
        remainTime_str = [remainTime_str stringByAppendingFormat:@"%d分",minuteNumber];
    }
    if (secondNumber) {
        remainTime_str = [remainTime_str stringByAppendingFormat:@"%d秒",secondNumber];
    }
    
    return remainTime_str;
}

/**
 *  消息时间
 *  当天消息   小时:分钟
 *  非当天消息 年/月/日
 */
+ (NSString *)messageTime:(NSTimeInterval)time{
    time = [self convertToSecond:time];
    NSDate * messageTime = [NSDate dateWithTimeIntervalSince1970:time];
    if ([messageTime isToday]) {
        return [self stringDate_hour_minute_day:messageTime];
    }
    return [self stringDate_year_to_dayWithDay:messageTime];
}


/**
 *  时间转换成秒  毫秒则除以1000
 */
+ (NSTimeInterval)convertToSecond:(NSTimeInterval)time{
    static NSTimeInterval nowInterval = 0;
    if (nowInterval < 0.1f) {
        nowInterval = [[NSDate date] timeIntervalSince1970];
    }
    if (time/nowInterval > 100) {
        return time/1000.f;
    }
    return time;
}


- (BOOL)isToday{
    NSTimeInterval oneDayinterval = 24 * 60 * 60;
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval selfInterva = [self timeIntervalSince1970];
    float day = nowInterval/oneDayinterval;
    float selfDays = selfInterva/oneDayinterval;
    NSInteger intergarDay = day;
    NSInteger intergarSELF= selfDays;
    if (intergarDay - intergarSELF == 0) {
        return YES;
    }
    return NO;
}
@end



@implementation NSDateFormatter (custom_fomatter)

/*
 * 2015/02/05 19:45:08
 */
+ (instancetype)year_to_secondFormatter{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    }
    return formatter;
}

/*
 * 2015/02/05
 */
+ (instancetype)YYYY_MM_dd_Formatter{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd"];
    }
    return formatter;
}

/** 小时:分钟
 *  10:00
 */
+ (instancetype)HH_mm_Formatter{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }
    return formatter;
}

/**
 *  @"明天 HH:mm"
 */
+ (instancetype)tomorrow_HH_mm_Formatter{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"明天 HH:mm"];
    }
    return formatter;
}

/**
 *  @"MM/dd"
 */
+ (instancetype)MM_dd_Formatter{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd"];
    }
    return formatter;
}

@end
