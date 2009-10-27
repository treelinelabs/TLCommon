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

/****************************************/


// Breaks a string up into an array of substrings such that, if rendered using the given font, line width,
// and line break mode UILineBreakModeWordWrap, each substring would be rendered on a separate line.
//
// KNOWN ISSUE: When a single word is long enough to cover an entire line, the break point
// chosen by this method as the breaking point is sometimes off by a character or two.
// Workaround: Break up the line into multiple lines using this method, and then draw
// one line at a time, rather than the whole thing at once, using drawComponents:inRect:withFont:alignment:.
- (NSArray *)componentsByRenderingOntoSeparateLinesWithFont:(UIFont *)font
                                                  lineWidth:(CGFloat)lineWidth;

// Gives the subrect that would contain a particular substring of the receiver (given by its range)
// when rendered on a single line with the given font. May throw exceptions
// if the range is out of bounds.
//
// lineWidth is not used when textAlignment is UITextAlignmentLeft.
- (CGRect)rectForSubstringInRange:(NSRange)substringRange
                 renderedWithFont:(UIFont *)font
                        lineWidth:(CGFloat)lineWidth
                    textAlignment:(UITextAlignment)textAlignment;

// Returns information about where a particular substring of the receiver (given by its range)
// is rendered, when rendered potentially across multiple lines, of the provided line width,
// using the provided text alignment.
// May throw exceptions if the range runs out of bounds.
// If you are going to call this multiple times for a given string, consider calling
// -componentsByRenderingOntoSeparateLinesWithFont:lineWidth: and then calling
// +rectsForSubstringInRange:stringComponents:renderedWithFont:lineWidth:textAlignment: repeatedly instead,
// thereby preventing having to do the separation into multiple lines multiple times.
//
// Returns an NSArray of NSDictionaries. Each NSDictionary has two keys, kSubstringRenderingRectKey
// which contains an NSValue with the rect containing the rendered substring, and kSubstringRenderingSubstringKey
// which contains the actual part of the substring rendered there.
//
// KNOWN ISSUE: There are some issues around whitespace on non-first lines when using UITextAlignmentCenter.
// Workaround: Break up the line into multiple lines using componentsByRenderingOntoSeparateLinesWithFont:lineWidth:, and then draw
// one line at a time, rather than the whole thing at once, using drawComponents:inRect:withFont:alignment:.
- (NSArray *)rectsForSubstringInRange:(NSRange)substringRange
                     renderedWithFont:(UIFont *)font
                            lineWidth:(CGFloat)lineWidth
                        textAlignment:(UITextAlignment)textAlignment;

// See docs for -rectsForSubstringInRange:renderedWithFont:lineWidth:textAlignment:.
+ (NSArray *)rectsForSubstringInRange:(NSRange)substringRange
                     stringComponents:(NSArray *)targetStringDecomposedIntoSeparateLines
                     renderedWithFont:(UIFont *)font
                            lineWidth:(CGFloat)lineWidth
                        textAlignment:(UITextAlignment)textAlignment;

+ (void)drawComponents:(NSArray *)components
                inRect:(CGRect)rect
              withFont:(UIFont *)font
             alignment:(UITextAlignment)alignment;

// Returns an array of NSValues containing NSRanges corresponding to all components (demarcated
// by characters from separators with the given prefix
// present as substrings of the receiver, using stringCompareOptions when analyzing prefixes.
- (NSArray *)rangesOfComponentsPrefixed:(NSString *)prefix
         whenSeparatedByCharactersInSet:(NSCharacterSet *)separators
                                options:(NSStringCompareOptions)stringCompareOptions;

@end
