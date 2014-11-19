//
//  PDSunMoonview.m
//  Pashadelic
//
//  Created by LongPD on 9/24/13.
//
//

#import "PDSunMoonview.h"


@implementation PDSunMoonview
@synthesize position;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateHeading:)
                                                     name:kPDDidUpdateHeading
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didStopRotationMaptool)
                                                     name:kPDSetUserTrackingModeNoneNotification
                                                   object:nil];
        // Initialization code
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDDidUpdateHeading object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDSetUserTrackingModeNoneNotification object:nil];


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
    CGContextAddLineToPoint(contextSunLight, position.sunPoint.pointNow.x, position.sunPoint.pointNow.y);
    CGContextStrokePath(contextSunLight);
    
    CGContextRef contextMoonLight = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonLight, [UIColor colorWithRed:102/255.0 green:153/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonLight, 3.0);
    CGContextMoveToPoint(contextMoonLight, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextMoonLight, position.moonPoint.pointNow.x, position.moonPoint.pointNow.y);
    CGContextStrokePath(contextMoonLight);
    
    CGContextRef contextSunRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunRise, [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextSunRise, 3.0);
    CGContextSetLineDash(contextSunRise, 0.0f, kDashedLinesLength, 2.0f);
    CGContextMoveToPoint(contextSunRise, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextSunRise, position.sunPoint.pointRise.x, position.sunPoint.pointRise.y);
    CGContextStrokePath(contextSunRise);
    
    CGContextRef contextSunSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextSunSet, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextSunSet, 3.0);
    CGContextMoveToPoint(contextSunSet, position.sunPoint.pointSet.x, position.sunPoint.pointSet.y);
    CGContextAddLineToPoint(contextSunSet, centerAnnotationPoint, centerAnnotationPoint);
    CGContextStrokePath(contextSunSet);
    
    CGContextRef contextMoonRise = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonRise, [UIColor colorWithRed:51/255.0 green:153/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonRise, 3.0);
    CGContextMoveToPoint(contextMoonRise, centerAnnotationPoint, centerAnnotationPoint);
    CGContextAddLineToPoint(contextMoonRise, position.moonPoint.pointRise.x, position.moonPoint.pointRise.y);
    CGContextStrokePath(contextMoonRise);
    
    CGContextRef contextMoonSet = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextMoonSet, [UIColor colorWithRed:102/255.0 green:51/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(contextMoonSet, 3.0);
    CGContextMoveToPoint(contextMoonSet, position.moonPoint.pointSet.x, position.moonPoint.pointSet.y);
    CGContextAddLineToPoint(contextMoonSet, centerAnnotationPoint, centerAnnotationPoint);
    CGContextStrokePath(contextMoonSet);
}

- (void)initContentView
{
    CGSize imageSize = CGSizeMake(20, 20);
    
    UIImage *sunRiseImage = [UIImage imageNamed:@"icon_sun_rise.png"];
    sunRiseImageView = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(position.sunPoint.pointRise.x, position.sunPoint.pointRise.y, imageSize)];
    sunRiseImageView.image = sunRiseImage;
    [self addSubview:sunRiseImageView];
    
    UIImage *sunSetImage = [UIImage imageNamed:@"icon_sun_set.png"];
    sunSetImageView = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(position.sunPoint.pointSet.x, position.sunPoint.pointSet.y, imageSize)];
    sunSetImageView.image = sunSetImage;
    [self addSubview:sunSetImageView];
    
    UIImage *sunPosImage = [UIImage imageNamed:@"icon_current_sun.png"];
    sunPosImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position.sunPoint.pointNow.x, position.sunPoint.pointNow.y, 20, 20)];
    sunPosImageView.image = sunPosImage;
    [self addSubview:sunPosImageView];
    
    UIImage *moonRiseImage = [UIImage imageNamed:@"icon_moon_rise.png"];
    moonRiseImageView = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(position.moonPoint.pointRise.x, position.moonPoint.pointRise.y, imageSize)];
    moonRiseImageView.image = moonRiseImage;
    [self addSubview:moonRiseImageView];
    
    UIImage *moonSetImage = [UIImage imageNamed:@"icon_moon_set.png"];
    moonSetImageView = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(position.moonPoint.pointSet.x, position.moonPoint.pointSet.y, imageSize)];
    moonSetImageView.image = moonSetImage;
    [self addSubview:moonSetImageView];
    
    UIImage *moonPosImage = [UIImage imageNamed:@"icon_current_moon.png"];
    moonPosImageView = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(position.moonPoint.pointNow.x, position.moonPoint.pointNow.y, imageSize)];
    moonPosImageView.image = moonPosImage;
    [self addSubview:moonPosImageView];
    
    self.frame = CGRectMake(0, 0, centerAnnotationPoint*2, centerAnnotationPoint*2);
    self.backgroundColor = [UIColor clearColor];
}

- (void)reloadAnnotation
{
    CGPoint newCenter;
    CGPoint pointCenter = CGPointMake(centerAnnotationPoint, centerAnnotationPoint);
    
    if (CGPointEqualToPoint(position.moonPoint.pointRise, pointCenter)) {
        moonRiseImageView.hidden = YES;
    }
    else {
        moonRiseImageView.hidden = NO;
        newCenter = position.moonPoint.pointRise;
        moonRiseImageView.center = newCenter;
    }
    if (CGPointEqualToPoint(position.moonPoint.pointSet, pointCenter)) {
        moonSetImageView.hidden = YES;
    }
    else {
        moonSetImageView.hidden = NO;
        newCenter = position.moonPoint.pointSet;
        moonSetImageView.center = newCenter;
    }
    
    if (CGPointEqualToPoint(position.moonPoint.pointNow, pointCenter)) {
        moonPosImageView.hidden = YES;
    }
    else {
        moonPosImageView.hidden = NO;
        newCenter = position.moonPoint.pointNow ;
        moonPosImageView.center = newCenter;
    }
    
    // set up for Sun
    if (self.sunMoonAnnotation.isHiddenSunRise == YES) {
        position.sunPoint.pointRise = pointCenter;
    }
    if (CGPointEqualToPoint(position.sunPoint.pointRise, pointCenter)) {
        sunRiseImageView.hidden = YES;
    }
    else {
        sunRiseImageView.hidden = NO;
        newCenter = position.sunPoint.pointRise;
        sunRiseImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenSunSet == YES) {
        position.sunPoint.pointSet = pointCenter;
    }
    if (CGPointEqualToPoint(position.sunPoint.pointSet, pointCenter)) {
        sunSetImageView.hidden = YES;
    }
    else {
        sunSetImageView.hidden = NO;
        newCenter = position.sunPoint.pointSet;
        sunSetImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenSunPos == YES) {
        position.sunPoint.pointNow = pointCenter;
    }
    if (CGPointEqualToPoint(position.sunPoint.pointNow, pointCenter)) {
        sunPosImageView.hidden = YES;
    }
    else {
        sunPosImageView.hidden = NO;
        newCenter = position.sunPoint.pointNow;
        sunPosImageView.center = newCenter;
    }
    
    //set up for moon
    if (self.sunMoonAnnotation.isHiddenMoonRise == YES) {
        position.sunPoint.pointRise = pointCenter;
    }
    if (CGPointEqualToPoint(position.sunPoint.pointRise, pointCenter)) {
        moonRiseImageView.hidden = YES;
    }
    else {
        moonRiseImageView.hidden = NO;
        newCenter = position.sunPoint.pointRise;
        moonRiseImageView.center = newCenter;
    }
    
    if (self.sunMoonAnnotation.isHiddenMoonSet == YES) {
        position.sunPoint.pointSet = pointCenter;
    }
    if (CGPointEqualToPoint(position.sunPoint.pointSet, pointCenter) ) {
        moonSetImageView.hidden = YES;
    }
    else {
        moonSetImageView.hidden = NO;
        newCenter = position.sunPoint.pointSet;
        moonSetImageView.center = newCenter;
    }
    
    [self setNeedsDisplay];
}
- (void)didUpdateHeading:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    float newRad = [[userInfo objectForKey:@"newRad"]floatValue];
    _rotationAngle = newRad;
    self.transform = CGAffineTransformMakeRotation(newRad);

}

- (void)didStopRotationMaptool
{
    self.transform = CGAffineTransformMakeRotation(0);

}

@end
