//
//  TLRand.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/23/09.
//

#import "TLRand.h"
#import "TLMersenneTwister.h"
#import <math.h>

#pragma mark -

@interface TLRand ()

@end


#pragma mark -

@implementation TLRand

+ (double)gaussianRandWithMean:(double)mean standardDeviation:(double)stddev min:(double)minValue max:(double)maxValue {
  double theta = [TLMersenneTwister randRealClosed] * 2.0f * M_PI;
  double radius = sqrt( -2.0f * log([TLMersenneTwister randRealClosed]) );
  double randToNormalize = radius * cos(theta);
  double normalizedRand = randToNormalize * stddev + mean;
  double truncatedRand = MIN(maxValue, MAX(minValue, normalizedRand));
  return truncatedRand;
}

@end
