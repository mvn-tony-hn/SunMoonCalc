//
//  CameraAnnotation.h
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CameraAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end