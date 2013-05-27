//
//  YouAnnotationView.h
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import <MapKit/MapKit.h>

@interface YouAnnotationView : MKAnnotationView

@property (nonatomic, strong) UIImageView *youImageView;
@property (nonatomic, strong) MKMapView *mapView;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
@end
