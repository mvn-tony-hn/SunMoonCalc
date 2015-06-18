//
//  SunCoordinate.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
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
