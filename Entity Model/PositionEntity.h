//
//  PositionEntity.h
//  MoonAndSunCalc
//
//  Created by Duc Long on 4/10/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDSunMoonPoint.h"

@interface PositionEntity : NSObject

@property (strong, nonatomic) PDSunMoonPoint *sunPoint;
@property (strong, nonatomic) PDSunMoonPoint *moonPoint;

@end
