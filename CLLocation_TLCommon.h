//
//  CLLocation_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/16/09.
//

#import <Foundation/Foundation.h>

@interface CLLocation (TLCommon)

+ (CLLocation *)locationZero; // location at (0,0)
- (BOOL)isLocationZero; // is within a small epsilon of (0,0)

@end
