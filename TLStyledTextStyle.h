//
//  TLStyledTextStyle.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import <Foundation/Foundation.h>


@interface TLStyledTextStyle : NSObject {
@private
  UIFont *font;
  UIColor *textColor;
  UIColor *backgroundColor;
  CGFloat backgroundCornerRadius;
}

+ (TLStyledTextStyle *)style;

@property(nonatomic, retain, readwrite) UIFont *font;
@property(nonatomic, retain, readwrite) UIColor *textColor;
@property(nonatomic, retain, readwrite) UIColor *backgroundColor;
@property(nonatomic, assign, readwrite) CGFloat backgroundCornerRadius;

@end
