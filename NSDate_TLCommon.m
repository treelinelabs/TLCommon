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
  return [NSString stringWithFormat:@"%f", [now timeIntervalSince1970]];
}

// modified from http://svn.cocoasourcecode.com/MGTwitterEngine/MGTwitterEngine.m
- (NSString *)HTTPString {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
  NSString *dateString = [dateFormatter stringFromDate:self];
  return dateString;
}

@end
