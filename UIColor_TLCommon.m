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

@end
