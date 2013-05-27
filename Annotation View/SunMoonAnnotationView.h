//
//  SunMoonAnnotationView.h
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
// 
//

#import <MapKit/MapKit.h>
#import "PositionEntity.h"
#import "SunMoonAnnotation.h"
#import "MoonSunCalcGobal.h"

#define centerAnnotationViewPoint        103;
#define sunOffsetCenterX                 12;
#define sunOffsetCenterY                 16;
#define MoonOffsetCenterX                -12;
#define MoonOffsetCenterY                14;

@interface SunMoonAnnotationView : MKAnnotationView {
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPosImageView ;
    
    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPosImageView ;
}
@property (nonatomic, strong) SunMoonAnnotation *sunMoonAnnotation;
@property (nonatomic, strong) NSDate *dateCompute;
@property (nonatomic, strong) CLLocation *locationCompute;
@property (nonatomic, assign) BOOL sunRiseSelect;
@property (nonatomic, weak) PositionEntity *position;
@property (nonatomic, strong) MoonSunCalcGobal *moonSucCalc;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng ;
- (void)reloadAnnotation;
@end
