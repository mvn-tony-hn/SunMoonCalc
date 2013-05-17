//
//  SunMoonAnnotationView.h
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
// 
//

#import <MapKit/MapKit.h>
#import "PositionEntity.h"
#import "SunPoint.h"
#import "MoonSunCalcGobal.h"
#import "MoonPoint.h"

@interface SunMoonAnnotationView : MKAnnotationView {
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPosImageView ;
    
    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPosImageView ;
}
@property (nonatomic, strong) SunPoint *sunPoint;
@property (nonatomic, strong) NSDate *dateCompute;
@property (nonatomic, strong) CLLocation *locationCompute;
@property (nonatomic, assign) BOOL sunRiseSelect;
@property (nonatomic, weak) PositionEntity *position;
@property (nonatomic, strong) MoonSunCalcGobal *moonSucCalc;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng ;
- (void)updateContentView;

@end
