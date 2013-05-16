//
//  SunMoonAnnotationView.m
//  MoonAndSunCalc
//
//  Created by TungNT2 on 5/16/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "SunMoonAnnotationView.h"

#define SunSetSelected 3
#define SunRiseSelected 4

@implementation SunMoonAnnotationView

@synthesize moonSucCalc;
@synthesize position,SunRiseSelect,dateCompute,annotationPoint,locationCompute;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDate:(NSDate *)date withLatitude:(double)lat withLongitude:(double)lng {
    self = [super init];
    if (self) {
        self.enabled = NO;
        locationCompute = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
        self.annotationPoint = annotation;
        dateCompute = date;
        SunRiseSelect = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateCoordinate:) name:@"UpdateCoordinate" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateDate:) name:@"UpdateDate" object:nil];
        
        
        moonSucCalc = [[MoonSunCalcGobal alloc]init];
        [moonSucCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
        [moonSucCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
        position = moonSucCalc.positionEntity;
        
        [self initContentView];
        [self updateContentView];
        
    }
    return self;
}

- (void)initContentView
{
    UIImage *moonRiseImage = [UIImage imageNamed:@"icon_moon_rise@2x.png"];
    moonRiseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointMoonRiseX - 25 , position.pointMoonRiseY - 32, 25, 32)];
    moonRiseImageView.image = moonRiseImage;
    [self addSubview:moonRiseImageView];
    
    UIImage *moonSetImage = [UIImage imageNamed:@"icon_moon_set@2x.png"];
    moonSetImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointMoonSetX, position.pointMoonSetY - 32, 25, 32)];
    moonSetImageView.image = moonSetImage;
    [self addSubview:moonSetImageView];
    
    UIImage *moonPointImage = [UIImage imageNamed:@"icon_current_moon@2x.png"];
    moonPointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointMoonX, position.pointMoonY , 20, 20)];
    moonPointImageView.image = moonPointImage;
    [self addSubview:moonPointImageView];
    
    UIImage *sunRiseImage = [UIImage imageNamed:@"icon_sun_rise.png"];
    sunRiseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointSunRiseX - 25 , position.pointSunRiseY - 20, 25, 32)];
    sunRiseImageView.image = sunRiseImage;
    [self addSubview:sunRiseImageView];
    
    UIImage *sunSetImage = [UIImage imageNamed:@"icon_sun_set@2x.png"];
    sunSetImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointSunSetX - 25 , position.pointSunSetY - 32, 25, 32)];
    sunSetImageView.image = sunSetImage;
    [self addSubview:sunSetImageView];
    UIImage *sunPointImage = [UIImage imageNamed:@"icon_current_sun@2x.png"];
    sunPointImageView = [[UIImageView alloc]initWithFrame:CGRectMake(position.pointSunX, position.pointSunY, 20, 20)];
    sunPointImageView.image = sunPointImage;
    [self addSubview:sunPointImageView];
    
    self.frame = CGRectMake(0, 0, 205, 205);
    self.backgroundColor = [UIColor clearColor];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef contextMoonSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonSet, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(contextMoonSet, 2.0);
    CGContextMoveToPoint(contextMoonSet, position.pointMoonSetX, position.pointMoonSetY);
    CGContextAddLineToPoint(contextMoonSet, 103, 103);
    CGContextStrokePath(contextMoonSet);
    
    CGContextRef contextMoonRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonRise, [UIColor cyanColor].CGColor);
    CGContextSetLineWidth(contextMoonRise, 2.0);
    CGContextMoveToPoint(contextMoonRise, 103, 103);
    CGContextAddLineToPoint(contextMoonRise, position.pointMoonRiseX, position.pointMoonRiseY);
    CGContextStrokePath(contextMoonRise);
    
    CGContextRef contextMoonPoint = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonPoint, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(contextMoonPoint, 2.0);
    CGContextMoveToPoint(contextMoonPoint, 103, 103);
    CGContextAddLineToPoint(contextMoonPoint,position.pointMoonX,position.pointMoonY);
    CGContextStrokePath(contextMoonPoint);
    
    CGContextRef contextSunRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunRise, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(contextSunRise, 2.0);
    CGContextMoveToPoint(contextSunRise, 103, 103);
    CGContextAddLineToPoint(contextSunRise, position.pointSunRiseX, position.pointSunRiseY);
    CGContextStrokePath(contextSunRise);
    
    
    CGContextRef contextSunSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunSet, [UIColor redColor].CGColor);
    CGContextSetLineWidth(contextSunSet, 2.0);
    CGContextMoveToPoint(contextSunSet, position.pointSunSetX, position.pointSunSetY);
    CGContextAddLineToPoint(contextSunSet, 103, 103);
    CGContextStrokePath(contextSunSet);
    
    
    
    CGContextRef contextSunPoint = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunPoint, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(contextSunPoint, 2.0);
    CGContextMoveToPoint(contextSunPoint, 103, 103);
    CGContextAddLineToPoint(contextSunPoint,position.pointSunX,position.pointSunY );
    CGContextStrokePath(contextSunPoint);
    
    CGContextRef contextCricle = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextCricle, [UIColor clearColor].CGColor);
    CGContextFillEllipseInRect(contextCricle, CGRectMake(3, 3, 200.0, 200.0));
    CGContextSetStrokeColorWithColor(contextCricle, [UIColor yellowColor].CGColor);
    CGContextStrokeEllipseInRect(contextCricle, CGRectMake(3, 3, 200.0, 200.0));
    
    
}
#pragma mark - touche move view


-(void)didUpdateCoordinate:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    locationCompute = newLocation;
    [moonSucCalc computeMoonriseAndMoonSet:dateCompute withLatitude:newLocation.coordinate.latitude withLongitude:newLocation.coordinate.longitude];
    [moonSucCalc computeSunriseAndSunSet:dateCompute withLatitude:newLocation.coordinate.latitude withLongitude:newLocation.coordinate.longitude];
    position = moonSucCalc.positionEntity;
    [self updateContentView];
}

- (void)didUpdateDate:(NSNotification *)notification
{
    NSDate *date = (NSDate *)[notification object];
    dateCompute = date;
    [moonSucCalc computeMoonriseAndMoonSet:date withLatitude:locationCompute.coordinate.latitude withLongitude:locationCompute.coordinate.longitude];
    [moonSucCalc computeSunriseAndSunSet:date withLatitude:locationCompute.coordinate.latitude withLongitude:locationCompute.coordinate.longitude];
    position = moonSucCalc.positionEntity;
    [self updateContentView];
}

- (void)updateContentView
{
    CGPoint newCenter;
    
    if (position.pointMoonRiseX == 103 && position.pointMoonRiseY == 103 ) {
        moonRiseImageView.hidden = YES;
    }
    else
    {
        moonRiseImageView.hidden = NO;
        newCenter.x = position.pointMoonRiseX - 12;
        newCenter.y = position.pointMoonRiseY - 16;
        moonRiseImageView.center = newCenter;
    }
    if (position.pointMoonSetX == 103 && position.pointMoonSetY == 103 ) {
        moonSetImageView.hidden = YES;
    }
    else
    {
        moonSetImageView.hidden = NO;
        newCenter.x = position.pointMoonSetX + 12;
        newCenter.y = position.pointMoonSetY - 14;
        moonSetImageView.center = newCenter;
    }
    
    if (position.pointMoonX == 103 && position.pointMoonY == 103 ) {
        moonPointImageView.hidden = YES;
    }
    else
    {
        moonPointImageView.hidden = NO;
        newCenter.x = position.pointMoonX ;
        newCenter.y = position.pointMoonY ;
        moonPointImageView.center = newCenter;
    }
    
    // set up for Sun
    if (self.annotationPoint.HiddenSunRise == YES) {
        position.pointSunRiseX = 103;
        position.pointSunRiseY = 103;
    }
    if (position.pointSunRiseX == 103 && position.pointSunRiseY == 103 ) {
        sunRiseImageView.hidden = YES;
    }
    else
    {
        sunRiseImageView.hidden = NO;
        newCenter.x = position.pointSunRiseX - 12;
        newCenter.y = position.pointSunRiseY - 16;
        sunRiseImageView.center = newCenter;
    }
    
    
    if (self.annotationPoint.HiddenSunSet == YES) {
        position.pointSunSetX = 103;
        position.pointSunSetY = 103;
    }
    if (position.pointSunSetX == 103 && position.pointSunSetY == 103 ) {
        sunSetImageView.hidden = YES;
    }
    else
    {
        sunSetImageView.hidden = NO;
        newCenter.x = position.pointSunSetX + 12;
        newCenter.y = position.pointSunSetY - 14;
        sunSetImageView.center = newCenter;
    }
    
    
    if (self.annotationPoint.HiddenSunPoint == YES) {
        position.pointSunX = 103;
        position.pointSunY = 103;
    }
    if (position.pointSunX == 103 && position.pointSunY == 103 ) {
        sunPointImageView.hidden = YES;
    }
    else
    {
        sunPointImageView.hidden = NO;
        newCenter.x = position.pointSunX;
        newCenter.y = position.pointSunY;
        sunPointImageView.center = newCenter;
    }
    [self setNeedsDisplay];
    
}

@end
