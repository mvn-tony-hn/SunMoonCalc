//
//  CameraAnnotationView.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
//

#import <MapKit/MapKit.h>
#define kPDCameraAnnotationCenterDidChangeNotification  @"kPDCameraAnnotationCenterDidChangeNotification"

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
