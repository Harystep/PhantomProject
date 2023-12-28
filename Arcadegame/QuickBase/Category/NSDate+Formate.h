//
//  NSDate+Formate.h
//
//  Created by on 15/3/18.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formate)

/*
 * 2015/02/05 19:45:08
 */
+ (NSString *)stringDate_year_to_second:(NSTimeInterval)timeInterval;

/*
 * 2015/02/05
 */
+ (NSString *)stringDate_year_to_day:(NSTimeInterval)timeInterval;
+ (NSString *)stringDate_year_to_dayWithDay:(NSDate *)date;

/** 小时:分钟
 *  10:00
 */
+ (NSString *)stringDate_hour_minute:(NSTimeInterval)timeInterval;
+ (NSString *)stringDate_hour_minute_day:(NSDate *)date;

/*
 * 预告列表时间显示
 */
+ (NSString *)timeLineDate:(NSTimeInterval)toCompare start:(NSTimeInterval)start end:(NSTimeInterval)end;

/*
 * 支付时间倒计时
 */
+ (NSString *)remainTime:(NSTimeInterval)remainTime;

+ (NSTimeInterval)convertToSecond:(NSTimeInterval)time;

/**
 *  消息时间
 *  当天消息   小时:分钟
 *  非当天消息 年/月/日
 */
+ (NSString *)messageTime:(NSTimeInterval)time;

- (BOOL)isToday;

@end






/**
 *  日期fomatter
 */
@interface NSDateFormatter (custom_fomatter)


/*
 * 2015/02/05 19:45:08
 */
+ (instancetype)year_to_secondFormatter;

/*
 * 2015/02/05
 */
+ (instancetype)YYYY_MM_dd_Formatter;

/** 小时:分钟
 *  10:00
 */
+ (instancetype)HH_mm_Formatter;

/**
 *  @"明天 HH:mm"
 */
+ (instancetype)tomorrow_HH_mm_Formatter;

/**
 *  @"MM/dd"
 */
+ (instancetype)MM_dd_Formatter;

@end
