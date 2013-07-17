//
//  CameraAnnotationView.h
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import <MapKit/MapKit.h>
#import "Globals.h"

@interface CameraAnnotationView : MKAnnotationView {
    @private
    MKMapView *_mapView;
    
    CGPoint _startLocation;
    CGPoint _originalCenter;
    UIImageView *_cameraShadow;
    UIImageView *_pointImage;
}
+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
@end
