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
#import "PDSunMoonEntity.h"

#define centerAnnotationPoint   103
#define kCenterPoint            CGPointMake(103, 103);
@interface SunMoonCalcGlobal : NSObject

@property BOOL todayHaveMoon;
@property (nonatomic ,strong) PDSunMoonEntity *sunEntity;
@property (nonatomic, strong) PDSunMoonEntity *moonEntity;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatterConvert;
@property (nonatomic, strong) NSDate *julianDate;
@property int dayValue;
@property int monthValue;
@property int yearValue;

@property (nonatomic, strong) PositionEntity *positionEntity;

- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (NSDictionary *)getSunTimesWithDate:(NSDate *)date andLatitude:(double)lat andLogitude:(double)lng ;
- (SunPosition *)getSunPositionWithDate:(NSDate *)date andLatitude:(double)lat andLongitude:(double)lng ;
- (MoonPosition *)getMoonPositionWithDate:(NSDate *)date andLatitude:(double)lat andLongitude:(double)lng ;
- (double)getMoonFraction:(NSDate *)date;

@end
