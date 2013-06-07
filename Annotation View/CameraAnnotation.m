//
//  YouPointAnnotation.m
//  Pashadelic
//
//  Created by TungNT2 on 5/22/13.
//
//

#import "CameraAnnotation.h"

@implementation CameraAnnotation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super initWithCoordinate:coordinate addressDictionary:nil];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end