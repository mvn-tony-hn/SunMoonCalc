//
//  PDSetPosition.m
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import "PDSetPosition.h"
#import "SunMoonCalcGlobal.h"
#import "SunCoordinate.h"
#import "MoonCoordinate.h"
#import "PDTimeConversions.h"

@implementation PDSetPosition

#pragma mark - set point

- (CGPoint )setPoint:(BOOL)isHiddenPoint andAzimuth:(double)azimuth andAltitude:(double)altitude
{
    CGPoint point;
    if (isHiddenPoint) {
        point = kCenterPoint;
    } else{
        double angle =  azimuth - M_PI_2;
        float x = centerAnnotationPoint + 100 *cos(angle)*cos(altitude);
        float y = centerAnnotationPoint + 100 *sin(angle)*cos(altitude);
        point = CGPointMake(x, y);
    }
    return point;
}

#pragma mark - set sun position

- (PDSunMoonPoint *)setSun:(PDSunMoonEntity *)sunEntity dateFormatter:(NSDateFormatter *)dateFormatter
{
    _sunPoint = [PDSunMoonPoint new];
    _sunPoint.pointRise = [self setPoint:!sunEntity.Rise andAzimuth:sunEntity.azimuthRise * M_PI/180.0 andAltitude:0];
    _sunPoint.pointSet = [self setPoint:!sunEntity.Set andAzimuth:sunEntity.azimuthSet * M_PI/180.0 andAltitude:0];
    _sunPoint.pointNow = [self getSunPosition:sunEntity dateFormatter:dateFormatter];
    return _sunPoint;
}

- (SunCoordinate*)getSunCoordsWithDayNumber:(double)julianDay {
    double M = [PDTimeConversions getSolarMeanAnomalyWithDayNumber:julianDay];
    double C = [PDTimeConversions getEquationOfCenterWithSolarMean:M];
    double L = [PDTimeConversions getEclipticLongitudeWithSolarMean:M andCenter:C];
    SunCoordinate *sunCoordinate = [[SunCoordinate alloc] initWithDeclination:[PDTimeConversions getDeclinationWithLongitude:L andLatitude:0]
                                                            andRightAscension:[PDTimeConversions getRightAscensionWithLongitude:L andLatitude:0]];
    return sunCoordinate;
}

- (CGPoint )getSunPosition:(PDSunMoonEntity*)sunEntity dateFormatter:(NSDateFormatter *)dateFormatter{
    double lw = M_PI/180.0 * (-sunEntity.longitude);
    double phi = M_PI/180.0 * sunEntity.latitude;
    double d = [PDTimeConversions toDays:sunEntity.timeNow dateFormatter:dateFormatter];
    SunCoordinate * c = [[SunCoordinate alloc]init ];
    c = [self getSunCoordsWithDayNumber:d];
    
    double H = [PDTimeConversions getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    
    SunPosition *sunPosition = [[SunPosition alloc] initWithAzimuth:[PDTimeConversions getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination]
                                                        andAltitude:[PDTimeConversions getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination]];
    return [self setSunPosition:sunPosition withSunEntity:sunEntity dateFormatter:dateFormatter];
}

- (CGPoint )setSunPosition:(SunPosition *)sunPostion withSunEntity:(PDSunMoonEntity *)sunEntity dateFormatter:(NSDateFormatter *)dateFormatter
{
    BOOL sunPositionHidden;
    
    if ((!sunEntity.Rise)&&(!sunEntity.Set))                 // neither sunrise nor sunset
    {
        sunPositionHidden = (sunEntity.vhz2 < 0);
    }
    else if ((!sunEntity.Rise)||(!sunEntity.Set))                                    // sunrise or sunset
    {
        if (!sunEntity.Rise)
            sunPositionHidden = (sunEntity.timeNow.timeIntervalSince1970 > sunEntity.timeSet.timeIntervalSince1970);
        else
            sunPositionHidden = (sunEntity.timeNow.timeIntervalSince1970 < sunEntity.timeRise.timeIntervalSince1970);
    }
    else  {
        sunPositionHidden = (sunEntity.timeNow.timeIntervalSince1970 < sunEntity.timeRise.timeIntervalSince1970 || sunEntity.timeNow.timeIntervalSince1970 > sunEntity.timeSet.timeIntervalSince1970);
    }
    return [self setPoint:sunPositionHidden andAzimuth:sunPostion.azimuth andAltitude:sunPostion.altitude];
}

#pragma mark - set moon position

- (PDSunMoonPoint *)setMoon:(PDSunMoonEntity *)moonEntity dateFormatter:(NSDateFormatter *)dateFormatter
{
    _moonPoint = [PDSunMoonPoint new];
    _moonPoint.pointRise = [self setPoint:!moonEntity.Rise andAzimuth:moonEntity.azimuthRise * M_PI/180.0 andAltitude:0];
    _moonPoint.pointSet = [self setPoint:!moonEntity.Set andAzimuth:moonEntity.azimuthSet * M_PI/180.0 andAltitude:0];
    _moonPoint.pointNow = [self getMoonPosition:moonEntity dateFormatter:dateFormatter];
    return _moonPoint;
}

- (MoonCoordinate *)getMoonCoords:(double)julianday { // geocentric ecliptic coordinates of the moon
    double L = M_PI/180.0 * (218.316 + 13.176396 * julianday), // ecliptic longitude
    M = M_PI/180.0 * (134.963 + 13.064993 * julianday), // mean anomaly
    F = M_PI/180.0 * (93.272 + 13.229350 * julianday), // mean distance
    
    l = L + M_PI/180.0 * 6.289 * sin(M), // longitude
    b = M_PI/180.0 * 5.128 * sin(F), // latitude
    dt = 385001 - 20905 * cos(M); // distance to the moon in km
    MoonCoordinate *moonCoordinate = [[MoonCoordinate alloc] initWithDeclination:[PDTimeConversions getDeclinationWithLongitude:l andLatitude:b]
                                                               andRightAscension:[PDTimeConversions getRightAscensionWithLongitude:l andLatitude:b]
                                                                     andDistance:dt];
    return moonCoordinate;
}

- (CGPoint)getMoonPosition:(PDSunMoonEntity*)moonEntity dateFormatter:(NSDateFormatter *)dateFormatter{
    double lw = M_PI/180.0 * -moonEntity.longitude;
    double phi = M_PI/180.0 * moonEntity.latitude;
    double d = [PDTimeConversions toDays:moonEntity.timeNow dateFormatter:dateFormatter];
    
    MoonCoordinate *c = [self getMoonCoords:d];
    double H = [PDTimeConversions getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    double h = [PDTimeConversions getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination];
    
    // altitude correction for refraction
    h = h + M_PI/180.0 * 0.017 / tan(h + M_PI/180.0 * 10.26 / (h + M_PI/180.0 * 5.10));
    MoonPosition *moonPosition = [[MoonPosition alloc] initWithAzimuth:[PDTimeConversions getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination]
                                                           andAltitude:h
                                                           andDistance:c.distance];
    return [self setMoonPosition:moonPosition withMoonEntity:moonEntity dateFormatter:dateFormatter];
}

- (CGPoint )setMoonPosition:(MoonPosition *)moonPostion withMoonEntity:(PDSunMoonEntity*)moonEntity dateFormatter:(NSDateFormatter *)dateFormatter{
    {
        BOOL moonPositionHidden;
        if ((!moonEntity.Rise)&&(!moonEntity.Set))                 // neither sunrise nor sunset
        {
            moonPositionHidden = (moonEntity.vhz2 < 0);
            moonEntity.haveMoon = !moonPositionHidden;
        }
        else if ((!moonEntity.Rise)||(!moonEntity.Set))                                    // sunrise or sunset
        {
            moonEntity.haveMoon = YES;
            if (!moonEntity.Rise)
                moonPositionHidden = (moonEntity.timeNow.timeIntervalSince1970 > moonEntity.timeSet.timeIntervalSince1970);
            else
                moonPositionHidden = (moonEntity.timeNow.timeIntervalSince1970 < moonEntity.timeRise.timeIntervalSince1970);
        }
        else  {
            moonEntity.haveMoon = YES;
            if (moonEntity.timeRise.timeIntervalSince1970  > moonEntity.timeSet.timeIntervalSince1970)
                moonPositionHidden =  ( moonEntity.timeNow.timeIntervalSince1970 < moonEntity.timeRise.timeIntervalSince1970 && moonEntity.timeNow.timeIntervalSince1970 > moonEntity.timeSet.timeIntervalSince1970 );
            else
                moonPositionHidden = (moonEntity.timeNow.timeIntervalSince1970 < moonEntity.timeRise.timeIntervalSince1970 || moonEntity.timeNow.timeIntervalSince1970 > moonEntity.timeSet.timeIntervalSince1970 );
        }
        return [self setPoint:moonPositionHidden andAzimuth:moonPostion.azimuth andAltitude:moonPostion.altitude];
    }
}

@end

