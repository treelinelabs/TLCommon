//
//  NSMutableArray_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/13/09.
//

#import "NSMutableArray_TLCommon.h"
#import "TLMersenneTwister.h"

@implementation NSMutableArray (TLCommon)

// adapted from http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
- (void)shuffle {
  NSUInteger count = [self count];
  for(NSUInteger i = 0; i < count; ++i) {
    // Select a random element between i and end of array to swap with.
    NSUInteger nElements = count - i;
    NSUInteger n = ([TLMersenneTwister randInt32] % nElements) + i;
    [self exchangeObjectAtIndex:i withObjectAtIndex:n];
  }
}

@end
