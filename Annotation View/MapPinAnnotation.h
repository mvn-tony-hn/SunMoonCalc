//
//  MapPinAnnotation.h
//
//  Created by TungNT (Tony) on 3/23/13.
//  Copyright (c) 2013 __Lifetimetech__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapPinAnnotation : MKPlacemark

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
@property BOOL allowMove;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end
