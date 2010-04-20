//
//  CLLocation_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/16/09.
//

#import "CLLocation_TLCommon.h"

#define kZeroComparisonEpsilon 100.0f // there's *nothing* within 100 meters of (0,0)

@implementation CLLocation (TLCommon)

+ (CLLocation *)locationZero {
  return [self locationWithLatitude:0.0f longitude:0.0f];
}

- (BOOL)isLocationZero {
#if __IPHONE_3_2
  return ([self distanceFromLocation:[[self class] locationZero]] < kZeroComparisonEpsilon);
#else
  return ([self getDistanceFrom:[[self class] locationZero]] < kZeroComparisonEpsilon);
#endif
}

+ (CLLocation *)locationWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lng {
  return [[[self alloc] initWithLatitude:lat longitude:lng] autorelease];
}


@end
