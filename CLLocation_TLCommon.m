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
  return [[[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f] autorelease];
}

- (BOOL)isLocationZero {
  return ([self getDistanceFrom:[[self class] locationZero]] < kZeroComparisonEpsilon);
}

@end
