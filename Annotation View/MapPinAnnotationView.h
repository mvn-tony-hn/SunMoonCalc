//
//  MapPinAnnotationView.h
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import <MapKit/MapKit.h>
#import "MapPinAnnotation.h"
#import "Globals.h"

@interface MapPinAnnotationView : MKAnnotationView {
    @private
    MKMapView *_mapView;
    CGPoint _startLocation;
    CGPoint _originalCenter;
    UIImageView *_pinShadow;
    NSTimer *_pinTimer;
    float rotationAngle;

}
+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
- (void)updateAnnotation:(MapPinAnnotation *)mapPinAnnotation;
@property (nonatomic, strong) MapPinAnnotation *mapPinAnnotation;


@end
