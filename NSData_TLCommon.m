//
//  NSData_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import "NSData_TLCommon.h"

@implementation NSData (TLCommon)

- (NSString *)UTF8String {
  return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}

@end
