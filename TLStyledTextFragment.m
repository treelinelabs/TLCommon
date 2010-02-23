//
//  TLStyledTextFragment.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLStyledTextFragment.h"
#import "TLStyledTextStyle.h"
#import "CGContext_TLCommon.h"
#import "NSString_TLCommon.h"

#pragma mark -

@interface TLStyledTextFragment ()

@end


#pragma mark -

@implementation TLStyledTextFragment

@synthesize text;
@synthesize style;
@synthesize userInfo;
@synthesize renderRect;

+ (TLStyledTextFragment *)fragment {
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

  CGSize renderedTextSize = [self.text drawInRect:self.renderRect withFont:self.style.font];
  if(self.style.underlined) {
    UIRectFill(CGRectMake(self.renderRect.origin.x,
                          CGRectGetMaxY(self.renderRect) - 1.0f,
                          renderedTextSize.width,
                          1.0f));    
  }
  
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
      TLStyledTextFragment *newFragment = [TLStyledTextFragment fragment];
      newFragment.style = self.style;
      newFragment.text = [subtext substringToIndex:prefixLength];
      newFragment.userInfo = self.userInfo;
      [fragments addObject:newFragment];
      subtext = [subtext substringFromIndex:prefixLength];
    }

    firstLine = NO;
  }
  return fragments;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: '%@', %@, %@ -- %@>", NSStringFromClass([self class]), self, self.text, self.style, [NSValue valueWithCGRect:self.renderRect], self.userInfo];
}

- (void)dealloc {
  [text release];
  text = nil;
  
  [style release];
  style = nil;

  [userInfo release];
  userInfo = nil;
  
  [super dealloc];
}

@end
