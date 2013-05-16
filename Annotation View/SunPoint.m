//
//  SunPoint.m
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "SunPoint.h"

@implementation SunPoint
@synthesize name, coordinate, isHiddenSunRise, isHiddenSunPos, isHiddenSunSet;

-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation{
    if (self=[super init]) {
        self.name = nameAnnotation;
        self.coordinate = coordinateAnnotation;
    }
    return self;
    
}

@end
