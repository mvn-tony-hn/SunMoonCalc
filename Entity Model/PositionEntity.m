//
//  PositionEntity.m
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "PositionEntity.h"

@implementation PositionEntity
@synthesize pointMoonRiseX,pointMoonRiseY,pointMoonSetX,pointMoonSetY, pointMoonX, pointMoonY,pointSunRiseX, pointSunRiseY, pointSunSetX,pointSunSetY ,pointSunX,pointSunY ,azimuthMoonRise,azimuthMoonSet,azimuthSunRise,azimuthSunSet,hourMoonRise,hourMoonSet,minuteMoonRise,minuteMoonSet,hourSunRise,hourSunSet,minuteSunRise,minuteSunSet;

- (id)initWithLatitude:(float)userLatitude longitude:(float)userLongitude withDay:(int)daySelected withMonth:(int)monthSelected withYear:(int)yearSeleted{
    self = [super init];
    if (self) {
    }
    return  self;
}

@end
