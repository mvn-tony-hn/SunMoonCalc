//
//  PDSunCalculations.h
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import <Foundation/Foundation.h>

@interface PDTimeCalculations : NSObject

+ (int)sgn:( double )x;
+ (double)interpolate:(double)f0 withf1:(double)f1 withf2:(double)f2 withp:(double)p;
+ (double)lst :(double )longitude withJday:(double)jday withZ:(double)z;
+ (double)julian_day :(int)year withMonth:(int)month withDay:(int)day;

@end
