//
//  UIColor_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/4/09.
//

#import "UIColor_TLCommon.h"

@implementation UIColor (TLCommon)

+ (UIColor *)colorWithCSSRed:(NSUInteger)red255 green:(NSUInteger)green255 blue:(NSUInteger)blue255 {
  return [UIColor colorWithRed:(((float)red255) / 255.0f)
                         green:(((float)green255) / 255.0f)
                          blue:(((float)blue255) / 255.0f)
                         alpha:1.0f];
}

+ (UIColor *)colorWithCSSString:(NSString *)cssColorString {
  NSUInteger firstColorCharacter = [cssColorString hasPrefix:@"#"] ? 1 : 0;
  BOOL isValid = [cssColorString length] - firstColorCharacter == 3 || [cssColorString length] - firstColorCharacter == 6;
  if(!isValid) {
    return nil;
  }
  BOOL threeCharacters = [cssColorString length] - firstColorCharacter == 3;
  NSUInteger colorChunkSize = threeCharacters ? 1 : 2;
  CGFloat colorComponents[3] = {0.0f, 0.0f, 0.0f};
  for(NSUInteger colorOffset = 0; colorOffset < 3; colorOffset++) {
    NSString *colorSubstring = [cssColorString substringWithRange:NSMakeRange(firstColorCharacter + colorChunkSize * colorOffset, colorChunkSize)];
    if(threeCharacters) {
      colorSubstring = [colorSubstring stringByAppendingString:colorSubstring]; // duplicate if only three characters
    }
    long hexValue = strtol([colorSubstring cStringUsingEncoding:NSASCIIStringEncoding], NULL, 16);
    colorComponents[colorOffset] = (float)hexValue / 255.0f;
  }
  return [UIColor colorWithRed:colorComponents[0]
                         green:colorComponents[1]
                          blue:colorComponents[2]
                         alpha:1.0f];
}

@end
