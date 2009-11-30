//
//  NSBundle_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/30/09.
//

#import "NSBundle_TLCommon.h"

@implementation NSBundle (TLCommon)

+ (NSString *)applicationVersion {
  return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
