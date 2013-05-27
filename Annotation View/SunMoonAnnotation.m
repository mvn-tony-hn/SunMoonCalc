//
//  SunMoonAnnotation.m
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//
//

#import "SunMoonAnnotation.h"

@implementation SunMoonAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end
