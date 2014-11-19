//
//  PDTimeConversions.m
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import "PDTimeConversions.h"

@implementation PDTimeConversions

#pragma mark - date/time conversions

+ (double)getSolarMeanAnomalyWithDayNumber:(double)d {
    return M_PI/180.0 * (357.5291 + 0.98560028 * d);
}

+ (double)getEquationOfCenterWithSolarMean:(double)M {
    return M_PI/180.0 * (1.9148 * sin(M) + 0.02 * sin(2*M) + 0.0003 * sin(3*M));
}

+ (double)getEclipticLongitudeWithSolarMean:(double)M andCenter:(double)C {
    double P = M_PI/180.0 * 102.9372; // điểm cận nhật của trái đất.
    return M + C + P + M_PI;
}

+ (double)e{
    return M_PI/180.0 * 23.4397;//obliquity(do nghieng) of the Earth
}

+ (double)getDeclinationWithLongitude:(double)l andLatitude:(double)b {
    return asin(sin(b) * cos(self.e) + cos(b) * sin(self.e) *sin(l));
}

+ (double)getRightAscensionWithLongitude:(double)l andLatitude:(double)b {
    return atan2(sin(l) * cos(self.e) - tan(b) * sin(self.e), cos(l));
}

+ (double)secondInDay {
    return 60*60*24 ;
}

+ (double)J1970 {
    return 2440588;
}

+ (double)J2000 {
    return 2451545;
}

+ (NSDate *)getJulianDate:(NSDateFormatter *)dateFormatter
{
    NSString *JulianString = @"1970-01-01 00:00:00";
    return [dateFormatter dateFromString:JulianString];
}

+ (double) toJulian:(NSDate*)date dateFormatter:(NSDateFormatter *)dateFormatter {
    
    NSTimeInterval differentBetweenDates = [date timeIntervalSinceDate:[self getJulianDate:dateFormatter]];
    return differentBetweenDates/ self.secondInDay - 0.5 + self.J1970;
}

+ (double)toDays:(NSDate*)date dateFormatter:(NSDateFormatter *)dateFormatter{
    return [self toJulian:date dateFormatter:dateFormatter] - self.J2000;
}

+ (double)getSiderealTimeWithDayNumber:(double)d andObserverLongitude:(double)lw{
    return M_PI/180.0 * (280.16 + 360.9856235 * d) - lw;
}

+ (double)getAzimuthWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec {
    return M_PI + atan2(sin(H), cos(H)*sin(phi) - tan(dec) * cos(phi));
}

+ (double)getAltitudeWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec {
    return asin(sin(phi)*sin(dec) + cos(phi)*cos(dec)*cos(H));
}

+ (double)J0 {
    return 0.0009;
}

+ (NSDate *)fromJulian:(double)j dateFormatter:(NSDateFormatter *)dateFormatter{
    double timeInterval = (j+ 0.5 - self.J1970) * [self secondInDay];
    NSDate * date = [NSDate dateWithTimeInterval:timeInterval sinceDate:[self getJulianDate:dateFormatter]];
    return date;
}

+ (double)getJulianCycleWithDayNumber:(double)d andObserverLongitude:(double)lw {
    return round(d-self.J0-lw/(2*M_PI));
}

+ (double)getApproxTransitWithHourAngle:(double)Ht andObserverLongitude:(double)lw andJulianCycle:(double)n {
    return self.J0 + (Ht + lw)/(2*M_PI) + n;
}

+ (double)getSolarTransitJWithApproxTransit:(double)ds andSolarMeanTime:(double)M andEclipticLongitude:(double)L {
    return self.J2000 + ds + 0.0053*sin(M) - 0.0069 * sin(2*L);
}

+ (double)getHourAngleWithAltitude:(double)h andObserverLatitude:(double)phi andDeclination:(double)d {
    return acos((sin(h) - sin(phi)*sin(d))/(cos(phi) *cos(d)));
}

@end
