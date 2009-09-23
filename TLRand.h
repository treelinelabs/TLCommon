//
//  TLRand.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/23/09.
//

#import <Foundation/Foundation.h>


@interface TLRand : NSObject

// provides a normally distributed random number w/ the give mean and stddev, truncated to fall in the range [min,max]
// uses box-muller and trig calls rather than sampling to get a point in the unit circle, thereby opting
// for slower, constant time performance rather than faster but potentially variable performance (intended for games)
// also throws away one of the generated values, in order to keep this call simple
+ (double)gaussianRandWithMean:(double)mean standardDeviation:(double)stddev min:(double)minValue max:(double)maxValue;

@end
