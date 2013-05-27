//
//  YouAnnotationView.m
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import "YouAnnotationView.h"

@implementation YouAnnotationView

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 38, 47);
        self.image = [UIImage imageNamed:@"icon_you_point.png"];
        self.mapView = mapView;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    self.center = touchPoint;
    CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.superview];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YouPointChangedNotifiaction" object:newLocation];
}
@end
