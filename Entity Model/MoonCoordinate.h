//
//  MoonCoordinate.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoonCoordinate : NSObject
{
    double _declination;
    double _rightAscension;
    double _distance; //distance to the moon in km
}
@property double declination;
@property double rightAscension;
@property double distance;
- (id)initWithDeclination:(double)d andRightAscension:(double)r andDistance:(double)distance;

@end
