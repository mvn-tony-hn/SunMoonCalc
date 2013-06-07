//
//  SunMoonAnnotation.m
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//
//

#import "SunMoonAnnotation.h"
#import "Globals.h"

@implementation SunMoonAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
        _isHiddenSunRise = kPDSunRiseHidden;
        _isHiddenSunSet = kPDSunSetHidden;
        _isHiddenMoonRise = kPDMoonRiseHidden;
        _isHiddenMoonSet = kPDMoonSetHidden;
    }
    return self;
}

@end
