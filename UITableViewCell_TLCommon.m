//
//  UITableViewCell_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/15/09.
//

#import "UITableViewCell_TLCommon.h"
#import "UIFont_TLCommon.h"

@implementation UITableViewCell (TLCommon)

+ (UIFont *)defaultTextLabelFontForCellStyle:(UITableViewCellStyle)cellStyle {
  UIFont *defaultFont = nil;
  switch(cellStyle) {
    case UITableViewCellStyleDefault:;
      defaultFont = [UIFont helveticaBoldWithSize:20.0f];
      break;
    case UITableViewCellStyleSubtitle:;
      defaultFont = [UIFont helveticaBoldWithSize:18.0f];
      break;
    case UITableViewCellStyleValue1:;
      defaultFont = [UIFont helveticaBoldWithSize:20.0f];
      break;
    case UITableViewCellStyleValue2:;
      defaultFont = [UIFont helveticaBoldWithSize:13.0f];
      break;
    default:;
      defaultFont = nil;
      break;
  }
  return defaultFont;
}

+ (UIFont *)defaultDetailTextLabelFontForCellStyle:(UITableViewCellStyle)cellStyle {
  UIFont *defaultFont = nil;
  switch(cellStyle) {
    case UITableViewCellStyleDefault:;
      defaultFont = nil;
      break;
    case UITableViewCellStyleSubtitle:;
      defaultFont = [UIFont helveticaBoldWithSize:14.0f];
      break;
    case UITableViewCellStyleValue1:;
      defaultFont = [UIFont helveticaWithSize:20.0f];
      break;
    case UITableViewCellStyleValue2:;
      defaultFont = [UIFont helveticaBoldWithSize:15.0f];
      break;
    default:;
      defaultFont = nil;
      break;
  }
  return defaultFont;  
}

+ (UIColor *)defaultTextLabelColorForCellStyle:(UITableViewCellStyle)cellStyle {
  UIColor *defaultColor = nil;
  switch(cellStyle) {
    case UITableViewCellStyleDefault:;
      defaultColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
      break;
    case UITableViewCellStyleSubtitle:;
      defaultColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
      break;
    case UITableViewCellStyleValue1:;
      defaultColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
      break;
    case UITableViewCellStyleValue2:;
      defaultColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
      break;
    default:;
      defaultColor = nil;
      break;
  }
  return defaultColor;
}

+ (UIColor *)defaultDetailTextLabelColorForCellStyle:(UITableViewCellStyle)cellStyle {
  UIColor *defaultColor = nil;
  switch(cellStyle) {
    case UITableViewCellStyleDefault:;
      defaultColor = nil;
      break;
    case UITableViewCellStyleSubtitle:;
      defaultColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
      break;
    case UITableViewCellStyleValue1:;
      defaultColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
      break;
    case UITableViewCellStyleValue2:;
      defaultColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
      break;
    default:;
      defaultColor = nil;
      break;
  }
  return defaultColor;
}

@end
