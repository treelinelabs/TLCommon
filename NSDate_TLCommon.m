//
//  NSDate_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSDate_TLCommon.h"

@implementation NSDate (TLCommon)

+ (NSString *)unixTimestamp {
  NSDate *now = [NSDate date];
  return [NSString stringWithFormat:@"%f", [now timeIntervalSinceReferenceDate]];
}

@end
