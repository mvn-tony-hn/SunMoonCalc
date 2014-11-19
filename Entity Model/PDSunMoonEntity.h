//
//  PDSunMoonEntity.h
//  Pashadelic
//
//  Created by LongPD-PC on 11/19/14.
//
//

#import <Foundation/Foundation.h>

@interface PDSunMoonEntity : NSObject

@property double azimuthRise;
@property double azimuthSet;
@property double latitude;
@property double longitude;
@property BOOL Rise;
@property BOOL Set;
@property double vhz2;
@property(strong, nonatomic) NSDate *timeRise;
@property(strong, nonatomic) NSDate *timeSet;
@property(strong, nonatomic) NSDate *timeNow;
@property BOOL haveMoon;
@end
