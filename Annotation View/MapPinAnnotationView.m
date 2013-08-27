//
//  MapPinAnnotationView.m
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import "MapPinAnnotationView.h"
#import "MapPinAnnotation.h"
#import <QuartzCore/QuartzCore.h> // For CAAnimation
#import "NSDictionary+Extra.h"

@interface MapPinAnnotationView ()
@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, retain) UIImageView *	pinShadow;
@property (nonatomic, retain) NSTimer * pinTimer;
@property (nonatomic, retain) MKMapView *mapView;

+ (CAAnimation *)pinBounceAnimation_;
+ (CAAnimation *)pinFloatingAnimation_;
+ (CAAnimation *)pinLiftAnimation_;
+ (CAAnimation *)liftForDraggingAnimation_; // Used in touchesBegan:
+ (CAAnimation *)liftAndDropAnimation_;		// Used in touchesEnded: when touchesMoved: previous triggered
- (id)initWithAnnotation_:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
- (void)shadowLiftWillStart_:(NSString *)animationID context:(void *)context;
- (void)shadowDropDidStop_:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)resetPinPosition_:(NSTimer *)timer;
- (void)pinAnnotationDidChangeToPoint:(CGPoint)point;
@end

@implementation MapPinAnnotationView

@synthesize mapView = _mapView;
@synthesize startLocation = startLocation_;
@synthesize originalCenter = originalCenter_;
@synthesize pinShadow = pinShadow_;
@synthesize pinTimer = pinTimer_;

+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
	
	return [[self alloc] initWithAnnotation_:annotation reuseIdentifier:reuseIdentifier mapView:mapView];
}

- (id)initWithAnnotation_:(id <MKAnnotation> )annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
 
        self.mapPinAnnotation = (MapPinAnnotation *)annotation;
        
		self.image = [UIImage imageNamed:@"Pin.png"];
		self.centerOffset = CGPointMake(0, -2);
		self.pinShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PinShadow.png"]];
		self.pinShadow.frame = CGRectMake(0, 0, 26, 25);
		self.pinShadow.hidden = YES;
		[self addSubview:self.pinShadow];
		self.mapView = mapView;
        self.pinShadow.center = CGPointMake(45.0, 40.0);


	}
	
	return self;
}

#pragma mark -
#pragma mark Core Animation class methods

+ (CAAnimation *)pinBounceAnimation_ {
	
	CAKeyframeAnimation *pinBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	NSMutableArray *values = [NSMutableArray array];
    [values addObject:(id)[UIImage imageNamed:@"Pin.png"].CGImage];
	
	[pinBounceAnimation setValues:values];
	pinBounceAnimation.duration = 0.1;
	return pinBounceAnimation;
}

+ (CAAnimation *)pinBounceDropAnimation_ {
	
	CAKeyframeAnimation *pinBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	NSMutableArray *values = [NSMutableArray array];
    [values addObject:(id)[UIImage imageNamed:@"Pin.png"].CGImage];
	
	[pinBounceAnimation setValues:values];
	pinBounceAnimation.duration = 0.1;
	return pinBounceAnimation;
}
+ (CAAnimation *)pinFloatingAnimation_ {
	
	CAKeyframeAnimation *pinFloatingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	[pinFloatingAnimation setValues:[NSArray arrayWithObject:(id)[UIImage imageNamed:@"PinFloating.png"].CGImage]];
	pinFloatingAnimation.duration = 0.2;
	
	return pinFloatingAnimation;
}

+ (CAAnimation *)pinFloatingDropAnimation_ {
	
	CAKeyframeAnimation *pinFloatingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	[pinFloatingAnimation setValues:[NSArray arrayWithObject:(id)[UIImage imageNamed:@"PinFloating.png"].CGImage]];
	pinFloatingAnimation.duration = 0.2;
	return pinFloatingAnimation;
}

+ (CAAnimation *)pinLiftAnimation_ {
	
	CABasicAnimation *liftAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	
	liftAnimation.byValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
	liftAnimation.duration = 0.3;
	return liftAnimation;
}

+ (CAAnimation *)pinLiftDropAnimation_ {
	
	CABasicAnimation *liftAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
	liftAnimation.byValue = [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)];
    liftAnimation.duration = 0.3;
	return liftAnimation;
}

+ (CAAnimation *)liftForDraggingAnimation_ {
	
	CAAnimation *pinBounceAnimation = [MapPinAnnotationView pinBounceAnimation_];
	CAAnimation *pinFloatingAnimation = [MapPinAnnotationView pinFloatingAnimation_];
	pinFloatingAnimation.beginTime = pinBounceAnimation.duration;
	CAAnimation *pinLiftAnimation = [MapPinAnnotationView pinLiftAnimation_];
	pinLiftAnimation.beginTime = pinBounceAnimation.duration;
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:pinBounceAnimation, pinFloatingAnimation, pinLiftAnimation, nil];
	group.duration = pinBounceAnimation.duration + pinFloatingAnimation.duration;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	
	return group;
}

+ (CAAnimation *)liftAndDropAnimation_ {
	
	CAAnimation *pinLiftAndDropAnimation = [MapPinAnnotationView pinLiftDropAnimation_];
	CAAnimation *pinFloatingAnimation = [MapPinAnnotationView pinFloatingDropAnimation_];
	CAAnimation *pinBounceAnimation = [MapPinAnnotationView pinBounceDropAnimation_];
	pinBounceAnimation.beginTime = pinFloatingAnimation.duration;
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:pinLiftAndDropAnimation, pinFloatingAnimation, pinBounceAnimation, nil];
	group.duration = pinFloatingAnimation.duration + pinBounceAnimation.duration;
	
	return group;
}

#pragma mark -
#pragma mark UIView animation delegates

- (void)shadowLiftWillStart_:(NSString *)animationID context:(void *)context {
	self.pinShadow.hidden = NO;
}

- (void)shadowDropDidStop_:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.pinShadow.hidden = YES;
}

#pragma mark NSTimer fire method

- (void)resetPinPosition_:(NSTimer *)timer {
    
    [self.layer addAnimation:[MapPinAnnotationView liftAndDropAnimation_] forKey:@"MapPinAnimation"];
    
    // TODO: animation out-of-sync with self.layer
    [UIView beginAnimations:@"DDShadowLiftDropAnimation" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
    [UIView setAnimationDuration:0.1];
    self.pinShadow.center = CGPointMake(90, -30);
    self.pinShadow.center = CGPointMake(45.0, 40.0);
    self.pinShadow.alpha = 0;
    [UIView commitAnimations];
    
    // Update the map coordinate to reflect the new position.
    CGPoint newCenter;
    newCenter.x = self.center.x - self.centerOffset.x;
    newCenter.y = self.center.y - self.centerOffset.y;
    
    MapPinAnnotation *theAnnotation = (MapPinAnnotation *)self.annotation;
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:newCenter toCoordinateFromView:self.superview];
    [theAnnotation setCoordinate:newCoordinate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DDAnnotationCoordinateDidChangeNotification" object:theAnnotation];
    
    // Clean up the state information.
    self.startLocation = CGPointZero;
    self.originalCenter = CGPointZero;
}

- (void)pinAnnotationDidChangeToPoint:(CGPoint)point
{
    // Update the map coordinate to reflect the new position.
    CGPoint newCenter;
    newCenter.x = point.x - self.centerOffset.x;
    newCenter.y = point.y - self.centerOffset.y;
    
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:newCenter toCoordinateFromView:self.superview];
    
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCenterDidChangeNotification object:newLocation];
}
#pragma mark -
#pragma mark Handling events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.mapView) {

        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCenterDidTochesBeganNotification object:nil];

		[self.layer removeAllAnimations];
		
		[self.layer addAnimation:[MapPinAnnotationView liftForDraggingAnimation_] forKey:@"MapPinAnimation"];
		
		[UIView beginAnimations:@"DDShadowLiftAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationWillStartSelector:@selector(shadowLiftWillStart_:context:)];
		[UIView setAnimationDuration:0.2];
		self.pinShadow.center = CGPointMake(80, -20);
		self.pinShadow.alpha = 1;
		[UIView commitAnimations];
	}
	
	// The view is configured for single touches only.
	self.startLocation = [[touches anyObject] locationInView:self.superview];
	self.originalCenter = self.center;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint newLocation = [[touches anyObject] locationInView:self.superview];
	CGPoint newCenter;
	
	// If dragging has begun, adjust the position of the view.
	if (self.mapView /*&& self.isMoving*/) {
		
		newCenter.x = self.originalCenter.x + (newLocation.x - self.startLocation.x);
		newCenter.y = self.originalCenter.y + (newLocation.y - self.startLocation.y);
		
		self.center = newCenter;
        [self pinAnnotationDidChangeToPoint:self.center];
	} else {
		// Let the parent class handle it.
		[super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (self.mapView) {
        [self.layer addAnimation:[MapPinAnnotationView liftAndDropAnimation_] forKey:@"MapPinAnimation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCenterDidTochesEndNotification object:nil];

        // TODO: animation out-of-sync with self.layer
        [UIView beginAnimations:@"DDShadowLiftDropAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
        [UIView setAnimationDuration:0.2];
        self.pinShadow.center = CGPointMake(45.0, 40.0);
        self.pinShadow.alpha = 0;
        [UIView commitAnimations];
        
        // Update the map coordinate to reflect the new position.
        [self pinAnnotationDidChangeToPoint:self.center];
        
        // Clean up the state information.
        self.startLocation = CGPointZero;
        self.originalCenter = CGPointZero;
	} else {
		[super touchesEnded:touches withEvent:event];
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (self.mapView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCenterDidTochesEndNotification object:nil];

		// TODO: Currently no drop down effect but pin bounce only
		[self.layer addAnimation:[MapPinAnnotationView pinBounceAnimation_] forKey:@"MapPinAnimation"];
		
		// TODO: animation out-of-sync with self.layer
		[UIView beginAnimations:@"DDShadowDropAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
		[UIView setAnimationDuration:0.1];
		self.pinShadow.center = CGPointMake(45.0, 40.0);
		self.pinShadow.alpha = 0;
		[UIView commitAnimations];
        
        // Move the view back to its starting point.
        [self pinAnnotationDidChangeToPoint:self.center];
        // Clean up the state information.
        self.startLocation = CGPointZero;
        self.originalCenter = CGPointZero;
	} else {
		[super touchesCancelled:touches withEvent:event];
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self.superview bringSubviewToFront:self];
}

- (void)updateAnnotation:(MapPinAnnotation *)mapPinAnnotation
{
    [self.layer removeAllAnimations];
    self.pinShadow.center = CGPointMake(45.0, 40.0);
    self.pinShadow.hidden = YES;
    
}


- (void)dealloc
{

}

@end
