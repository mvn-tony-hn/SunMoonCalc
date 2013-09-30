//
//  PDSunMoonview.h
//  Pashadelic
//
//  Created by LongPD on 9/24/13.
//
//

#import <UIKit/UIKit.h>
#import "PositionEntity.h"
#import "Globals.h"
#import "SunMoonCalcGobal.h"
#import "SunMoonAnnotation.h"

#define kPDSetUserTrackingModeNoneNotification       @"kPDSetUserTrackingModeNoneNotification"

static CGFloat const kDashedLinesLength[]   = {10.0f, 4.0f};

@interface PDSunMoonview : UIView{
    UIImageView *moonRiseImageView ;
    UIImageView *moonSetImageView ;
    UIImageView *moonPosImageView ;
    
    UIImageView *sunRiseImageView ;
    UIImageView *sunSetImageView ;
    UIImageView *sunPosImageView ;
}
@property (nonatomic, weak) PositionEntity *position;
@property (nonatomic, strong) SunMoonAnnotation *sunMoonAnnotation;
@property float rotationAngle;
- (void)initContentView;
- (void)reloadAnnotation;


@end
