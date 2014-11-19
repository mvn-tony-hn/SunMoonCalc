//
//  PDTimeConversions.h
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import <Foundation/Foundation.h>

@interface PDTimeConversions : NSObject

+ (double)getSolarMeanAnomalyWithDayNumber:(double)d ;
+ (double)getEquationOfCenterWithSolarMean:(double)M ;
+ (double)getEclipticLongitudeWithSolarMean:(double)M andCenter:(double)C ;
+ (double)e;
+ (double)getDeclinationWithLongitude:(double)l andLatitude:(double)b ;
+ (double)getRightAscensionWithLongitude:(double)l andLatitude:(double)b ;
+ (double)secondInDay ;
+ (double)J1970 ;
+ (double)J2000 ;
+ (NSDate *)getJulianDate:(NSDateFormatter *)dateFormatter;
+ (double) toJulian:(NSDate*)date dateFormatter:(NSDateFormatter *)dateFormatter;
+ (double)toDays:(NSDate*)date dateFormatter:(NSDateFormatter *)dateFormatter;
+ (double)getSiderealTimeWithDayNumber:(double)d andObserverLongitude:(double)lw;
+ (double)getAzimuthWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec ;
+ (double)getAltitudeWithHourAngle:(double)H observerLatitude:(double)phi andDeclination:(double)dec ;
+ (double)J0 ;
+ (NSDate *)fromJulian:(double)j dateFormatter:(NSDateFormatter *)dateFormatter;
+ (double)getJulianCycleWithDayNumber:(double)d andObserverLongitude:(double)lw ;
+ (double)getApproxTransitWithHourAngle:(double)Ht andObserverLongitude:(double)lw andJulianCycle:(double)n ;
+ (double)getSolarTransitJWithApproxTransit:(double)ds andSolarMeanTime:(double)M andEclipticLongitude:(double)L ;
+ (double)getHourAngleWithAltitude:(double)h andObserverLatitude:(double)phi andDeclination:(double)d ;

@end
