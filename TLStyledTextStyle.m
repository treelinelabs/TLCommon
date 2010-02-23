//
//  TLStyledTextStyle.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLStyledTextStyle.h"

#pragma mark -

@implementation TLStyledTextStyle

@synthesize font;
@synthesize textColor;
@synthesize backgroundColor;
@synthesize backgroundCornerRadius;
@synthesize underlined;

+ (TLStyledTextStyle *)style {
  return [[[self alloc] init] autorelease];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: %@ %f, (%@), (%@), %f>",
          NSStringFromClass([self class]),
          self,
          [self.font fontName],
          [self.font pointSize],
          self.textColor,
          self.backgroundColor,
          self.backgroundCornerRadius];
}

- (void)dealloc {
  [font release];
  font = nil;
  
  [textColor release];
  textColor = nil;
  
  [backgroundColor release];
  backgroundColor = nil;
  
  [super dealloc];
}

@end
