//
//  SunMoonAnnotation.h
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
// 
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SunMoonAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, assign) BOOL isHiddenSunRise;
@property (nonatomic, assign) BOOL isHiddenSunSet;
@property (nonatomic, assign) BOOL isHiddenSunPos;

@property (nonatomic, assign) BOOL isHiddenMoonRise;
@property (nonatomic, assign) BOOL isHiddenMoonSet;
@property (nonatomic, assign) BOOL isHiddenMoonPos;

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;

@end
