//
//  PositionEntity.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionEntity : NSObject
{
    float pointMoonRiseX;
    float pointMoonRiseY;
    float pointMoonSetX;
    float pointMoonSetY;
    float pointMoonX;
    float pointMoonY;
    
    float pointSunRiseX;
    float pointSunRiseY;
    float pointSunSetX;
    float pointSunSetY;
    float pointSunX;
    float pointSunY;
    
    float azimuthMoonRise;
    float azimuthMoonSet;
    float azimuthSunRise;
    float azimuthSunSet;
    int hourMoonRise;
    int minuteMoonRise;
    int hourMoonSet;
    int minuteMoonSet;
    int hourSunRise;
    int minuteSunRise;
    int hourSunSet;
    int minuteSunSet;
}

@property float pointMoonRiseX;
@property float pointMoonRiseY;
@property float pointMoonSetX;
@property float pointMoonSetY;
@property float pointMoonX;
@property float pointMoonY;


@property float pointSunRiseX;
@property float pointSunRiseY;
@property float pointSunSetX;
@property float pointSunSetY;
@property float pointSunX;
@property float pointSunY;


@property float azimuthMoonRise;
@property float azimuthMoonSet;
@property float azimuthSunRise;
@property float azimuthSunSet;
@property int hourMoonRise;
@property int minuteMoonRise;
@property int hourMoonSet;
@property int minuteMoonSet;
@property int hourSunRise;
@property int minuteSunRise;
@property int hourSunSet;
@property int minuteSunSet;
- (id)initWithLatitude:(float)userLatitude longitude:(float)userLongitude withDay:(int)daySelected withMonth:(int)monthSelected withYear:(int)yearSeleted;

@end
