//
//  TLStyledTextFragment.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import <Foundation/Foundation.h>

@class TLStyledTextStyle;

@interface TLStyledTextFragment : NSObject {
@private
  NSString *text;
  TLStyledTextStyle *style;
  
  CGRect renderRect;
}

+ (TLStyledTextFragment *)fragment;

- (void)render;
- (CGFloat)width;
- (NSArray *)subfragmentsRenderableOnLinesOfWidth:(CGFloat)lineWidth
                                   firstLineWidth:(CGFloat)firstLineWidth;

@property(nonatomic, retain, readwrite) NSString *text;
@property(nonatomic, retain, readwrite) TLStyledTextStyle *style;
@property(nonatomic, assign, readwrite) CGRect renderRect;

@end
