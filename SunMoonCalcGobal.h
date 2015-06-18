//
//  MoonSunCalcGobal.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
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


@end
