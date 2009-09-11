//
//  BOOL_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 8/31/09.
//

#import <Foundation/Foundation.h>
#import "TLMersenneTwister.h"

static inline BOOL YESWithProbability(float floatBetweenZeroAndOne) {
  return ([TLMersenneTwister randRealClosed] < floatBetweenZeroAndOne);
}