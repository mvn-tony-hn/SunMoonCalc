//
//  MoonCoordinate.m
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MoonCoordinate.h"

@implementation MoonCoordinate
@synthesize rightAscension=_rightAscension, declination=_declination, distance=_distance;
- (id)initWithDeclination:(double)d andRightAscension:(double)r andDistance:(double)distance {
    if(self = [super init]) {
        _rightAscension = r;
        _declination = d;
        _distance = distance;
    }
    return self;
}
@end
