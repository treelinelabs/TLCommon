//
//  NSMutableString_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/16/09.
//

#import "NSMutableString_TLCommon.h"


@implementation NSMutableString (TLCommon)

- (void)deleteSuffix:(NSString *)suffix {
  if([self hasSuffix:suffix]) {
    [self deleteCharactersInRange:NSMakeRange([self length] - [suffix length], [suffix length])];
  }
}

@end
