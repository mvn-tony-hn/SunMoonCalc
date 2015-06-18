//
//  MapPinAnnotationView.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapPinAnnotation.h"
#import "Globals.h"

#define kPDPinAnnotationCenterDidChangeNotification     @"kPDPinAnnotationCenterDidChangeNotification"
#define kPDPinAnnotationCenterDidUnlockNotification     @"kPDPinAnnotationCenterDidUnlockNotification"
#define kPDPinAnnotationCenterDidLockNotification       @"kPDPinAnnotationCenterDidLockNotification"
@interface MapPinAnnotationView : MKAnnotationView {
    @private
    MKMapView *_mapView;
    
    CGPoint _startLocation;
    CGPoint _originalCenter;
    UIImageView *_pinShadow;
    NSTimer *_pinTimer;
}
+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
- (void)updateAnnotation:(MapPinAnnotation *)mapPinAnnotation;
@property (nonatomic, strong) MapPinAnnotation *mapPinAnnotation;


@end
