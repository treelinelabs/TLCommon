//
//  TLDrawnTextFragment.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLDrawnTextFragment.h"
#import "TLDrawnTextStyle.h"
#import "CGContext_TLCommon.h"
#import "NSString_TLCommon.h"

#pragma mark -

@interface TLDrawnTextFragment ()

@end


#pragma mark -

@implementation TLDrawnTextFragment

@synthesize text;
@synthesize style;
@synthesize renderRect;

+ (TLDrawnTextFragment *)fragment {
  return [[[self alloc] init] autorelease];
}

- (void)render {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  if(self.style.backgroundColor) {
    CGContextSaveGState(context); 
    [self.style.backgroundColor setFill];
    CGContextBeginPath(context);
    CGContextAddRoundedRectToPath(context, self.renderRect, self.style.backgroundCornerRadius, self.style.backgroundCornerRadius);
    CGContextClosePath(context);
    CGContextClip(context);
    UIRectFill(self.renderRect);
    CGContextRestoreGState(context);    
  }
  
  if(self.style.textColor) {
    [self.style.textColor setFill];
  }

  [self.text drawInRect:self.renderRect withFont:self.style.font];
  
  CGContextRestoreGState(context);
}

- (CGFloat)width {
  return [self.text sizeWithFont:self.style.font].width;
}

- (NSArray *)subfragmentsRenderableOnLinesOfWidth:(CGFloat)lineWidth
                                   firstLineWidth:(CGFloat)firstLineWidth {
  NSMutableArray *fragments = [NSMutableArray array];
  BOOL firstLine = YES;
  NSString *subtext = self.text;
  while([subtext length] > 0) {
    CGFloat width = firstLine ? firstLineWidth : lineWidth;
    NSUInteger prefixLength = [subtext lengthOfLongestPrefixThatRendersOnOneLineOfWidth:width
                                                                              usingFont:self.style.font];
    if(prefixLength == 0) {
      if(!firstLine) {
        // uh-oh...bail
        subtext = @"";        
      } else {
        [fragments addObject:[NSNull null]];
      }
    } else {
      TLDrawnTextFragment *newFragment = [TLDrawnTextFragment fragment];
      newFragment.style = self.style;
      newFragment.text = [subtext substringToIndex:prefixLength ];
      [fragments addObject:newFragment];
      subtext = [subtext substringFromIndex:prefixLength];
    }

    firstLine = NO;
  }
  return fragments;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: '%@', %@, %@>", NSStringFromClass([self class]), self, self.text, self.style, [NSValue valueWithCGRect:self.renderRect]];
}

- (void)dealloc {
  [text release];
  text = nil;
  
  [style release];
  style = nil;
  
  [super dealloc];
}

@end
