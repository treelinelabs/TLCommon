//
//  NSString_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <Foundation/Foundation.h>

#define kSubstringRenderingRectKey @"rect"
#define kSubstringRenderingSubstringKey @"substring"

@interface NSString (TLCommon)

- (NSString *)md5;
- (NSString *)stringByURLEncodingAllCharacters; // including &, %, ?, =, and other url "safe" characters
- (NSString *)stringByURLDecodingAllCharacters;

// returns the range of the receiver containing the string arrived at by trimming characters from the beginning
- (NSRange)rangeOfSubstringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)set;
// like stringByTrimmingCharactersInSet, but only chops from the beginning, not the end
- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)set;

// returns the range of the receiver containing the string arrived at by trimming characters from the beginning
- (NSRange)rangeOfSubstringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)set;
// like stringByTrimmingCharactersInSet, but only chops from the end, not the beginning
- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)set;

// range containing entire string
- (NSRange)completeRange;

- (NSUInteger)lengthOfLongestPrefixThatRendersOnOneLineOfWidth:(CGFloat)lineWidth usingFont:(UIFont *)font;

@end
