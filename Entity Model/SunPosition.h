//
//  SunPosition.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
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
