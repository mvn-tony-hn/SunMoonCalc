//
//  CameraAnnotationView.m
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import "CameraAnnotationView.h"
#import "CameraAnnotation.h"
#import <QuartzCore/QuartzCore.h> // For CAAnimation

@interface CameraAnnotationView ()
@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, strong) UIImageView *	cameraShadow;
@property (nonatomic, strong) UIImageView *pointImage;
@property (nonatomic, strong) MKMapView *mapView;

+ (CAAnimation *)pinBounceAnimation_;
+ (CAAnimation *)pinFloatingAnimation_;
+ (CAAnimation *)pinLiftAnimation_;
+ (CAAnimation *)liftForDraggingAnimation_; // Used in touchesBegan:
+ (CAAnimation *)liftAndDropAnimation_;		// Used in touchesEnded: when touchesMoved: previous triggered
- (id)initWithAnnotation_:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
- (void)shadowLiftWillStart_:(NSString *)animationID context:(void *)context;
- (void)shadowDropDidStop_:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
//- (void)resetPinPosition_:(NSTimer *)timer;
- (void)pinAnnotationDidChangeToPoint:(CGPoint)point;
@end

@implementation CameraAnnotationView

@synthesize mapView = _mapView;
@synthesize startLocation = _startLocation;
@synthesize originalCenter = _originalCenter;
@synthesize cameraShadow = _cameraShadow;

+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
	
	return [[self alloc] initWithAnnotation_:annotation reuseIdentifier:reuseIdentifier mapView:mapView];
}

- (id)initWithAnnotation_:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.image = [UIImage imageNamed:@"Camera.png"];
		self.centerOffset = CGPointMake(2, -6);
		
		self.cameraShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CameraShadow.png"]];
		self.cameraShadow.frame = CGRectMake(0, 0, 33, 20);
		self.cameraShadow.hidden = YES;
		[self addSubview:self.cameraShadow];
		self.mapView = mapView;
	}
	return self;
}

#pragma mark -
#pragma mark Core Animation class methods

+ (CAAnimation *)pinBounceAnimation_ {
	
	CAKeyframeAnimation *pinBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	NSMutableArray *values = [NSMutableArray array];
    [values addObject:(id)[UIImage imageNamed:@"Camera.png"].CGImage];
	
	[pinBounceAnimation setValues:values];
	pinBounceAnimation.duration = 0.1;
	return pinBounceAnimation;
}

+ (CAAnimation *)pinBounceDropAnimation_ {
	
	CAKeyframeAnimation *pinBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	NSMutableArray *values = [NSMutableArray array];
    [values addObject:(id)[UIImage imageNamed:@"Camera.png"].CGImage];
	
	[pinBounceAnimation setValues:values];
	pinBounceAnimation.duration = 0.2;
	return pinBounceAnimation;
}
+ (CAAnimation *)pinFloatingAnimation_ {
	
	CAKeyframeAnimation *pinFloatingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	[pinFloatingAnimation setValues:[NSArray arrayWithObject:(id)[UIImage imageNamed:@"CameraFloating.png"].CGImage]];
	pinFloatingAnimation.duration = 0.2;
	
	return pinFloatingAnimation;
}

+ (CAAnimation *)pinFloatingDropAnimation_ {
	
	CAKeyframeAnimation *pinFloatingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
	
	[pinFloatingAnimation setValues:[NSArray arrayWithObject:(id)[UIImage imageNamed:@"CameraFloating.png"].CGImage]];
	pinFloatingAnimation.duration = 0.3;
	return pinFloatingAnimation;
}

+ (CAAnimation *)pinLiftAnimation_ {
	
	CABasicAnimation *liftAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	
	liftAnimation.byValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -29.0)];
	liftAnimation.duration = 0.2;
	return liftAnimation;
}

+ (CAAnimation *)pinLiftDropAnimation_ {
	
	CABasicAnimation *liftAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
	liftAnimation.byValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -15.0)];
    liftAnimation.duration = 0.3;
	return liftAnimation;
}

+ (CAAnimation *)liftForDraggingAnimation_ {
	
	CAAnimation *pinBounceAnimation = [CameraAnnotationView pinBounceAnimation_];
	CAAnimation *pinFloatingAnimation = [CameraAnnotationView pinFloatingAnimation_];
	pinFloatingAnimation.beginTime = pinBounceAnimation.duration;
	CAAnimation *pinLiftAnimation = [CameraAnnotationView pinLiftAnimation_];
	pinLiftAnimation.beginTime = pinBounceAnimation.duration;
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:pinBounceAnimation, pinFloatingAnimation, pinLiftAnimation, nil];
	group.duration = pinBounceAnimation.duration + pinFloatingAnimation.duration;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	
	return group;
}

+ (CAAnimation *)liftAndDropAnimation_ {
	
	CAAnimation *pinLiftAndDropAnimation = [CameraAnnotationView pinLiftDropAnimation_];
	CAAnimation *pinFloatingAnimation = [CameraAnnotationView pinFloatingDropAnimation_];
	CAAnimation *pinBounceAnimation = [CameraAnnotationView pinBounceDropAnimation_];
	pinBounceAnimation.beginTime = pinFloatingAnimation.duration;
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:pinLiftAndDropAnimation, pinFloatingAnimation, pinBounceAnimation, nil];
	group.duration = pinFloatingAnimation.duration + pinBounceAnimation.duration;
	
	return group;
}

#pragma mark -
#pragma mark UIView animation delegates

- (void)shadowLiftWillStart_:(NSString *)animationID context:(void *)context {
	self.cameraShadow.hidden = NO;
}

- (void)shadowDropDidStop_:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.cameraShadow.hidden = YES;
}

#pragma mark NSTimer fire method

- (void)resetPinPosition_:(NSTimer *)timer {
    
    [self.layer addAnimation:[CameraAnnotationView liftAndDropAnimation_] forKey:@"CameraAnimation"];
    
    // TODO: animation out-of-sync with self.layer
    [UIView beginAnimations:@"DDShadowLiftDropAnimation" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
    [UIView setAnimationDuration:0.1];
    self.cameraShadow.center = CGPointMake(90, -30);
    self.cameraShadow.center = CGPointMake(16.0, 19.5);
    self.cameraShadow.alpha = 0;
    [UIView commitAnimations];
    
    // Update the map coordinate to reflect the new position.
    CGPoint newCenter;
    newCenter.x = self.center.x - self.centerOffset.x;
    newCenter.y = self.center.y - self.centerOffset.y;
    
    CameraAnnotation *theAnnotation = (CameraAnnotation *)self.annotation;
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:newCenter toCoordinateFromView:self.superview];
    [theAnnotation setCoordinate:newCoordinate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDCameraAnnotationCenterDidChangeNotification
                                                        object:theAnnotation];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDCameraAnnotationCenterDidChangeNotification object:newLocation];
}
#pragma mark -
#pragma mark Handling events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.mapView) {
   
            
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCameraDidTochesBeganNotification object:nil];
        
		[self.layer removeAllAnimations];
		
		[self.layer addAnimation:[CameraAnnotationView liftForDraggingAnimation_] forKey:@"CameraAnimation"];
		
		[UIView beginAnimations:@"DDShadowLiftAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationWillStartSelector:@selector(shadowLiftWillStart_:context:)];
		[UIView setAnimationDuration:0.2];
		self.cameraShadow.center = CGPointMake(80, -20);
		self.cameraShadow.alpha = 1;
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
	if (self.mapView) {
		
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCameraDidTochesEndNotification object:nil];

        [self.layer addAnimation:[CameraAnnotationView liftAndDropAnimation_] forKey:@"CameraAnimation"];
        
        // TODO: animation out-of-sync with self.layer
        [UIView beginAnimations:@"DDShadowLiftDropAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
        [UIView setAnimationDuration:0.2];
        self.cameraShadow.center = CGPointMake(90, -30);
        self.cameraShadow.center = CGPointMake(16.0, 19.5);
        self.cameraShadow.alpha = 0;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPinAnnotationCameraDidTochesEndNotification object:nil];

		// TODO: Currently no drop down effect but pin bounce only
		[self.layer addAnimation:[CameraAnnotationView pinBounceAnimation_] forKey:@"CameraAnimation"];
		
		// TODO: animation out-of-sync with self.layer
		[UIView beginAnimations:@"DDShadowDropAnimation" context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(shadowDropDidStop_:finished:context:)];
		[UIView setAnimationDuration:0.1];
		self.cameraShadow.center = CGPointMake(16.0, 19.5);
		self.cameraShadow.alpha = 0;
		[UIView commitAnimations];
        

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

@end
