//
//  SunMoonAnnotationView.m
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
// 
//

#import "SunMoonAnnotationView.h"
#import "Globals.h"
#define SunSetSelected 3
#define SunRiseSelected 4


@implementation SunMoonAnnotationView

@synthesize sunMoonCalc;
@synthesize position, sunRiseSelect, dateCompute, sunMoonAnnotation, locationCompute;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, centerAnnotationPoint*2, centerAnnotationPoint*2);
        self.backgroundColor = [UIColor clearColor];
        _sunmoonView = [[PDSunMoonview alloc]initWithFrame:self.frame];
        [self addSubview:_sunmoonView];
        self.enabled = NO;
        locationCompute = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
        self.sunMoonAnnotation = annotation;
        dateCompute = date;
        self.sunRiseSelect = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateCoordinate:)
                                                     name:kPDUpdateSunMoonAnnotationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateDate:)
                                                     name:kPDSunMoonDateChangedNotification
                                                   object:nil];
        
        sunMoonCalc = [[SunMoonCalcGobal alloc] init];
        [sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
        [sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
        
        position = sunMoonCalc.positionEntity;
        _sunmoonView.sunMoonAnnotation = sunMoonAnnotation;
        _sunmoonView.position = position;
        [_sunmoonView initContentView];
        [_sunmoonView reloadAnnotation];
        
        
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDSunMoonDateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDUpdateSunMoonAnnotationNotification object:nil];

    
    
}

#pragma mark - touche move view

- (void)didUpdateCoordinate:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    locationCompute = newLocation;
    [sunMoonCalc computeMoonriseAndMoonSet:dateCompute
                              withLatitude:newLocation.coordinate.latitude
                             withLongitude:newLocation.coordinate.longitude];
    [sunMoonCalc computeSunriseAndSunSet:dateCompute
                            withLatitude:newLocation.coordinate.latitude
                           withLongitude:newLocation.coordinate.longitude];
    position = sunMoonCalc.positionEntity;
    _sunmoonView.position = position;
    [_sunmoonView reloadAnnotation];
}

- (void)didUpdateDate:(NSNotification *)notification
{
    NSDate *date = (NSDate *)[notification object];
    dateCompute = date;
    [sunMoonCalc computeMoonriseAndMoonSet:date
                              withLatitude:locationCompute.coordinate.latitude
                             withLongitude:locationCompute.coordinate.longitude];
    [sunMoonCalc computeSunriseAndSunSet:date
                            withLatitude:locationCompute.coordinate.latitude
                           withLongitude:locationCompute.coordinate.longitude];
    position = sunMoonCalc.positionEntity;
    _sunmoonView.position = position;
    [_sunmoonView reloadAnnotation];
}



@end
