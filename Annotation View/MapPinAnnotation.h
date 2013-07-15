//
//  MapPinAnnotation.h
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapPinAnnotation : MKPlacemark

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property BOOL allowMove;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end
