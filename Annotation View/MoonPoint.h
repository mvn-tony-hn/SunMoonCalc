//
//  MoonPoint.h
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MoonPoint : NSObject <MKAnnotation>
@property BOOL isHiddenMoonRise;
@property BOOL isHiddenMoonSet;
@property BOOL isHiddenMoonPos;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)nameAnnotation coordinate:(CLLocationCoordinate2D)coordinateAnnotation;
@end
