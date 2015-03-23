//
//  MoonSunCalcGobal.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/11/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionEntity.h"
#import "SunPosition.h"
#import "MoonPosition.h"

#define centerAnnotationPoint   103
#define kCenterPoint            CGPointMake(103, 103);
@interface SunMoonCalcGobal : NSObject {
    
}
@property BOOL todayHaveMoon;
@property (nonatomic ,strong) NSDate *timeRiseSun;
@property (nonatomic, strong) NSDate *timeSetSun;
@property (nonatomic ,strong) NSDate *timeRiseMoon;
@property (nonatomic, strong) NSDate *timeSetMoon;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatterConvert;
@property (nonatomic, strong) NSDate *julianDate;
@property int dayValue;
@property int monthValue;
@property int yearValue;
@property BOOL MoonRise ;
@property BOOL MoonSet ;
@property (nonatomic, strong) PositionEntity *positionEntity;
- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (NSDictionary*)getSunTimesWithDate:(NSDate*)date andLatitude:(double)lat andLogitude:(double)lng ;
- (SunPosition *)getSunPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng ;
- (MoonPosition *)getMoonPositionWithDate:(NSDate*)date andLatitude:(double)lat andLongitude:(double)lng ;
- (double)getMoonFraction:(NSDate *)date;


@end
