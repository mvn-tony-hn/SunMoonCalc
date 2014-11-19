//
//  SunMoonCalcGobal.m
//  SunMoonCalcGobal
//
//  Created by Duc Long on 4/11/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//
#import "SunCoordinate.h"
#import "SunMoonCalcGlobal.h"
#import "MoonCoordinate.h"
#import "PDTimeConversions.h"
#import "PDTimeCalculations.h"
#import "PDSetPosition.h"

double DR = M_PI/180.0;
double K1 = 15 * M_PI/180.0 * 1.0027379 ;
double SkyM[3] = {0.0,0.0,0.0} ;
double RAnM[3] = {0.0,0.0,0.0};
double DecM[3] = {0.0,0.0,0.0};
double VHzM[3] = {0.0,0.0,0.0};
int Rise_timeM[2] = {0 , 0};
int Set_timeM[2] = {0,0};
double Rise_azM = 0.0;
double Set_azM = 0.0;

double SkyS[3] = {0.0,0.0,0.0} ;
double RAnS[3] = {0.0,0.0,0.0};
double DecS[3] = {0.0,0.0,0.0};
double VHzS[3] = {0.0,0.0,0.0};
int Rise_timeS[2] = {0 , 0};
int Set_timeS[2] = {0,0};
double Rise_azS = 0.0;
double Set_azS = 0.0;

@implementation SunMoonCalcGlobal
@synthesize positionEntity;

- (id)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        _dateFormatterConvert = [[NSDateFormatter alloc] init];
        positionEntity = [[PositionEntity alloc]init];
        _sunEntity = [PDSunMoonEntity new];
        _moonEntity = [PDSunMoonEntity new];
    }
    return self;
}

#pragma mark - suntimes

// sun times configuration
- (NSMutableArray*)times {
    NSMutableArray *times = [[NSMutableArray alloc]init ];
    NSArray *temp;
    temp = [[NSArray alloc]initWithObjects: @"-0.83",@"sunrise",@"sunset", nil ];
    [times addObject:temp];
    temp = [[NSArray alloc]initWithObjects:@"-0.3",@"sunriseEnd", @"sunsetStart", nil];
    [times addObject:temp];
    temp = [[NSArray alloc]initWithObjects:@"-6",@"dawn",@"dusk", nil];
    [times addObject:temp];
    temp = [[NSArray alloc]initWithObjects:@"-12",@"nauticalDawn",@"nauticalDusk", nil];
    [times addObject:temp];
    temp = [[NSArray alloc]initWithObjects:@"-18",@"nightEnd",@"night", nil ];
    [times addObject:temp];
    temp = [[NSArray alloc]initWithObjects:@"6",@"goldenHourEnd",@"goldenHour", nil];
    [times addObject:temp];
    return times;
}
// get sun times

- (NSDictionary *)getSunTimesWithDate:(NSDate *)date andLatitude:(double)lat andLogitude:(double)lng {
    
    double lw = DR * -lng;
    double phi = DR * lat;
    double d = [PDTimeConversions toDays:date dateFormatter:_dateFormatter];
    double n = [PDTimeConversions getJulianCycleWithDayNumber:d andObserverLongitude:lw];
    double ds = [PDTimeConversions getApproxTransitWithHourAngle:0 andObserverLongitude:lw andJulianCycle:n];
    
    double M = [PDTimeConversions getSolarMeanAnomalyWithDayNumber:ds];
    double C = [PDTimeConversions getEquationOfCenterWithSolarMean:M];
    double L = [PDTimeConversions getEclipticLongitudeWithSolarMean:M andCenter:C];
    
    double dec = [PDTimeConversions getDeclinationWithLongitude:L andLatitude:0];
    double Jnoon = [PDTimeConversions getSolarTransitJWithApproxTransit:ds andSolarMeanTime:M andEclipticLongitude:L];
    
    NSMutableDictionary *sunTimes = [[NSMutableDictionary alloc]init ];
    
    [sunTimes setValue:[PDTimeConversions fromJulian:Jnoon dateFormatter:_dateFormatter] forKey:@"solarNoon"];
    [sunTimes setValue:[PDTimeConversions fromJulian:(Jnoon-0.05) dateFormatter:_dateFormatter] forKey:@"nadir"];
    NSArray *time = [[NSArray alloc]init ];
    for(int i = 0 ;i < [self times].count;i++) {
        time = [[self times]objectAtIndex:i];
        double temp = [[time objectAtIndex:0] doubleValue] * DR;
        double w = [PDTimeConversions getHourAngleWithAltitude:temp andObserverLatitude:phi andDeclination:dec];
        double a = [PDTimeConversions getApproxTransitWithHourAngle:w andObserverLongitude:lw andJulianCycle:n];
        double Jset = [PDTimeConversions getSolarTransitJWithApproxTransit:a andSolarMeanTime:M andEclipticLongitude:L];
        double Jrise = Jnoon - (Jset - Jnoon);
        [sunTimes setValue:[PDTimeConversions fromJulian:Jrise dateFormatter:_dateFormatter] forKey:[NSString stringWithFormat:@"%@",[time objectAtIndex:1]]];
        [sunTimes setValue:[PDTimeConversions fromJulian:Jset dateFormatter:_dateFormatter]  forKey:[NSString stringWithFormat:@"%@",[time objectAtIndex:2]]];
        
    }
    return sunTimes;
}

- (MoonCoordinate *)getMoonCoords:(double)julianday { // geocentric ecliptic coordinates of the moon
    double L = DR * (218.316 + 13.176396 * julianday), // ecliptic longitude
    M = DR * (134.963 + 13.064993 * julianday), // mean anomaly
    F = DR * (93.272 + 13.229350 * julianday), // mean distance
    
    l = L + DR * 6.289 * sin(M), // longitude
    b = DR * 5.128 * sin(F), // latitude
    dt = 385001 - 20905 * cos(M); // distance to the moon in km
    MoonCoordinate *moonCoordinate = [[MoonCoordinate alloc] initWithDeclination:[PDTimeConversions getDeclinationWithLongitude:l andLatitude:b]
                                                               andRightAscension:[PDTimeConversions getRightAscensionWithLongitude:l andLatitude:b]
                                                                     andDistance:dt];
    return moonCoordinate;
}

- (SunCoordinate*)getSunCoordsWithDayNumber:(double)julianDay {
    double M = [PDTimeConversions getSolarMeanAnomalyWithDayNumber:julianDay];
    double C = [PDTimeConversions getEquationOfCenterWithSolarMean:M];
    double L = [PDTimeConversions getEclipticLongitudeWithSolarMean:M andCenter:C];
    SunCoordinate *sunCoordinate = [[SunCoordinate alloc] initWithDeclination:[PDTimeConversions getDeclinationWithLongitude:L andLatitude:0]
                                                            andRightAscension:[PDTimeConversions getRightAscensionWithLongitude:L andLatitude:0]];
    return sunCoordinate;
}

- (SunPosition *)getSunPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng {
    double lw = DR * (-lng);
    double phi = DR * lat;
    double d = [PDTimeConversions toDays:date dateFormatter:_dateFormatter];
    SunCoordinate * c = [[SunCoordinate alloc]init ];
    c = [self getSunCoordsWithDayNumber:d];
    
    double H = [PDTimeConversions getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    
    SunPosition *sunPosition = [[SunPosition alloc] initWithAzimuth:[PDTimeConversions getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination]
                                                        andAltitude:[PDTimeConversions getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination]];
    return sunPosition;
}

- (MoonPosition *)getMoonPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng {
    double lw = DR * -lng;
    double phi = DR * lat;
    double d = [PDTimeConversions toDays:date dateFormatter:_dateFormatter];
    
    MoonCoordinate *c = [self getMoonCoords:d];
    double H = [PDTimeConversions getSiderealTimeWithDayNumber:d andObserverLongitude:lw] - c.rightAscension;
    double h = [PDTimeConversions getAltitudeWithHourAngle:H observerLatitude:phi andDeclination:c.declination];
    
    // altitude correction for refraction
    h = h + DR * 0.017 / tan(h + DR * 10.26 / (h + DR * 5.10));
    MoonPosition *moonPosition = [[MoonPosition alloc] initWithAzimuth:[PDTimeConversions getAzimuthWithHourAngle:H observerLatitude:phi andDeclination:c.declination]
                                                           andAltitude:h
                                                           andDistance:c.distance];
    return moonPosition;
}



#pragma mark - get Moon Fraction

- (double)getMoonFraction:(NSDate *)date
{
    double d = [PDTimeConversions toDays:date dateFormatter:_dateFormatter];
    MoonCoordinate *moonCoordinate = [self getMoonCoords:d];
    SunCoordinate *sunCoordinate = [self getSunCoordsWithDayNumber:d];
    double sdist = 149598000.0;// distance from Earth to Sun in km
    double phi = acos(sin(sunCoordinate.declination) * sin(moonCoordinate.declination) + cos(sunCoordinate.declination) * cos(moonCoordinate.declination) * cos(sunCoordinate.rightAscension - moonCoordinate.rightAscension));
    double inc = atan2(sdist * sin(phi), moonCoordinate.distance - sdist * cos(phi));
    return (1 + cos(inc)) / 2.0f;
}

#pragma mark - compute moonrise and moon set

- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng{
    
    Rise_azM = 0.0;
    Set_azM = 0.0;
    Rise_timeM[0] = 0.0;
    Rise_timeM[1] = 0.0;
    Set_timeM[0] = 0.0;
    Set_timeM[1] = 0.0;
    VHzM[2] = 0.0;
    
    double x = lng;
    double zone = round(-x/15.0);
    
    double jd = [self calculateJulianDay:date withLatitude:lat withLongitude:lng];
    double mp[3][3] = {0.0,0.0,0.0,0.0,0.0,0.0};
    float longitude = lng/360.0;
    double tz = zone / 24.0;
    double t0 = [PDTimeCalculations lst:longitude withJday:jd withZ:tz];
    
    jd = jd + tz;
    
    for (int k = 0; k < 3; k ++) {
        [self moon:jd];
        mp[k][0] = SkyM[0];
        mp[k][1] = SkyM[1];
        mp[k][2] = SkyM[2];
        jd = jd + 0.5;
    }
    if (mp[1][0] <= mp[0][0]){
        mp[1][0] = mp[1][0] + 2 * M_PI;
    }
    
    if (mp[2][0] <= mp[1][0]){
        mp[2][0] = mp[2][0] + 2 * M_PI;
    }
    RAnM[0] = mp[0][0];
    DecM[0] = mp[0][1];
    double ph = 0.0;
    _moonEntity.Rise = NO;
    _moonEntity.Set = NO;
    for (int k = 0; k < 24; k++)                   // check each hour of this day
    {
        ph = (k + 1)/24.0;
        RAnM[2] = [PDTimeCalculations interpolate:mp[0][0] withf1:mp[1][0] withf2:mp[2][0] withp:ph];
        DecM[2] = [PDTimeCalculations interpolate:mp[0][1] withf1:mp[1][1] withf2:mp[2][1] withp:ph];
        VHzM[2] = [self test_moon:k withZone:zone witht0:t0 withLat:lat withPlx:mp[1][2]];
        RAnM[0] = RAnM[2];                       // advance to next hour
        DecM[0] = DecM[2];
        VHzM[0] = VHzM[2];
    }
    _moonEntity.timeRise = [self getTimesFromHour:Rise_timeM[0] andMinute:Rise_timeM[1] andZone:zone];
    _moonEntity.timeSet = [self getTimesFromHour:Set_timeM[0] andMinute:Set_timeM[1] andZone:zone];
    
    _moonEntity.timeRise = [self getTimesFromHour:Rise_timeM[0] andMinute:Rise_timeM[1] andZone:zone];
    _moonEntity.timeSet = [self getTimesFromHour:Set_timeM[0] andMinute:Set_timeM[1] andZone:zone];
    _moonEntity.timeNow = date;
    _moonEntity.latitude = lat;
    _moonEntity.longitude = lng;
    _moonEntity.azimuthRise = Rise_azM;
    _moonEntity.azimuthSet = Set_azM;
    _moonEntity.vhz2 = VHzM[2];
    _moonEntity.haveMoon = _todayHaveMoon;
    PDSetPosition *setPotion = [PDSetPosition new];
    positionEntity.moonPoint = [setPotion  setMoon:_moonEntity dateFormatter:_dateFormatter];
}

- (double)test_moon:(double)k withZone:(double)zone witht0:(double)t0 withLat:(double)lat withPlx:(double)plx
{
    double ha[3] = {0.0, 0.0, 0.0};
    double a, b, c, d, e, s, z;
    double hr, min, time;
    double az, hz, nz, dz;
    
    if (RAnM[2] < RAnM[0]){
        RAnM[2] = RAnM[2] + 2 * M_PI;
    }
    
    ha[0] = t0 - RAnM[0] + k * K1;
    ha[2] = t0 - RAnM[2] + k*K1 + K1;
    ha[1]  = (ha[2] + ha[0])/2.0;                // hour angle at half hour
    
    DecM[1] = (DecM[2] + DecM[0])/2.0;              // declination at half hour
    
    s = sin(DR*lat);
    c = cos(DR*lat);
    
    // refraction + sun semidiameter at horizon + parallax correction
    z = cos(DR*(90.567 - 41.685/plx));
    
    if (k <= 0){                                // first call of function
        VHzM[0] = s*sin(DecM[0]) + c*cos(DecM[0])* cos(ha[0]) - z;
    }
    VHzM[2] = s*sin(DecM[2]) + c * cos(DecM[2])* cos(ha[2]) - z;
    
    
    if ([PDTimeCalculations sgn:VHzM[0]] == [PDTimeCalculations sgn:VHzM[2]]){
        return VHzM[2];                         // no event this hour
    }
    VHzM[1] = s*sin(DecM[1]) + c*cos(DecM[1])*cos(ha[1]) - z;
    
    a = 2*VHzM[2] - 4*VHzM[1] + 2*VHzM[0];
    b = 4*VHzM[1] - 3*VHzM[0] - VHzM[2];
    d = b*b - 4*a*VHzM[0];
    
    if (d < 0){
        return VHzM[2];                         // no event this hour
    }
    d = sqrt(d);
    e = (-b + d)/(2*a);
    
    if (( e > 1 )||( e < 0 )){
        e = (-b - d)/(2*a);
    }
    
    time = k + e + 1.0/120.0;                      // time of an event + round up
    hr   = floor(time);
    min  = floor((time - hr)*60);
    
    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the moon at the event
    nz = -cos(DecM[1])*sin(hz);
    dz = c*sin(DecM[1]) - s*cos(DecM[1])*cos(hz);
    az = atan2(nz, dz)/DR;
    if (az < 0){
        az = az + 360;
    }
    if ((VHzM[0] < 0)&&(VHzM[2] > 0))
    {
        Rise_timeM[0] = hr;
        Rise_timeM[1] = min;
        Rise_azM = az;
        _moonEntity.Rise = YES;
    }
    
    if ((VHzM[0] > 0)&&(VHzM[2] < 0))
    {
        Set_timeM[0] = hr;
        Set_timeM[1] = min;
        Set_azM = az;
        _moonEntity.Set = YES;
    }
    return VHzM[2];
}

- (void)moon:(double )jd
{
    double d, f, g, h, m, n, s, u, v, w;
    h = 0.606434 + 0.03660110129*jd;
    m = 0.374897 + 0.03629164709*jd;
    f = 0.259091 + 0.0367481952 *jd;
    d = 0.827362 + 0.03386319198*jd;
    n = 0.347343 - 0.00014709391*jd;
    g = 0.993126 + 0.0027377785 *jd;
    
    h = h - floor(h);
    m = m - floor(m);
    f = f - floor(f);
    d = d - floor(d);
    n = n - floor(n);
    g = g - floor(g);
    
    h = h * 2 * M_PI;
    m = m * 2 * M_PI;
    f = f * 2 * M_PI;
    d = d * 2 * M_PI;
    n = n * 2 * M_PI;
    g = g * 2 * M_PI;
    
    v = 0.39558 * sin(f + n);
    v = v + 0.082  * sin(f);
    v = v + 0.03257 * sin(m - f - n);
    v = v + 0.01092 * sin(m + f + n);
    v = v + 0.00666 * sin(m - f);
    v = v - 0.00644 * sin(m + f - 2*d + n);
    v = v - 0.00331 * sin(f - 2*d + n);
    v = v - 0.00304 * sin(f - 2*d);
    v = v - 0.0024 * sin(m - f - 2*d - n);
    v = v + 0.00226 * sin(m + f);
    v = v - 0.00108 * sin(m + f - 2*d);
    v = v - 0.00079 * sin(f - n);
    v = v + 0.00078 * sin(f + 2*d + n);
    
    u = 1 - 0.10828 * cos(m);
    u = u - 0.0188 * cos(m - 2*d);
    u = u - 0.01479 * cos(2*d);
    u = u + 0.00181 * cos(2*m - 2*d);
    u = u - 0.00147 * cos(2*m);
    u = u - 0.00105 * cos(2*d - g);
    u = u - 0.00075 * cos(m - 2*d + g);
    
    w = 0.10478 * sin(m);
    w = w - 0.04105 * sin(2*f + 2*n);
    w = w - 0.0213 * sin(m - 2*d);
    w = w - 0.01779 * sin(2*f + n);
    w = w + 0.01774 * sin(n);
    w = w + 0.00987 * sin(2*d);
    w = w - 0.00338 * sin(m - 2*f - 2*n);
    w = w - 0.00309 * sin(g);
    w = w - 0.0019 * sin(2*f);
    w = w - 0.00144 * sin(m + n);
    w = w - 0.00144 * sin(m - 2*f - n);
    w = w - 0.00113 * sin(m + 2*f + 2*n);
    w = w - 0.00094 * sin(m - 2*d + g);
    w = w - 0.00092 * sin(2*m - 2*d);
    
    s = w/sqrt(u - v*v);
    // compute moon's right ascension ...
    SkyM[0] = h + atan(s/sqrt(1 - s*s));
    s = v/sqrt(u);                        // declination ...
    SkyM[1] = atan(s/sqrt(1 - s*s));
    SkyM[2] = 60.40974 * sqrt( u );          // and parallax
}

#pragma mark - compute Sun rise and Sun set

- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng
{
    Rise_azS = 0.0;
    Set_azS = 0.0;
    Rise_timeS[0] = 0.0;
    Rise_timeS[1] = 0.0;
    Set_timeS[0] = 0.0;
    Set_timeS[1] = 0.0;
    VHzS[2] = 0.0;
    
    double x = lng;
    double zone = round(-x/15.0);
    int k;
    double jd = [self calculateJulianDay:date withLatitude:lat withLongitude:lng];
    double longitude = lng /360.0;
    double tz  = zone /24.0;
    double ct  = jd/36525.0 + 1;                    // centuries since 1900.0
    double t0 = [PDTimeCalculations lst:longitude withJday:jd withZ:tz];
    jd = jd + tz;

    // get sun position at start of day
    [self sun:jd withCT:ct];
    float ra0  = SkyS[0];
    float dec0 = SkyS[1];
    jd = jd + 1.0;
    [self sun:jd withCT:ct]; // get sun position at end of day
    float ra1  = SkyS[0];
    float dec1 = SkyS[1];

    if (ra1 < ra0){                             // make continuous
        ra1 = ra1 + 2*M_PI;
    }
    _sunEntity.Rise = NO;
    _sunEntity.Set = NO;
    RAnS[0]   = ra0;
    DecS[0]  = dec0;
    
    for (k = 0; k < 24; k++)                   // check each hour of this day
    {
        RAnS[2] = ra0  + (k + 1)*(ra1  - ra0)/24.0;
        DecS[2] = dec0 + (k + 1)*(dec1 - dec0)/24.0;
        VHzS[2] = [self test_hour:k withZone:zone wihtT0:t0 withLat:lat];
        
        RAnS[0] = RAnS[2];                       // advance to next hour
        DecS[0] = DecS[2];
        VHzS[0] = VHzS[2];
    }
    _sunEntity.timeRise = [self getTimesFromHour:Rise_timeS[0] andMinute:Rise_timeS[1] andZone:zone];
    _sunEntity.timeSet = [self getTimesFromHour:Set_timeS[0] andMinute:Set_timeS[1] andZone:zone];
    _sunEntity.timeNow = date;
    _sunEntity.latitude = lat;
    _sunEntity.longitude = lng;
    _sunEntity.azimuthRise = Rise_azS;
    _sunEntity.azimuthSet = Set_azS;
    _sunEntity.vhz2 = VHzS[2];
    PDSetPosition *setPotion = [PDSetPosition new];
    positionEntity.sunPoint = [setPotion  setSun:_sunEntity dateFormatter:_dateFormatter];
    
}

-(double)test_hour:(double)k withZone:(double)zone wihtT0:(double)t0 withLat:(double)lat
{
    double ha[3] = {0.0, 0.0, 0.0};
    double a, b, c, d, e, s, z;
    double hr, min, time;
    double az, dz, hz, nz;
    
    ha[0] = t0 - RAnS[0] + k*K1;
    ha[2] = t0 - RAnS[2] + k*K1 + K1;
    
    ha[1]  = (ha[2]  + ha[0])/2.0;               // hour angle at half hour
    DecS[1] = (DecS[2] + DecS[0])/2.0 ;             // declination at half hour
    
    s = sin(lat*DR);
    c = cos(lat*DR);
    z = cos(90.833*DR);                   // refraction + sun semidiameter at horizon
    if (k <= 0)
        
        VHzS[0] = s*sin(DecS[0]) + c*cos(DecS[0])*cos(ha[0]) - z;
    
    VHzS[2] = s*sin(DecS[2]) + c*cos(DecS[2])*cos(ha[2]) - z;
    
    if ([PDTimeCalculations sgn:VHzS[0]] == [PDTimeCalculations sgn:VHzS[2]] ) {
        return VHzS[2];
    }
    if ([PDTimeCalculations sgn:VHzS[0]] == [PDTimeCalculations sgn:VHzS[2]] ){
        return VHzS[2];                         // no event this hour
    }
    VHzS[1] = s*sin(DecS[1]) + c*cos(DecS[1])*cos(ha[1]) - z;
    
    a =  2* VHzS[0] - 4*VHzS[1] + 2*VHzS[2];
    b = -3* VHzS[0] + 4*VHzS[1] - VHzS[2];
    d = b*b - 4*a*VHzS[0];
    
    if (d < 0)
        return VHzS[2];                         // no event this hour
    
    d = sqrt(d);
    e = (-b + d)/(2 * a);
    
    if ((e > 1)||(e < 0))
        e = (-b - d)/(2*a);
    
    time = k + e + 1/120.0;                      // time of an event
    
    hr = floor(time);
    min = floor((time - hr)*60.0);
    
    hz = ha[0] + e*(ha[2] - ha[0]);            // azimuth of the sun at the event
    nz = -cos(DecS[1])*sin(hz);
    dz = c*sin(DecS[1]) - s*cos(DecS[1])*cos(hz);
    az = atan2(nz, dz)/DR;
    if (az < 0) az = az + 360;
    
    if ((VHzS[0] < 0)&&(VHzS[2] > 0))
    {
        Rise_timeS[0] = hr;
        Rise_timeS[1] = min;
        Rise_azS = az;
        _sunEntity.Rise = YES;
    }
    if ((VHzS[0] > 0)&&(VHzS[2] < 0))
    {
        Set_timeS[0] = hr;
        Set_timeS[1] = min;
        Set_azS = az;
        _sunEntity.Set = YES;
    }
    return VHzS[2];
}

- (void)sun:(double)jd withCT:(double)ct
{
    double g, lo, s, u, v, w;
    
    lo = 0.779072 + 0.00273790931*jd;
    
    lo = lo - floor(lo);
    lo = lo * 2 * M_PI;
    
    g = 0.993126 + 0.0027377785*jd;
    g = g - floor(g);
    g = g * 2 * M_PI;
    
    v = 0.39785*sin(lo);
    v = v - 0.01*sin(lo - g);
    v = v + 0.00333*sin(lo + g);
    v = v - 0.00021*ct * sin(lo);
    
    u = 1 - 0.03349*cos(g);
    u = u - 0.00014*cos(2*lo);
    u = u + 0.00008*cos(lo);
    
    w = -0.0001 - 0.04129*sin(2*lo);
    w = w + 0.03211*sin(g );
    w = w + 0.00104*sin(2*lo - g);
    w = w - 0.00035*sin(2*lo + g);
    w = w - 0.00008*ct*sin(g);
    
    s = w/sqrt(u - v*v);                  // compute sun's right ascension
    SkyS[0] = lo + atan(s/sqrt(1 - s*s));
    
    s = v/sqrt(u);                        // ...and declination
    SkyS[1] = atan(s/sqrt(1 - s*s));
}

#pragma mark -  convert Date

- (NSDate *)getTimesFromHour:(int)hour andMinute:(int)minute andZone:(double)zone
{
    NSString *dateStringRise = [NSString stringWithFormat:@"%d-%d-%d %d:%d:00",_yearValue,_monthValue,_dayValue,hour,minute];
    NSDate *dateMoonRise = [_dateFormatter dateFromString:dateStringRise];
    return [NSDate dateWithTimeInterval:(zone)*60*60 sinceDate:dateMoonRise];
}

- (double )calculateJulianDay:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng
{
    double x = lng;
    double zone = round(-x/15.0);
    double timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date]/3600.0;
    NSDate *dateLocation = [NSDate dateWithTimeInterval:-(zone + timeZoneOffset)*60*60 sinceDate:date];
    
    _dayValue  = [[self conVertDateToStringFomatBy:@"dd" withDate:dateLocation]intValue];
    _monthValue = [[self conVertDateToStringFomatBy:@"MM" withDate:dateLocation]intValue];
    _yearValue = [[self conVertDateToStringFomatBy:@"yyyy" withDate:dateLocation] intValue];
    return [PDTimeCalculations julian_day:_yearValue withMonth:_monthValue withDay:_dayValue] - 2451545.0;
}

- (NSString *)conVertDateToStringFomatBy:(NSString *)formatString withDate:(NSDate *)date
{
    [_dateFormatterConvert setDateFormat:formatString];
    return [_dateFormatterConvert stringFromDate:date];
}

@end
