//
//  SunPoint.h
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SunPoint : NSObject <MKAnnotation>

@property BOOL isHiddenSunRise;
@property BOOL isHiddenSunSet;
@property BOOL isHiddenSunPos;

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString *)nameAnnotation  coordinate:(CLLocationCoordinate2D)coordinateAnnotation;

@end
