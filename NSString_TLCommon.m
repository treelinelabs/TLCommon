//
//  NSString_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSString_TLCommon.h"
#import "CGGeometry_TLCommon.h"
#import <CommonCrypto/CommonDigest.h>

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
  CGFloat lineHeight = [font leading];
  CGSize unboundedTextSize = CGSizeMake(lineWidth, CGFLOAT_MAX);
  
  NSMutableCharacterSet *wordWrappingCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
  [wordWrappingCharacterSet addCharactersInString:@"-"];
  
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


/************************ INTEND TO DELETE *******************************/




- (NSArray *)componentsByRenderingOntoSeparateLinesWithFont:(UIFont *)font
                                                  lineWidth:(CGFloat)lineWidth {
  CGFloat lineHeight = [font leading];
  CGSize unboundedTextSize = CGSizeMake(lineWidth, CGFLOAT_MAX);

  NSMutableCharacterSet *wordWrappingCharacterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
  [wordWrappingCharacterSet addCharactersInString:@"-"];
  
  NSMutableArray *components = [NSMutableArray array];

  // chop off components one by one until we've exhausted the original string
  NSString *remainingString = self;
  while([remainingString length]) {
    // set up boundaries and check to see whether we can/should short-circuit here.
    // without these short-circuit checks, the loop logic gets more complex b/c of
    // handling the edge cases
    NSUInteger min = 1; // no point starting at 0, if the line can't hold one character, we're screwed anyway
    CGSize renderedMinSize = [[remainingString substringToIndex:min] sizeWithFont:font constrainedToSize:unboundedTextSize];
    if(renderedMinSize.height > lineHeight) {
      // bad news -- we can't even fit the first character on this line.
      // our line width must be pathologically short.
      // bail ungloriously with what we actually have managed to render so far.
      NSLog(@"%@ componentsByRenderingOntoSeparateLinesWithFont:%@ lineWidth:%f stuck at string %@, bailing out!", self, font, lineWidth, remainingString);
      return components;
    }
    NSUInteger max = [remainingString length]; // i'd like to intelligently reduce this to some maximum reasonable value (e.g. line width / max glyph width), but that looks unreasonably hard
    CGSize renderedMaxSize = [remainingString sizeWithFont:font constrainedToSize:unboundedTextSize]; // don't use the simpler sizeWithFont:, because otherwise I'd have to separately handle newline characters; this just works
    if(renderedMaxSize.height <= lineHeight) {
      // we're done!
      [components addObject:remainingString];
      break;
    }
    BOOL doneSearchingForDivisionPoint = NO;
    while(!doneSearchingForDivisionPoint) {
      NSUInteger current = (min >> 1) + (max >> 1) + (1 & min & max); // no overflows here! not that it matters...
      NSString *substring = [remainingString substringToIndex:current];
      CGSize renderedSize = [substring sizeWithFont:font constrainedToSize:unboundedTextSize];
      if(renderedSize.height > lineHeight) {
        max = current;
      } else {
        min = current;
      }
      if(max - min <= 1) {
        doneSearchingForDivisionPoint = YES;
        // we've found the exact spot at which it changes from 1 line to 2 -- min is on 1 line, max is on 2
        // now we find the previous word wrapping character to this spot, since that's where the break
        // actually occurs.
        NSRange rangeOfWordWrappingCharacter = [remainingString rangeOfCharacterFromSet:wordWrappingCharacterSet
                                                                                options:NSBackwardsSearch | NSLiteralSearch
                                                                                  range:NSMakeRange(0, max)];
        NSUInteger divisionPoint = 0;
        if(rangeOfWordWrappingCharacter.location != NSNotFound) {
          divisionPoint = NSMaxRange(rangeOfWordWrappingCharacter);
        } else {
          // remaining string has no word breaks at all, so take the whole thing up to the cracking point
          divisionPoint = min;
        }
        NSString *nextComponent = [remainingString substringToIndex:divisionPoint];
        [components addObject:nextComponent];
        remainingString = [remainingString substringFromIndex:divisionPoint];
      }
    }
  }
  
  return components; // no harm will be done if the receiver modifies this mutable array, so skip the needless copy/autorelease
}

- (CGRect)rectForSubstringInRange:(NSRange)substringRange
                 renderedWithFont:(UIFont *)font
                        lineWidth:(CGFloat)lineWidth
                    textAlignment:(UITextAlignment)textAlignment {
  NSString *trimmedString = self;
  NSRange trimmedRange = substringRange;
  switch(textAlignment) {
    case UITextAlignmentLeft:;
      break;
    case UITextAlignmentRight:;
      // when right-aligning text, the layout system eats trailing whitespace
      trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      NSRange fullRangeOfTrimmedString = NSMakeRange(0, [trimmedString length]);
      trimmedRange = NSIntersectionRange(fullRangeOfTrimmedString, substringRange);
      break;
    case UITextAlignmentCenter:;
      // for a *single line*, which is all we're discussing here, center-aligning text eats trailing whitespace, but leaves
      // leading whitespace intact
      trimmedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      fullRangeOfTrimmedString = NSMakeRange(0, [trimmedString length]);
      trimmedRange = NSIntersectionRange(fullRangeOfTrimmedString, substringRange);
      break;
  }

  CGFloat xOffset = 0;
  CGFloat width = 0;

  if(trimmedRange.length > 0) {
    CGSize sizeUpToSubstring = [[trimmedString substringToIndex:trimmedRange.location] sizeWithFont:font];;
    CGSize sizeIncludingSubstring = [[trimmedString substringToIndex:NSMaxRange(trimmedRange)] sizeWithFont:font];
    width = sizeIncludingSubstring.width - sizeUpToSubstring.width;
    switch(textAlignment) {
      case UITextAlignmentLeft:;
        xOffset = sizeUpToSubstring.width;
        break;
      case UITextAlignmentRight:;
        CGSize sizeOfEntireString = [trimmedString sizeWithFont:font];
        xOffset = lineWidth - (sizeOfEntireString.width - sizeUpToSubstring.width);
        break;
      case UITextAlignmentCenter:;
        sizeOfEntireString = [trimmedString sizeWithFont:font]; // declared in the previous case
        xOffset = (lineWidth - sizeOfEntireString.width) / 2.0f + sizeUpToSubstring.width;
        break;
    }
  }
    
  CGRect rectForSubstring = CGRectMake(xOffset, 0.0f, width, [font leading]);
  return rectForSubstring;
}

- (NSArray *)rectsForSubstringInRange:(NSRange)substringRange
                     renderedWithFont:(UIFont *)font
                            lineWidth:(CGFloat)lineWidth
                        textAlignment:(UITextAlignment)textAlignment {
  NSArray *components = [self componentsByRenderingOntoSeparateLinesWithFont:font lineWidth:lineWidth];
  NSArray *rects = [[self class] rectsForSubstringInRange:substringRange
                                         stringComponents:components
                                         renderedWithFont:font
                                                lineWidth:lineWidth
                                            textAlignment:textAlignment];
  return rects;
}

+ (NSArray *)rectsForSubstringInRange:(NSRange)substringRange
                     stringComponents:(NSArray *)targetStringDecomposedIntoSeparateLines
                     renderedWithFont:(UIFont *)font
                            lineWidth:(CGFloat)lineWidth
                        textAlignment:(UITextAlignment)textAlignment {
  // We need to find the ranges in the decomposed string that correspond to the original substring range, then find the rects for each of those
  CGFloat lineHeight = [font leading];
  NSUInteger numberOfLines = [targetStringDecomposedIntoSeparateLines count];
  NSMutableArray *rects = [NSMutableArray arrayWithCapacity:numberOfLines];
  NSRange adjustedSubstringRange = substringRange;
  for(NSUInteger i = 0; i < numberOfLines; i++) {
    NSString *line = [targetStringDecomposedIntoSeparateLines objectAtIndex:i];
    NSUInteger lineLength = [line length];
    NSRange intersectionRange = NSIntersectionRange(adjustedSubstringRange, NSMakeRange(0, lineLength));
    if(intersectionRange.length > 0) {
      // part of the string is in this line
      CGRect renderRect = [line rectForSubstringInRange:intersectionRange
                                       renderedWithFont:font
                                              lineWidth:lineWidth
                                          textAlignment:textAlignment];
      // adjust render rect for what line number we're on
      renderRect = CGRectByAddingYOffset(renderRect, lineHeight * (float)i);
      NSString *substring = [line substringWithRange:intersectionRange];
      NSDictionary *renderDetails = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSValue valueWithCGRect:renderRect], kSubstringRenderingRectKey,
                                     substring, kSubstringRenderingSubstringKey,
                                     nil];
      [rects addObject:renderDetails];
    }
    // shift our substring range to adjust for the fact that we're now ignoring the line we've just processed
    NSInteger newLocation = (adjustedSubstringRange.location - lineLength);
    if(newLocation < 0) {
      newLocation = 0;
    }
    NSInteger newLength = adjustedSubstringRange.length - intersectionRange.length; // remove any characters that have been processed
    adjustedSubstringRange = NSMakeRange(newLocation, newLength);
    if(adjustedSubstringRange.length == 0) {
      // bail now, our work is done
      break;
    }
  }

  return rects;
}

+ (void)drawComponents:(NSArray *)components
                inRect:(CGRect)rect
              withFont:(UIFont *)font
             alignment:(UITextAlignment)alignment {
  NSUInteger lineNumber = 0;
  for(NSString *line in components) {
    CGRect lineRect = CGRectByAddingYOffset(rect, (float)lineNumber * [font leading]);
    [line drawInRect:lineRect
            withFont:font
       lineBreakMode:UILineBreakModeClip
           alignment:alignment];
    lineNumber++;
  }
}

- (NSArray *)rangesOfComponentsPrefixed:(NSString *)prefix
         whenSeparatedByCharactersInSet:(NSCharacterSet *)separators
                                options:(NSStringCompareOptions)stringCompareOptions {
  NSMutableArray *wordRanges = [NSMutableArray array];
  NSUInteger length = [self length];
  BOOL doneFindingWords = NO;
  NSUInteger indexOfLastCharacterOfLastFoundWord = 0;
  while(!doneFindingWords) {
    NSRange wordRange = [self rangeOfString:prefix
                                    options:stringCompareOptions
                                      range:NSMakeRange(indexOfLastCharacterOfLastFoundWord, length - indexOfLastCharacterOfLastFoundWord)];
    // TODO: Check to make sure the scheme is at the beginning or prefixed w/ whitespace
    if(wordRange.location != NSNotFound) {
      // there's a word beginning at wordRange.location; now find its end
      NSRange wordEndingWhiteSpaceRange = [self rangeOfCharacterFromSet:separators
                                                                options:NSLiteralSearch
                                                                  range:NSMakeRange(wordRange.location, length - wordRange.location)];
      NSUInteger endOfWordIndex = (wordEndingWhiteSpaceRange.location == NSNotFound) ? length : wordEndingWhiteSpaceRange.location;
      NSRange completeWordRange = NSMakeRange(wordRange.location, endOfWordIndex - wordRange.location);
      [wordRanges addObject:[NSValue valueWithRange:completeWordRange]];
      indexOfLastCharacterOfLastFoundWord = NSMaxRange(wordEndingWhiteSpaceRange);
    } else {
      doneFindingWords = YES;
    }
  }
  return wordRanges;
}


@end
