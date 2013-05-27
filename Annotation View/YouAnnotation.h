//
//  YouAnnotation.h
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YouAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end