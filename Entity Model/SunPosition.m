//
//  SunPosition.m
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SunPosition.h"

@implementation SunPosition
@synthesize azimuth=_azimuth, altitude=_altitude;
-(id) initWithAzimuth:(double)azimuth andAltitude:(double)altitude {
    self = [super init];
    if(self) {
        _azimuth = azimuth;
        _altitude = altitude;
    }
    return self;
}
@end
