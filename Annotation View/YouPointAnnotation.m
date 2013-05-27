//
//  YouPointAnnotation.m
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import "YouPointAnnotation.h"

@implementation YouPointAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end