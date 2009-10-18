//
//  UIColor_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/4/09.
//

#import <Foundation/Foundation.h>

@interface UIColor (TLCommon)

+ (UIColor *)colorWithCSSRed:(NSUInteger)red255 green:(NSUInteger)green255 blue:(NSUInteger)blue255;
+ (UIColor *)colorWithCSSString:(NSString *)cssColorString;

@end
