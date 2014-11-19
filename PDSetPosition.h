//
//  PDSetPosition.h
//  Pashadelic
//
//  Created by LongPD-PC on 11/18/14.
//
//

#import <Foundation/Foundation.h>
#import "PositionEntity.h"
#import "PDSunMoonEntity.h"
#import "PDSunMoonPoint.h"

@interface PDSetPosition : NSObject

@property (strong, nonatomic) PDSunMoonPoint *sunPoint;
@property (strong, nonatomic) PDSunMoonPoint *moonPoint;

- (PDSunMoonPoint *)setSun:(PDSunMoonEntity *)sunEntity dateFormatter:(NSDateFormatter *)dateFormatter;
- (PDSunMoonPoint *)setMoon:(PDSunMoonEntity *)moonEntity dateFormatter:(NSDateFormatter *)dateFormatter;

@end
