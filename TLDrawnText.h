//
//  TLDrawnText.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/14/09.
//

#import <Foundation/Foundation.h>


@interface TLDrawnText : NSObject {
@private
  // basic rendering parameters
  NSString *text;
  UIFont *font;
  UILineBreakMode lineBreakMode;
  UITextAlignment textAlignment;
  UIColor *textColor;

  // padding -- external
  CGFloat minimumTopPadding;
  BOOL flexibleTopPadding;
  
  CGFloat minimumBottomPadding;
  BOOL flexibleBottomPadding;
  
  // insets -- internal
  // these are used internally to calculate sizes and render
  CGFloat leftInset;
  CGFloat rightInset;
  
  // calculated properties
  CGRect renderRect; // includes insets
}

+ (TLDrawnText *)drawnText;

// the caller of this function should ignore any insets --
// they should pass the total width of the space available for text (including the insets)
// and will get back the total size of the space used for text (including the insets)
- (CGSize)sizeWithWidth:(CGFloat)totalWidthIncludingSpaceForInsets;

// the caller of this function should ignore any insets --
// they will be handled internally. they should set the render rect to include
// the total width of the space available for text (including the insets)
// this uses the renderRect to decide where to render.
//
// Returns the actual rect containing just the rendered text,
// including insets, text alignment, etc.
- (CGRect)render;

// sets the renderRect for a number of texts, according to their drawn text sizes and
// preferred padding. variadic to avoid requiring nsarray construction.
// it is expected that these are called w/in the render section of a tableviewcell
// and thus should not allocate space on the heap. with a careful
// use of static TLDrawnTexts, the entire rendering process should be able to take
// place solely with stack storage.
//
// The resulting renderRects are as wide as the containingRect. The actual location
// of the drawn text, including insets and text alignment, is returned from -render.
//
// Returns the total height of the laid out text and buffers.
+ (CGFloat)layoutInRect:(CGRect)containingRect
canOverflowBottomOfRect:(BOOL)rectCanBeMadeBigger
                  texts:(TLDrawnText *)firstText, ... NS_REQUIRES_NIL_TERMINATION;

// self.renderRect but adjusted for text insets
- (CGRect)insetAdjustedRenderRect;

@property(nonatomic, retain, readwrite) NSString *text;
@property(nonatomic, retain, readwrite) UIFont *font;
@property(nonatomic, assign, readwrite) UILineBreakMode lineBreakMode;
@property(nonatomic, assign, readwrite) UITextAlignment textAlignment;
@property(nonatomic, retain, readwrite) UIColor *textColor;
@property(nonatomic, assign, readwrite) CGFloat minimumTopPadding;
@property(nonatomic, assign, readwrite) BOOL flexibleTopPadding;
@property(nonatomic, assign, readwrite) CGFloat minimumBottomPadding;
@property(nonatomic, assign, readwrite) BOOL flexibleBottomPadding;
@property(nonatomic, assign, readwrite) CGFloat leftInset;
@property(nonatomic, assign, readwrite) CGFloat rightInset;
@property(nonatomic, assign, readwrite) CGRect renderRect;

@end
