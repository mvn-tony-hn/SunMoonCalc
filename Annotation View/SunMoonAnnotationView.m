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

static CGFloat const kDashedLinesLength[]   = {10.0f, 4.0f};

@implementation SunMoonAnnotationView

@synthesize sunMoonCalc;
@synthesize position, sunRiseSelect, dateCompute, sunMoonAnnotation, locationCompute;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
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
                                                     name:kPDSunMoonDateTimeChangedNotification
                                                   object:nil];
        sunMoonCalc = [[SunMoonCalcGobal alloc] init];
        [sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
        [sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
        position = sunMoonCalc.positionEntity;
        [self initContentView];
        [self reloadAnnotation];
        
    }
    return self;
}

- (void)initContentView
{
    UIImage *sunRiseImage = [UIImage imageNamed:@"icon_sun_rise.png"];
    sunRiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointSunRiseX, position.pointSunRiseY, 20, 20)];
    sunRiseImageView.image = sunRiseImage;
    [self addSubview:sunRiseImageView];
    
    UIImage *sunSetImage = [UIImage imageNamed:@"icon_sun_set.png"];
    sunSetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointSunSetX, position.pointSunSetY, 20, 20)];
    sunSetImageView.image = sunSetImage;
    [self addSubview:sunSetImageView];
    
    UIImage *sunPosImage = [UIImage imageNamed:@"icon_current_sun.png"];
    sunPosImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointSunX, position.pointSunY, 20, 20)];
    sunPosImageView.image = sunPosImage;
    [self addSubview:sunPosImageView];
    
    UIImage *moonRiseImage = [UIImage imageNamed:@"icon_moon_rise.png"];
    moonRiseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointMoonRiseX, position.pointMoonRiseY, 20, 20)];
    moonRiseImageView.image = moonRiseImage;
    [self addSubview:moonRiseImageView];
    
    UIImage *moonSetImage = [UIImage imageNamed:@"icon_moon_set.png"];
    moonSetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointMoonSetX, position.pointMoonSetY, 20, 20)];
    moonSetImageView.image = moonSetImage;
    [self addSubview:moonSetImageView];
    
    UIImage *moonPosImage = [UIImage imageNamed:@"icon_current_moon.png"];
    moonPosImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.pointMoonX, position.pointMoonY , 20, 20)];
    moonPosImageView.image = moonPosImage;
    [self addSubview:moonPosImageView];
    
    self.frame = CGRectMake(0, 0, centerAnnotationPoint*2, centerAnnotationPoint*2);
    self.backgroundColor = [UIColor clearColor];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef contextCricle = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextCricle, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(contextCricle, 2.0);
    CGContextFillEllipseInRect(contextCricle, CGRectMake(3, 3, 200.0, 200.0));
    CGContextSetStrokeColorWithColor(contextCricle, [UIColor colorWithRed:1.0 green:165/255.0 blue:0 alpha:1.0].CGColor);
    CGContextStrokeEllipseInRect(contextCricle, CGRectMake(3, 3, 200.0, 200.0));

    CGContextRef contextSunLight = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunLight, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextSunLight, 3.0);
    CGContextMoveToPoint(contextSunLight, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextSunLight, position.pointSunX, position.pointSunY);
    CGContextStrokePath(contextSunLight);
    
    CGContextRef contextMoonLight = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonLight, [UIColor colorWithRed:102/255.0 green:153/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonLight, 3.0);
    CGContextMoveToPoint(contextMoonLight, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextMoonLight, position.pointMoonX, position.pointMoonY);
    CGContextStrokePath(contextMoonLight);
    
    CGContextRef contextSunRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunRise, [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextSunRise, 3.0);
    CGContextSetLineDash(contextSunRise, 0.0f, kDashedLinesLength, 2.0f);
    CGContextMoveToPoint(contextSunRise, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextSunRise, position.pointSunRiseX, position.pointSunRiseY);
    CGContextStrokePath(contextSunRise);
    
    CGContextRef contextSunSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunSet, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextSunSet, 3.0);
    CGContextMoveToPoint(contextSunSet, position.pointSunSetX, position.pointSunSetY);
    CGContextAddLineToPoint(contextSunSet, centerAnnotationPoint, centerAnnotationPoint);
    CGContextStrokePath(contextSunSet);
    
    CGContextRef contextMoonRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonRise, [UIColor colorWithRed:51/255.0 green:153/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonRise, 3.0);
    CGContextMoveToPoint(contextMoonRise, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextMoonRise, position.pointMoonRiseX, position.pointMoonRiseY);
    CGContextStrokePath(contextMoonRise);
    
    CGContextRef contextMoonSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonSet, [UIColor colorWithRed:102/255.0 green:51/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonSet, 3.0);
    CGContextMoveToPoint(contextMoonSet, position.pointMoonSetX, position.pointMoonSetY);
    CGContextAddLineToPoint(contextMoonSet, centerAnnotationPoint, centerAnnotationPoint);
    CGContextStrokePath(contextMoonSet);
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
    [self reloadAnnotation];
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
    [self reloadAnnotation];
}

//- (void)didUpdateSunMoonOption:(NSNotification *)notification
//{
//    UIButton *btnClicked = [notification object];
//    switch (btnClicked.tag) {
//        case 0:
//            self.sunMoonAnnotation.isHiddenSunRise = !btnClicked.selected;
//            break;
//        case 1:
//            self.sunMoonAnnotation.isHiddenSunSet = !btnClicked.selected;
//            break;
//        case 2:
//            self.sunMoonAnnotation.isHiddenMoonRise = !btnClicked.selected;
//            break;
//        case 3:
//            self.sunMoonAnnotation.isHiddenMoonSet = !btnClicked.selected;
//            break;
//        default:
//            break;
//    }
//    //    [self.mapView removeAnnotation:self.sunMoonAnnotation];
//    //    [self.mapView addAnnotation:self.sunMoonAnnotation];
//    position = moonSucCalc.positionEntity;
//    [self reloadAnnotation];
//}

- (void)reloadAnnotation
{
    CGPoint newCenter;
    
    if (position.pointMoonRiseX == centerAnnotationPoint && position.pointMoonRiseY == centerAnnotationPoint) {
        moonRiseImageView.hidden = YES;
    }
    else {
        moonRiseImageView.hidden = NO;
        newCenter.x = position.pointMoonRiseX;
        newCenter.y = position.pointMoonRiseY;
        moonRiseImageView.center = newCenter;
    }
    if (position.pointMoonSetX == centerAnnotationPoint && position.pointMoonSetY == centerAnnotationPoint) {
        moonSetImageView.hidden = YES;
    }
    else {
        moonSetImageView.hidden = NO;
        newCenter.x = position.pointMoonSetX;
        newCenter.y = position.pointMoonSetY;
        moonSetImageView.center = newCenter;
    }
    
    if (position.pointMoonX == centerAnnotationPoint && position.pointMoonY == centerAnnotationPoint) {
        moonPosImageView.hidden = YES;
    }
    else {
        moonPosImageView.hidden = NO;
        newCenter.x = position.pointMoonX ;
        newCenter.y = position.pointMoonY ;
        moonPosImageView.center = newCenter;
    }
    
    // set up for Sun
    if (self.sunMoonAnnotation.isHiddenSunRise == YES) {
        position.pointSunRiseX = centerAnnotationPoint;
        position.pointSunRiseY = centerAnnotationPoint;
    }
    if (position.pointSunRiseX == centerAnnotationPoint && position.pointSunRiseY == centerAnnotationPoint) {
        sunRiseImageView.hidden = YES;
    }
    else {
        sunRiseImageView.hidden = NO;
        newCenter.x = position.pointSunRiseX;
        newCenter.y = position.pointSunRiseY;
        sunRiseImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenSunSet == YES) {
        position.pointSunSetX = centerAnnotationPoint;
        position.pointSunSetY = centerAnnotationPoint;
    }
    if (position.pointSunSetX == centerAnnotationPoint && position.pointSunSetY == centerAnnotationPoint) {
        sunSetImageView.hidden = YES;
    }
    else {
        sunSetImageView.hidden = NO;
        newCenter.x = position.pointSunSetX;
        newCenter.y = position.pointSunSetY;
        sunSetImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenSunPos == YES) {
        position.pointSunX = centerAnnotationPoint;
        position.pointSunY = centerAnnotationPoint;
    }
    if (position.pointSunX == centerAnnotationPoint && position.pointSunY == centerAnnotationPoint) {
        sunPosImageView.hidden = YES;
    }
    else {
        sunPosImageView.hidden = NO;
        newCenter.x = position.pointSunX;
        newCenter.y = position.pointSunY;
        sunPosImageView.center = newCenter;
    }
    
    //set up for moon
    if (self.sunMoonAnnotation.isHiddenMoonRise == YES) {
        position.pointMoonRiseX = centerAnnotationPoint;
        position.pointMoonRiseY = centerAnnotationPoint;
    }
    if (position.pointMoonRiseX == centerAnnotationPoint && position.pointMoonRiseY == centerAnnotationPoint) {
        moonRiseImageView.hidden = YES;
    }
    else {
        moonRiseImageView.hidden = NO;
        newCenter.x = position.pointMoonRiseX;
        newCenter.y = position.pointMoonRiseY;
        moonRiseImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenMoonSet == YES) {
        position.pointMoonSetX = centerAnnotationPoint;
        position.pointMoonSetY = centerAnnotationPoint;
    }
    if (position.pointMoonSetX == centerAnnotationPoint && position.pointMoonSetY == centerAnnotationPoint ) {
        moonSetImageView.hidden = YES;
    }
    else {
        moonSetImageView.hidden = NO;
        newCenter.x = position.pointMoonSetX;
        newCenter.y = position.pointMoonSetY;
        moonSetImageView.center = newCenter;
    }
    
    [self setNeedsDisplay];
}

@end
