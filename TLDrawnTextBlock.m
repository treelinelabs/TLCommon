//
//  TLDrawnTextBlock.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLDrawnTextBlock.h"
#import "TLDrawnTextFragment.h"
#import "TLDrawnTextStyle.h"
#import "NSString_TLCommon.h"
#import "CGGeometry_TLCommon.h"
#import "TLMacros.h"

#pragma mark -

@interface TLDrawnTextBlock ()

- (CGFloat)maxFontHeightInLine:(NSArray *)line;

@property(nonatomic, retain, readwrite) NSMutableArray *lines;
@property(nonatomic, retain, readwrite) NSMutableDictionary *originalFragmentForNewFragment;
@property(nonatomic, retain, readwrite) NSMutableDictionary *newFragmentsForOriginalFragment;
@property(nonatomic, assign, readwrite) CGFloat lineWidth;

@end


#pragma mark -

@implementation TLDrawnTextBlock

@synthesize lines;
@synthesize lineWidth;
@synthesize originalFragmentForNewFragment;
@synthesize newFragmentsForOriginalFragment;

- (id)init {
  if(self = [super init]) {
    self.lines = [NSMutableArray array];
    self.originalFragmentForNewFragment = [NSMutableDictionary dictionary];
    self.newFragmentsForOriginalFragment = [NSMutableDictionary dictionary];
  }
  return self;
}

+ (TLDrawnTextBlock *)blockWithFragments:(NSArray *)textFragments lineWidth:(CGFloat)width {
  TLDrawnTextBlock *block = [[[TLDrawnTextBlock alloc] init] autorelease];
  block.lineWidth = width;
  
  NSMutableArray *currentLine = [NSMutableArray array];
  CGFloat currentLineWidth = block.lineWidth;  
  for(TLDrawnTextFragment *fragment in textFragments) {
    TLDebugLog(@"fragment %@", fragment);
    NSArray *subfragments = [fragment subfragmentsRenderableOnLinesOfWidth:block.lineWidth firstLineWidth:currentLineWidth];
    TLDebugLog(@"subfragments %@", subfragments);
    NSUInteger numberOfSubfragments = [subfragments count];
    for(NSUInteger i = 0; i < numberOfSubfragments; i++) {
      TLDrawnTextFragment *subfragment = [subfragments objectAtIndex:i];
      if(![subfragment isKindOfClass:[NSNull class]]) {
        [currentLine addObject:subfragment];
        currentLineWidth -= [subfragment width];
        [block.originalFragmentForNewFragment setObject:fragment forKey:[NSValue valueWithPointer:subfragment]];
      }
      if(i < numberOfSubfragments - 1) {
        // on the last line, wait for the first line of the next round to make a new line,
        // so they can share
        [block.lines addObject:currentLine];
        currentLine = [NSMutableArray array];
        currentLineWidth = block.lineWidth;
      }
    }
    [block.newFragmentsForOriginalFragment setObject:subfragments forKey:[NSValue valueWithPointer:fragment]];
  }
  // pick up the very last line which would otherwise be forgotten
  [block.lines addObject:currentLine];
  currentLine = [NSMutableArray array];

  // triming trailing whitespace on all lines
  TLDebugLog(@"lines %@", block.lines);
  for(NSArray *line in block.lines) {
    TLDebugLog(@"line %@", line);
    TLDrawnTextFragment *lastFragment = [line lastObject];
    lastFragment.text = [lastFragment.text stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  
  return block;
}

- (CGFloat)maxFontHeightInLine:(NSArray *)line {
  CGFloat maxFontHeight = 0.0f;
  for(TLDrawnTextFragment *fragment in line) {
    maxFontHeight = MAX(maxFontHeight, [fragment.style.font leading]);
  }
  return maxFontHeight;
}

- (CGFloat)height {
  CGFloat height = 0.0f;
  for(NSArray *line in self.lines) {
    height += [self maxFontHeightInLine:line];
  }
  return height;
}

- (void)renderAtPoint:(CGPoint)point textAlignment:(UITextAlignment)textAlignment {
  CGFloat runningYOffset = 0.0f;
  for(NSArray *line in self.lines) {
    CGFloat maxFontHeight = [self maxFontHeightInLine:line];
    CGFloat runningXOffset = 0.0f;
    for(TLDrawnTextFragment *fragment in line) {
      CGFloat fragmentWidth = [fragment width];
      CGFloat textAlignmentXOffset = 0;
      switch(textAlignment) {
        case UITextAlignmentLeft:;
          textAlignmentXOffset = 0;
          break;
        case UITextAlignmentCenter:;
          textAlignmentXOffset = self.lineWidth - fragmentWidth;
          break;
        case UITextAlignmentRight:;
          textAlignmentXOffset = floorf(OffsetToCenterFloatInFloat(fragmentWidth, self.lineWidth));
          break;
      }
      fragment.renderRect = CGRectMake(point.x + runningXOffset + textAlignmentXOffset,
                                       point.y + runningYOffset + OffsetToCenterFloatInFloat([fragment.style.font leading], maxFontHeight),
                                       fragmentWidth,
                                       maxFontHeight);
      [fragment render];
      runningXOffset += fragmentWidth;
    }
    runningYOffset += maxFontHeight;
  }
}

- (TLDrawnTextFragment *)fragmentAtPoint:(CGPoint)pointWithinTextBlock {
  // ick...do an exhaustive search
  for(NSArray *line in self.lines) {
    for(TLDrawnTextFragment *fragment in line) {
      if(CGRectContainsPoint(fragment.renderRect, pointWithinTextBlock)) {
        return fragment;
      }
    }
  }  
  return nil;
}

- (NSArray *)siblingFragmentsForFragment:(TLDrawnTextFragment *)fragment {
  TLDrawnTextFragment *originalFragment = [self originalFragmentForFragment:fragment];
  NSArray *newFragments = [self.newFragmentsForOriginalFragment objectForKey:[NSValue valueWithPointer:originalFragment]];
  return newFragments;
}

- (TLDrawnTextFragment *)originalFragmentForFragment:(TLDrawnTextFragment *)fragment {
  return [self.originalFragmentForNewFragment objectForKey:[NSValue valueWithPointer:fragment]];
}


- (void)dealloc {
  [lines release];
  lines = nil;
  
  [originalFragmentForNewFragment release];
  originalFragmentForNewFragment = nil;
  
  [newFragmentsForOriginalFragment release];
  newFragmentsForOriginalFragment = nil;
  
  [super dealloc];
}

@end
