//
//  NSDate+Functions.m
//  Pashadelic
//
//  Created by LongPD on 9/18/13.
//
//

#import "NSDate+Functions.h"

@implementation NSDate (Functions)

-(NSString *)conVertDateToStringMonth
{
    NSDateFormatter *dfMonth = [[NSDateFormatter alloc]init];
    [dfMonth setDateFormat:@"MM"];
    NSString *monthString = [dfMonth stringFromDate:self];
    return monthString;
}

-(NSString *)conVertDateToStringYear
{
    NSDateFormatter *dfYear = [[NSDateFormatter alloc]init];
    [dfYear setDateFormat:@"yyyy"];
    NSString *yearString = [dfYear stringFromDate:self];
    return yearString;
}

-(NSString *)conVertDateToStringMinute
{
    NSDateFormatter *dfMinute = [[NSDateFormatter alloc]init];
    [dfMinute setDateFormat:@"mm"];
    NSString *minuteString = [dfMinute stringFromDate:self];
    return minuteString;
}

-(NSString *)conVertDateToStringHour
{
    NSDateFormatter *dfHour = [[NSDateFormatter alloc]init];
    [dfHour setDateFormat:@"HH"];
    NSString *hourString = [dfHour stringFromDate:self];
    return hourString;
}

-(NSString *)conVertDateToStringDay
{
    NSDateFormatter *dfDay = [[NSDateFormatter alloc]init];
    [dfDay setDateFormat:@"dd"];
    NSString *dayString = [dfDay stringFromDate:self];
    return dayString;
}


-(NSString *)conVertDateToStringMonthName
{
    NSDateFormatter *dfMonth = [[NSDateFormatter alloc]init];
    [dfMonth setDateFormat:@"MMMM"];
    NSString *monthString = [[dfMonth stringFromDate:self] capitalizedString];
    monthString = [monthString substringToIndex:3];
    return monthString;
}
-(NSString *)conVertDateToStringDayOfWeekName
{
    NSDateFormatter *dfWeekDay = [[NSDateFormatter alloc]init];
    [dfWeekDay setDateFormat:@"EEEE"];
    NSString *weekDayString = [[dfWeekDay stringFromDate:self] capitalizedString];
    weekDayString = [weekDayString substringToIndex:3];
    return weekDayString;
}

@end
