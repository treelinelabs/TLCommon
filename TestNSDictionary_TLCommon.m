//
//  TestNSDictionary_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/30/09.
//  Copyright 2009 Treeline Labs. All rights reserved.
//

#import "TestNSDictionary_TLCommon.h"
#import "NSDictionary_TLCommon.h"

@implementation TestNSDictionary_TLCommon

- (void)testDictionaryWithQueryString {
  
  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@""],
                       [NSDictionary dictionary],
                       @"Failed to parse empty query string");

  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"a="],
                       [NSDictionary dictionaryWithObject:@"" forKey:@"a"],
                       @"Empty value");

  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"a"],
                       [NSDictionary dictionary],
                       @"Segments missing = are ignored");
  
  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"a=b"],
                       [NSDictionary dictionaryWithObject:@"b" forKey:@"a"],
                       @"Failed to parse a=b");

  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"&&&a=b&&&"],
                       [NSDictionary dictionaryWithObject:@"b" forKey:@"a"],
                       @"Failed to parse &&&a=b&&&");

  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"a=b&a=c"],
                       [NSDictionary dictionaryWithObject:@"c" forKey:@"a"],
                       @"Later values for same key override previous values");
  
  NSString *encodedUrl = @"connect%26the%3Ddots%5B%5D%24!=easy&hard=beautiful%23%25%23!(%23*+%2Fart";
  NSDictionary *encodedResult = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"easy", @"connect&the=dots[]$!",
                          @"beautiful#%#!(#*+/art", @"hard",
                          nil];
  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:encodedUrl],
                       encodedResult,
                       @"Failed decoding url case");
  
  STAssertEqualObjects([NSDictionary dictionaryWithQueryString:@"a=%FF"],
                       [NSDictionary dictionaryWithObject:@"" forKey:@"a"],
                       @"Test invalid UTF8 characters");
}


@end
