//
//  UITableViewCell_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/15/09.
//

#import <Foundation/Foundation.h>


@interface UITableViewCell (TLCommon)

+ (UIFont *)defaultTextLabelFontForCellStyle:(UITableViewCellStyle)cellStyle;
+ (UIFont *)defaultDetailTextLabelFontForCellStyle:(UITableViewCellStyle)cellStyle;

+ (UIColor *)defaultTextLabelColorForCellStyle:(UITableViewCellStyle)cellStyle;
+ (UIColor *)defaultDetailTextLabelColorForCellStyle:(UITableViewCellStyle)cellStyle;

@end
