//
//  YouAnnotation.m
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import "YouAnnotation.h"

@implementation YouAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
	
	if (self = [super init]) {
        self.title = title;
		self.coordinate = coordinate;
	}
	return self;
}

@end
