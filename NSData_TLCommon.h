//
//  NSData_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import <Foundation/Foundation.h>


@interface NSData (TLCommon)

- (NSString *)UTF8String;

// MurmurHashNeutral2 is by Austin Appleby
// details at http://murmurhash.googlepages.com/
- (unsigned int)murmurHashNeutral2WithSeed:(unsigned int)seed;

@end
