//
//  MoonPosition.m
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MoonPosition.h"

@implementation MoonPosition
@synthesize azimuth = _azimuth, altitude=_altitude, distance=_distance;
- (id)initWithAzimuth:(double)azimuth andAltitude:(double)altitude andDistance:(double)distance {
    if(self = [super init]) {
        _azimuth = azimuth;
        _altitude =altitude;
        _distance = distance;
    }
    return self;
}
@end
