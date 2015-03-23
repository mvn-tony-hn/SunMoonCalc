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
#import "SunMoonCalcGobal.h"
#import "PDSunMoonview.h"

#define kPDUpdateSunMoonAnnotationNotification  @"kPDUpdateSunMoonAnnotationNotification"

@interface SunMoonAnnotationView : MKAnnotationView {
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPosImageView ;
    
    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPosImageView ;
}
@property (nonatomic, strong) SunMoonAnnotation *sunMoonAnnotation;
@property (nonatomic, strong) PDSunMoonview *sunmoonView;
@property (nonatomic, strong) NSDate *dateCompute;
@property (nonatomic, strong) CLLocation *locationCompute;
@property (nonatomic, assign) BOOL sunRiseSelect;
@property (nonatomic, weak) PositionEntity *position;
@property (nonatomic, strong) SunMoonCalcGobal *sunMoonCalc;
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng ;
@end
