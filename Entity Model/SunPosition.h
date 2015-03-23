//
//  SunPosition.h
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunPosition : NSObject {
    double _azimuth;
    double _altitude;
}

@property double azimuth;
@property double altitude;

- (id) initWithAzimuth:(double)azimuth andAltitude:(double)altitude;
@end
