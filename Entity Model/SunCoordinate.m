//
//  SunCoordinate.m
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SunCoordinate.h"

@implementation SunCoordinate
@synthesize declination=_declination, rightAscension=_rightAscension;
-(id) initWithDeclination:(double)d andRightAscension:(double)r {
    self = [super init];
    if(self) {
        _declination = d;
        _rightAscension = r;
    }
    return self;
}
@end
