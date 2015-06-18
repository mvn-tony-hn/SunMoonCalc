//
//  SunMoonAnnotation.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SunMoonAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, assign) BOOL isHiddenSunRise;
@property (nonatomic, assign) BOOL isHiddenSunSet;
@property (nonatomic, assign) BOOL isHiddenSunPos;

@property (nonatomic, assign) BOOL isHiddenMoonRise;
@property (nonatomic, assign) BOOL isHiddenMoonSet;
@property (nonatomic, assign) BOOL isHiddenMoonPos;

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

@end
