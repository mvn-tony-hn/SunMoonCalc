//
//  SunCoordinate.h
//  GraduateProject
//
//  Created by Nguyen Dinh Chinh on 3/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunCoordinate : NSObject {
    double _declination;
    double _rightAscension;
}

- (id)initWithDeclination:(double)d andRightAscension:(double)r;
@property double declination;
@property double rightAscension;
@end
