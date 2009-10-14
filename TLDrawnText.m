//
//  TLDrawnText.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/14/09.
//

#import "TLDrawnText.h"
#import "CGGeometry_TLCommon.h"

#define kVeryTallText 1024.0f

#pragma mark -

@interface TLDrawnText ()

@end


#pragma mark -

@implementation TLDrawnText

@synthesize text;
@synthesize font;
@synthesize lineBreakMode;
@synthesize textAlignment;
@synthesize textColor;
@synthesize minimumTopPadding;
@synthesize flexibleTopPadding;
@synthesize minimumBottomPadding;
@synthesize flexibleBottomPadding;
@synthesize leftInset;
@synthesize rightInset;
@synthesize renderRect;

+ (TLDrawnText *)drawnText {
  return [[[self alloc] init] autorelease];
}

- (id)init {
  if(self = [super init]) {
    
  }
  return self;
}

- (CGSize)sizeWithWidth:(CGFloat)totalWidthIncludingSpaceForInsets {
  CGFloat widthAfterRemovingInsets = totalWidthIncludingSpaceForInsets - self.leftInset - self.rightInset;
  CGSize textRenderSize = [self.text sizeWithFont:self.font
                                constrainedToSize:CGSizeMake(widthAfterRemovingInsets, kVeryTallText)
                                    lineBreakMode:self.lineBreakMode];
  return CGSizeByAddingWidth(textRenderSize, self.leftInset + self.rightInset);
}

- (void)render {
  CGRect textRenderRect = CGRectMake(self.renderRect.origin.x + self.leftInset,
                                     self.renderRect.origin.y,
                                     self.renderRect.size.width - self.leftInset - self.rightInset,
                                     self.renderRect.size.height);
  [self.textColor setFill];
  [self.text drawInRect:textRenderRect
               withFont:self.font
          lineBreakMode:self.lineBreakMode
              alignment:self.textAlignment];
}


+ (void)layoutInRect:(CGRect)containingRect canOverflowBottomOfRect:(BOOL)rectCanBeMadeBigger texts:(TLDrawnText *)firstText, ... {
  va_list texts;
  NSUInteger numberOfFlexibleSections = 0;
  CGFloat minimumHeight = 0;
  
  // first pass -- gather layout information
  
  va_start(texts, firstText);
  BOOL previousTextHadFlexibleBottomPadding = NO;
  for(TLDrawnText *text = firstText; text != nil; text = va_arg(texts, TLDrawnText *)) {
    // count all flexible bottom paddings, but only count flexible top padding if the previous one didn't
    // have flexible bottom padding, since flexible top + flexible bottom size by side make just one
    // flexible section
    if(text.flexibleBottomPadding) {
      numberOfFlexibleSections++;
    }
    if(!previousTextHadFlexibleBottomPadding && text.flexibleTopPadding) {
      numberOfFlexibleSections++;
      previousTextHadFlexibleBottomPadding = YES;
    }
    
    // total up the minimum height required to render our text
    // use the renderRect as temp storage for the render size so we don't have to recalculate later
    // we're setting the renderRect anyway, so it is ok to use for our own purposes now
    text.renderRect = CGRectZeroWithSize([text sizeWithWidth:containingRect.size.width]);
    minimumHeight += text.minimumTopPadding + text.minimumBottomPadding + text.renderRect.size.height;
  }
  va_end(texts);

  // precalculate key layout variables
  
  CGFloat flexibleSectionHeight = 0.0f; // how tall is each flexible section?
  CGFloat scalingFactor = 1.0f; // if we are too tall but the containing rect is fixed in size, how much does each piece need to be scaled down?
  if(minimumHeight <= containingRect.size.height) {
    // we're ok; increase the flexible section height to take up the extra space
    if(numberOfFlexibleSections > 0) {
      flexibleSectionHeight = (containingRect.size.height - minimumHeight) / (float)numberOfFlexibleSections;
    }
  } else {
    // too big
    if(!rectCanBeMadeBigger) {
      // got to scale everything down by this factor to fit
      scalingFactor = containingRect.size.height / minimumHeight;
    }
  }

  // second pass -- actually lay out texts in accordance with flexible size and scaling factor
  
  va_start(texts, firstText);
  previousTextHadFlexibleBottomPadding = NO;
  CGFloat runningYOffset = 0;
  for(TLDrawnText *text = firstText; text != nil; text = va_arg(texts, TLDrawnText *)) {
    if(!previousTextHadFlexibleBottomPadding && text.flexibleTopPadding) {
      // need to add in flexible padding up top
      runningYOffset += MAX(flexibleSectionHeight, text.minimumTopPadding * scalingFactor);
    } else {
      runningYOffset += text.minimumTopPadding * scalingFactor;
    }

    // grab the text height before flooring occurs, so
    // flooring doesn't have a cumulative effect
    CGFloat renderedTextHeight = text.renderRect.size.height;
    
    // make sure renderRect is pixel-aligned for clearer text rendering;
    // use floor to make sure we don't accidentally overflow
    text.renderRect = CGRectFlooredToNearestPixel(CGRectMake(containingRect.origin.x,
                                                             runningYOffset,
                                                             text.renderRect.size.width,
                                                             text.renderRect.size.height * scalingFactor));

    runningYOffset += renderedTextHeight;
    
    if(text.flexibleBottomPadding) {
      // need to add in flexible padding below
      runningYOffset += MAX(flexibleSectionHeight, text.minimumBottomPadding * scalingFactor);
    } else {
      runningYOffset += text.minimumBottomPadding * scalingFactor;
    }
  }
  va_end(texts);
}

- (void)dealloc {
  [text release];
  text = nil;
  
  [font release];
  font = nil;
  
  [textColor release];
  textColor = nil;
  
  [super dealloc];
}

@end
