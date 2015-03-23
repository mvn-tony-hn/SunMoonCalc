//
//  MoonPosition.h
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoonPosition : NSObject {
    double _azimuth;
    double _altitude;
    double _distance;
}

@property double azimuth;
@property double altitude;
@property double distance;

- (id) initWithAzimuth:(double)azimuth andAltitude:(double)altitude andDistance:(double)distance;


@end
