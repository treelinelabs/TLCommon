//
//  TLDrawnTextFragment.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import <Foundation/Foundation.h>

@class TLDrawnTextStyle;

@interface TLDrawnTextFragment : NSObject {
@private
  NSString *text;
  TLDrawnTextStyle *style;
  
  CGRect renderRect;
}

+ (TLDrawnTextFragment *)fragment;

- (void)render;
- (CGFloat)width;
- (NSArray *)subfragmentsRenderableOnLinesOfWidth:(CGFloat)lineWidth
                                   firstLineWidth:(CGFloat)firstLineWidth;

@property(nonatomic, retain, readwrite) NSString *text;
@property(nonatomic, retain, readwrite) TLDrawnTextStyle *style;
@property(nonatomic, assign, readwrite) CGRect renderRect;

@end
