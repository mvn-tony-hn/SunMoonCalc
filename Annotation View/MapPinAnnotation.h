//
//  MapPinAnnotation.h
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapPinAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end
