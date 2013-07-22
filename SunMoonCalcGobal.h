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
#define centerAnnotationPoint   103
@interface SunMoonCalcGobal : NSObject {
    
}
@property (nonatomic ,strong) NSDate *timeRiseSun;
@property (nonatomic, strong) NSDate *timeSetSun;
@property (nonatomic ,strong) NSDate *timeRiseMoon;
@property (nonatomic, strong) NSDate *timeSetMoon;
@property (nonatomic, strong) PositionEntity *positionEntity;
- (void)computeMoonriseAndMoonSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (void)computeSunriseAndSunSet:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng;
- (NSDictionary*)getSunTimesWithDate:(NSDate*)date andLatitude:(double)lat andLogitude:(double)lng ;


@end
