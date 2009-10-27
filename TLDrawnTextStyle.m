//
//  TLDrawnTextStyle.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLDrawnTextStyle.h"

#pragma mark -

@implementation TLDrawnTextStyle

@synthesize font;
@synthesize textColor;
@synthesize backgroundColor;
@synthesize backgroundCornerRadius;

+ (TLDrawnTextStyle *)style {
  return [[[self alloc] init] autorelease];
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
