//
//  MapPinAnnotationView.h
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import <MapKit/MapKit.h>
#define kPDPinAnnotationCenterDidChangeNotification     @"kPDPinAnnotationCenterDidChangeNotification"
@interface MapPinAnnotationView : MKAnnotationView {
    @private
    MKMapView *_mapView;
    
    BOOL _isMoving;
    CGPoint _startLocation;
    CGPoint _originalCenter;
    UIImageView *_pinShadow;
    NSTimer *_pinTimer;
}
+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
@end
