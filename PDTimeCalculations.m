//
//  PDSunCalculations.m
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import "PDTimeCalculations.h"

@implementation PDTimeCalculations

+ (int)sgn:( double )x
{
    int rv;
    if (x > 0.0)      rv =  1;
    else if (x < 0.0) rv = -1;
    else              rv =  0;
    return rv;
}

+ (double)interpolate:(double)f0 withf1:(double)f1 withf2:(double)f2 withp:(double)p
{
    double a = f1 - f0;
    double b = f2 - f1 - a;
    double f = f0 + p * ( 2*a + b * ( 2 * p - 1));
    return f;
}

+ (double)lst :(double )longitude withJday:(double)jday withZ:(double)z
{
    double s = 24110.5 + 8640184.812999999 * jday / 36525 + 86636.6 * z + 86400 * longitude;
    s = s/86400.0;
    s = s - floor(s);
    s = s * 360.0 * M_PI/180.0;
    return s;
}

+ (double)julian_day :(int)year withMonth:(int)month withDay:(int)day
{
    double a, b, jd;
    BOOL gregorian;
    month = month ;
    gregorian = (year < 1583) ? false : true;
    if ((month == 1)||(month == 2))
    {
        year  = year  - 1;
        month = month + 12;
    }
    a = floor(year/100.0) ;
    if (gregorian){
        b = 2 - a + floor(a/4.0);
    }
    else{
        b = 0.0;
    }
    jd = floor(365.25 * (year + 4716)) + floor(30.6001 * (month + 1)) + day + b - 1524.5;
    return jd;
}

@end
