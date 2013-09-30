//
//  MapPinAnnotation.m
//  Pashadelic
//
//  Created by TungNT2 on 5/17/13.
//
//

#import "MapPinAnnotation.h"

@implementation MapPinAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
	
	if (self) {
        self.title = title;
		self.coordinate = coordinate;
	}
	return self;
}

@end
