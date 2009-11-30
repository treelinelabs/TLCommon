//
//  NSString_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSString_TLCommon.h"
#import "CGGeometry_TLCommon.h"
#import <CommonCrypto/CommonDigest.h>

static NSMutableCharacterSet *wordWrappingCharacterSet = nil;

@implementation NSString (TLCommon)

// Adapted from Three20
- (NSString *)md5 {
  const char *str = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(str, strlen(str), result);
  
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

- (NSString *)stringByURLEncodingAllCharacters {
  NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (CFStringRef)self,
                                                                                NULL,
                                                                                (CFStringRef)@"&()<>@,;:\\\"/[]?=+$|^~`{}",
                                                                                kCFStringEncodingUTF8);
  [encodedString autorelease];
  return encodedString;
}


- (NSString *)stringByURLDecodingAllCharacters {
  NSString *decodedString = (NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, (CFStringRef)@"");
  [decodedString autorelease];
  return decodedString;
}

- (NSRange)rangeOfSubstringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)set {
  NSCharacterSet *untrimmedCharacterSet = [set invertedSet];
  NSRange nonTrimmedCharacterRange = [self rangeOfCharacterFromSet:untrimmedCharacterSet
                                                           options:NSLiteralSearch | NSAnchoredSearch];
  NSRange trimmedRange;
  if(nonTrimmedCharacterRange.location == NSNotFound) {
    trimmedRange = [self completeRange];
  } else {
    trimmedRange = NSMakeRange(nonTrimmedCharacterRange.location, [self length] - nonTrimmedCharacterRange.location);
  }
  return trimmedRange;
}

- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)set {
  return [self substringWithRange:[self rangeOfSubstringByTrimmingPrefixCharactersInSet:set]];
}

- (NSRange)rangeOfSubstringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)set {
  NSCharacterSet *untrimmedCharacterSet = [set invertedSet];
  NSRange nonTrimmedCharacterRange = [self rangeOfCharacterFromSet:untrimmedCharacterSet
                                                           options:NSLiteralSearch | NSBackwardsSearch | NSAnchoredSearch];
  NSRange trimmedRange;
  if(nonTrimmedCharacterRange.location == NSNotFound) {
    trimmedRange = [self completeRange];
  } else {
    trimmedRange = NSMakeRange(0, nonTrimmedCharacterRange.location + 1); // add back in the chopped character
  }
  return trimmedRange;
}

- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)set {
  return [self substringWithRange:[self rangeOfSubstringByTrimmingSuffixCharactersInSet:set]];
}

- (NSRange)completeRange {
  return NSMakeRange(0, [self length]);
}

- (NSUInteger)lengthOfLongestPrefixThatRendersOnOneLineOfWidth:(CGFloat)lineWidth usingFont:(UIFont *)font {
  if(lineWidth <= 0) {
    return 0;
  }
  CGFloat lineHeight = [font leading];
  CGSize unboundedTextSize = CGSizeMake(lineWidth, CGFLOAT_MAX);
  
  if(!wordWrappingCharacterSet) {
    wordWrappingCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [wordWrappingCharacterSet addCharactersInString:@"-"];
    [wordWrappingCharacterSet retain];
  }
  
  NSUInteger min = 0;

  NSUInteger max = [self length]; // i'd like to intelligently reduce this to some maximum reasonable value (e.g. line width / max glyph width), but that looks unreasonably hard

  // because this is a common case, check to see whether it all fits on one line, in which case we're done
  CGSize renderedMaxSize = [self sizeWithFont:font constrainedToSize:unboundedTextSize]; // don't use the simpler sizeWithFont:, because otherwise I'd have to separately handle newline characters; this just works
  if(renderedMaxSize.height <= lineHeight) {
    return max;
  }

  while(YES) {
    // TODO: Make an intelligent guess here rather then just splitting down the middle
    NSUInteger current = (min >> 1) + (max >> 1) + (1 & min & max); // no overflows here! not that it matters...
    NSString *substring = [self substringToIndex:current];
    CGSize renderedSize = [substring sizeWithFont:font constrainedToSize:unboundedTextSize];
    if(renderedSize.height > lineHeight) {
      max = current;
    } else {
      min = current;
    }
    if(max - min <= 1) {
      // we've found the exact spot at which it changes from 1 line to 2 -- min is on 1 line, max is on 2
      // now we find the previous word wrapping character to this spot, since that's where the break
      // actually occurs.
      NSRange rangeOfWordWrappingCharacter = [self rangeOfCharacterFromSet:wordWrappingCharacterSet
                                                                   options:NSBackwardsSearch | NSLiteralSearch
                                                                     range:NSMakeRange(0, max)];
      NSUInteger divisionPoint = 0;
      if(rangeOfWordWrappingCharacter.location != NSNotFound) {
        divisionPoint = NSMaxRange(rangeOfWordWrappingCharacter);
      } else {
        // remaining string has no word breaks at all, so take the whole thing up to the cracking point
        divisionPoint = min;
      }
      return divisionPoint;
    }
  }
}

@end
